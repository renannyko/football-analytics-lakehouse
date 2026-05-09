/*
===============================================================================
Gold Team Defensive Metrics Pipeline
===============================================================================

Description:
    Gold materialized view responsible for aggregating defensive team-level
    metrics across matches and seasons.

    This model consolidates:
    - pressures
    - duels
    - fouls
    - goalkeeper actions
    - defensive activity indicators
    - defensive intensity metrics

    This dataset is optimized for:
    - Power BI defensive dashboards
    - tactical analysis
    - defensive performance comparisons
    - downstream KPI consumption

Project:
    Football Analytics Lakehouse

Layer:
    Gold

Source:
    football_dev.silver.pressures
    football_dev.silver.duels
    football_dev.silver.fouls
    football_dev.silver.goalkeeper_actions
    football_dev.silver.matches

Architecture:
    Silver Specialized Tables
        -> Gold Team Defensive Metrics
        -> Power BI / Tactical Analytics
===============================================================================
*/

CREATE OR REFRESH MATERIALIZED VIEW team_defensive_metrics

COMMENT "Gold analytical model containing defensive team-level KPIs."

AS

WITH pressures_agg AS (

    SELECT
        match_id,
        team_id,
        COUNT(*) AS total_pressures

    FROM football_dev.silver.pressures

    GROUP BY
        match_id,
        team_id
),

duels_agg AS (

    SELECT
        match_id,
        team_id,
        COUNT(*) AS total_duels

    FROM football_dev.silver.duels

    GROUP BY
        match_id,
        team_id
),

fouls_agg AS (

    SELECT
        match_id,
        team_id,
        COUNT(*) AS total_fouls

    FROM football_dev.silver.fouls

    GROUP BY
        match_id,
        team_id
),

goalkeeper_agg AS (

    SELECT
        match_id,
        team_id,
        COUNT(*) AS total_goalkeeper_actions

    FROM football_dev.silver.goalkeeper_actions

    GROUP BY
        match_id,
        team_id
),

team_matches AS (

    SELECT
        match_id,
        competition_name,
        season_name,
        match_date,

        home_team_id AS team_id,
        home_team_name AS team_name

    FROM football_dev.silver.matches

    UNION ALL

    SELECT
        match_id,
        competition_name,
        season_name,
        match_date,

        away_team_id AS team_id,
        away_team_name AS team_name

    FROM football_dev.silver.matches
)

SELECT
    -- Competition context
    tm.competition_name,
    tm.season_name,
    tm.match_date,

    -- Match identifiers
    tm.match_id,

    -- Team attributes
    tm.team_id,
    tm.team_name,

    -- Defensive metrics
    COALESCE(pa.total_pressures, 0) AS total_pressures,
    COALESCE(da.total_duels, 0) AS total_duels,
    COALESCE(fa.total_fouls, 0) AS total_fouls,
    COALESCE(ga.total_goalkeeper_actions, 0) AS total_goalkeeper_actions,

    -- Defensive intensity score
    (
        COALESCE(pa.total_pressures, 0) * 3
        + COALESCE(da.total_duels, 0) * 2
        + COALESCE(fa.total_fouls, 0)
        + COALESCE(ga.total_goalkeeper_actions, 0) * 4
    ) AS defensive_intensity_score,

    -- Technical metadata
    CURRENT_TIMESTAMP() AS gold_generated_timestamp

FROM team_matches tm

LEFT JOIN pressures_agg pa
    ON tm.match_id = pa.match_id
   AND tm.team_id = pa.team_id

LEFT JOIN duels_agg da
    ON tm.match_id = da.match_id
   AND tm.team_id = da.team_id

LEFT JOIN fouls_agg fa
    ON tm.match_id = fa.match_id
   AND tm.team_id = fa.team_id

LEFT JOIN goalkeeper_agg ga
    ON tm.match_id = ga.match_id
   AND tm.team_id = ga.team_id;