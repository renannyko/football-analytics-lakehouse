/*
===============================================================================
Gold Match Dimension Pipeline
===============================================================================

Description:
    Gold materialized view responsible for creating the official match dimension
    used by Power BI and downstream analytical models.

    This dimension consolidates match-level descriptive attributes and provides
    a stable match lookup table for star schema modeling.

    This dataset is optimized for:
    - Power BI semantic modeling
    - star schema relationships
    - match-level filtering
    - competition and season analysis

Project:
    Football Analytics Lakehouse

Layer:
    Gold

Source:
    football_dev.gold.match_summary

Architecture:
    Gold Analytical Models
        -> Gold Match Dimension
        -> Power BI Semantic Model
===============================================================================
*/

CREATE OR REFRESH MATERIALIZED VIEW dim_match

COMMENT "Gold dimension containing unique football matches for semantic modeling."

AS

SELECT DISTINCT
    -- Match identifiers
    match_id,

    -- Competition context
    competition_id,
    competition_name,

    -- Season context
    season_id,
    season_name,

    -- Match timing
    match_date,
    kick_off,
    match_week,

    -- Home team attributes
    home_team_id,
    home_team_name,
    home_score,

    -- Away team attributes
    away_team_id,
    away_team_name,
    away_score,

    -- Match outcome
    match_result,
    result_type,
    scoreline,

    -- Venue context
    stadium_name,
    referee_name,

    -- Technical metadata
    CURRENT_TIMESTAMP() AS gold_generated_timestamp

FROM football_dev.gold.match_summary

WHERE match_id IS NOT NULL;