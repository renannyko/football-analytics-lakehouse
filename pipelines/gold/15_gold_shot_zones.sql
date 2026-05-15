/*
===============================================================================
Gold Shot Zones Pipeline
===============================================================================

Description:
    Gold materialized view responsible for aggregating shot spatial
    distributions for offensive and tactical analysis.

    The correct grain of this model is:
    - one match
    - one team
    - one player
    - one shot zone

Project:
    Football Analytics Lakehouse

Layer:
    Gold

Source:
    football_dev.silver.shots

Architecture:
    Silver Shots
        -> Gold Shot Zones
        -> Power BI / Spatial Offensive Analytics
===============================================================================
*/

CREATE OR REFRESH MATERIALIZED VIEW shot_zones

COMMENT "Gold analytical model containing spatial shot event distributions, shot density zones, goal conversion metrics, and average shot coordinates."

TBLPROPERTIES (
    'data_domain' = 'football_analytics',
    'data_layer' = 'gold',
    'data_product' = 'shot_zone_analytics',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'refresh_frequency' = 'on_pipeline_run',
    'business_purpose' = 'Provides spatial offensive shot density analytics for tactical maps, zone analysis, and Power BI dashboards.'
)

AS

WITH parsed_shots AS (

    SELECT
        -- Match identifiers
        match_id,

        -- Team attributes
        team_id,
        team_name,

        -- Player attributes
        player_id,
        player_name,

        -- Shot coordinates
        shot_location_x,
        shot_location_y,

        -- Extracted shot outcome from JSON string payload
        regexp_extract(
            shot_payload,
            '"outcome"\\s*:\\s*\\{[^}]*"name"\\s*:\\s*"([^"]+)"',
            1
        ) AS shot_outcome

    FROM football_dev.silver.shots

    WHERE
        match_id IS NOT NULL
        AND shot_location_x IS NOT NULL
        AND shot_location_y IS NOT NULL
)

SELECT
    -- Match identifiers
    match_id,

    -- Team attributes
    team_id,
    team_name,

    -- Player attributes
    player_id,
    player_name,

    -- Spatial bucketing
    FLOOR(shot_location_x / 10) * 10 AS shot_zone_x,
    FLOOR(shot_location_y / 10) * 10 AS shot_zone_y,

    -- Shot metrics
    COUNT(*) AS total_shots,

    SUM(
        CASE
            WHEN LOWER(shot_outcome) = 'goal'
                THEN 1
            ELSE 0
        END
    ) AS total_goals,

    -- Average coordinates
    ROUND(AVG(shot_location_x), 2) AS avg_shot_x,
    ROUND(AVG(shot_location_y), 2) AS avg_shot_y,

    -- Shot efficiency
    ROUND(
        SUM(
            CASE
                WHEN LOWER(shot_outcome) = 'goal'
                    THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        4
    ) AS goal_conversion_rate,

    -- Zone classification
    CASE
        WHEN COUNT(*) >= 15 THEN 'High Shot Density'
        WHEN COUNT(*) >= 8 THEN 'Medium Shot Density'
        ELSE 'Low Shot Density'
    END AS shot_density_zone,

    -- Technical metadata
    CURRENT_TIMESTAMP() AS gold_generated_timestamp

FROM parsed_shots

GROUP BY
    match_id,
    team_id,
    team_name,
    player_id,
    player_name,
    FLOOR(shot_location_x / 10) * 10,
    FLOOR(shot_location_y / 10) * 10;