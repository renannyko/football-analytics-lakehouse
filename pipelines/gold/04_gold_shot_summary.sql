/*
===============================================================================
Gold Shot Summary Pipeline
===============================================================================

Description:
    Gold materialized view responsible for providing shot-level analytical
    summaries and KPIs for reporting and tactical analysis.

Project:
    Football Analytics Lakehouse

Layer:
    Gold

Source:
    football_dev.silver.shots

Architecture:
    Silver Shots
        -> Gold Shot Summary
        -> Power BI / Offensive Analytics
===============================================================================
*/

CREATE OR REFRESH MATERIALIZED VIEW shot_summary

COMMENT "Gold analytical model containing shot-level summaries, shot outcomes, goal indicators, spatial coordinates, and offensive tactical KPIs."

TBLPROPERTIES (
    'data_domain' = 'football_analytics',
    'data_layer' = 'gold',
    'data_product' = 'shot_analytics',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'refresh_frequency' = 'on_pipeline_run',
    'business_purpose' = 'Provides shot-level offensive analytics for tactical reporting, Power BI dashboards, and future advanced modeling.'
)

AS

SELECT
    -- Match identifiers
    match_id,

    -- Team attributes
    team_id,
    team_name,

    -- Player attributes
    player_id,
    player_name,

    -- Match timing
    period,
    minute,
    second,

    -- Shot location
    shot_location_x,
    shot_location_y,

    -- Extracted shot attributes from JSON string payload
    regexp_extract(
        shot_payload,
        '"outcome"\\s*:\\s*\\{[^}]*"name"\\s*:\\s*"([^"]+)"',
        1
    ) AS shot_outcome,

    -- Shot outcome classification
    CASE
        WHEN LOWER(
            regexp_extract(
                shot_payload,
                '"outcome"\\s*:\\s*\\{[^}]*"name"\\s*:\\s*"([^"]+)"',
                1
            )
        ) = 'goal'
            THEN 1
        ELSE 0
    END AS is_goal,

    -- Raw shot payload preserved for deeper future modeling
    shot_payload,

    -- Shot metadata
    under_pressure,
    play_pattern_name,

    -- Technical metadata
    source_system,
    ingestion_timestamp,
    CURRENT_TIMESTAMP() AS gold_generated_timestamp

FROM football_dev.silver.shots;