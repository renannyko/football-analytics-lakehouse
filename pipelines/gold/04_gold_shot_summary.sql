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

COMMENT "Gold analytical model containing shot-level summaries and KPIs."

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