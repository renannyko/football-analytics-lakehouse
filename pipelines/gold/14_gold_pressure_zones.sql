/*
===============================================================================
Gold Pressure Zones Pipeline
===============================================================================

Description:
    Gold materialized view responsible for aggregating pressure event spatial
    distributions for tactical and defensive analysis.

    The correct grain of this model is:
    - one match
    - one five-minute time window
    - one team
    - one player
    - one pressure zone

    This model consolidates:
    - pressure locations
    - defensive pressure density
    - team pressing behavior
    - player pressing zones

    This dataset is optimized for:
    - Power BI heatmaps
    - defensive tactical analysis
    - pressing intensity dashboards
    - spatial event visualization

Project:
    Football Analytics Lakehouse

Layer:
    Gold

Source:
    football_dev.silver.pressures

Architecture:
    Silver Pressures
        -> Gold Pressure Zones
        -> Power BI / Spatial Tactical Analytics
===============================================================================
*/

CREATE OR REFRESH MATERIALIZED VIEW pressure_zones

COMMENT "Gold analytical model containing spatial pressure event distributions, defensive pressure density, pressure zones, and pressing intensity indicators."

TBLPROPERTIES (
    'data_domain' = 'football_analytics',
    'data_layer' = 'gold',
    'data_product' = 'pressure_zone_analytics',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'refresh_frequency' = 'on_pipeline_run',
    'business_purpose' = 'Provides spatial defensive pressure analytics for tactical heatmaps, pressing analysis, and Power BI dashboards.'
)

AS

WITH pressure_base AS (

    SELECT
        -- Match identifiers
        match_id,

        -- Shared temporal semantic key
        CONCAT(
            CAST(match_id AS STRING),
            '_',
            CAST(FLOOR(minute / 5) * 5 AS STRING)
        ) AS match_time_window_key,

        -- Match timing
        FLOOR(minute / 5) * 5 AS minute_window_start,
        FLOOR(minute / 5) * 5 + 4 AS minute_window_end,

        CONCAT(
            CAST(FLOOR(minute / 5) * 5 AS STRING),
            '-',
            CAST(FLOOR(minute / 5) * 5 + 4 AS STRING),
            ' min'
        ) AS minute_window_label,

        -- Team attributes
        team_id,
        team_name,

        -- Player attributes
        player_id,
        player_name,

        -- Pressure coordinates
        pressure_location_x,
        pressure_location_y,

        -- Spatial bucketing
        FLOOR(pressure_location_x / 10) * 10 AS pressure_zone_x,
        FLOOR(pressure_location_y / 10) * 10 AS pressure_zone_y

    FROM football_dev.silver.pressures

    WHERE
        match_id IS NOT NULL
        AND pressure_location_x IS NOT NULL
        AND pressure_location_y IS NOT NULL
)

SELECT
    -- Match identifiers
    match_id,
    match_time_window_key,

    -- Match timing
    minute_window_start,
    minute_window_end,
    minute_window_label,

    -- Team attributes
    team_id,
    team_name,

    -- Player attributes
    player_id,
    player_name,

    -- Spatial bucketing
    pressure_zone_x,
    pressure_zone_y,

    -- Pressure metrics
    COUNT(*) AS total_pressures,

    -- Average coordinates
    ROUND(AVG(pressure_location_x), 2) AS avg_pressure_x,
    ROUND(AVG(pressure_location_y), 2) AS avg_pressure_y,

    -- Pressure intensity classification
    CASE
        WHEN COUNT(*) >= 20 THEN 'High Pressure Zone'
        WHEN COUNT(*) >= 10 THEN 'Medium Pressure Zone'
        ELSE 'Low Pressure Zone'
    END AS pressure_intensity_zone,

    -- Technical metadata
    CURRENT_TIMESTAMP() AS gold_generated_timestamp

FROM pressure_base

GROUP BY
    match_id,
    match_time_window_key,
    minute_window_start,
    minute_window_end,
    minute_window_label,
    team_id,
    team_name,
    player_id,
    player_name,
    pressure_zone_x,
    pressure_zone_y;