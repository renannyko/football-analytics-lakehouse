/*
===============================================================================
Gold Pressure Zones Pipeline
===============================================================================

Description:
    Gold materialized view responsible for aggregating pressure event spatial
    distributions for tactical and defensive analysis.

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

COMMENT "Gold analytical model containing spatial pressure event distributions."

AS

SELECT
    -- Team attributes
    team_id,
    team_name,

    -- Player attributes
    player_id,
    player_name,

    -- Spatial bucketing
    FLOOR(pressure_location_x / 10) * 10 AS pressure_zone_x,
    FLOOR(pressure_location_y / 10) * 10 AS pressure_zone_y,

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

FROM football_dev.silver.pressures

WHERE
    pressure_location_x IS NOT NULL
    AND pressure_location_y IS NOT NULL

GROUP BY
    team_id,
    team_name,
    player_id,
    player_name,
    FLOOR(pressure_location_x / 10) * 10,
    FLOOR(pressure_location_y / 10) * 10;