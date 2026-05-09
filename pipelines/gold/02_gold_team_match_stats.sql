/*
===============================================================================
Gold Team Match Stats Pipeline
===============================================================================

Description:
    Gold materialized view responsible for providing team-level match
    statistics and KPIs for analytical consumption.

    This model consolidates:
    - match participation
    - goals scored and conceded
    - shots and shot outcomes
    - passing volume
    - possession-related metrics
    - match performance indicators

    This dataset is optimized for:
    - Power BI dashboards
    - team performance analysis
    - tactical reporting
    - downstream KPI consumption

Project:
    Football Analytics Lakehouse

Layer:
    Gold

Source:
    football_dev.silver.matches
    football_dev.silver.shots
    football_dev.silver.passes

Architecture:
    Silver Specialized Tables
        -> Gold Team Match Stats
        -> Power BI / Tactical Analytics
===============================================================================
*/

CREATE OR REFRESH MATERIALIZED VIEW team_match_stats

COMMENT "Gold analytical model containing team-level match KPIs."

AS

WITH shots_agg AS (

    SELECT
        match_id,
        team_id,

        COUNT(*) AS total_shots

    FROM football_dev.silver.shots

    GROUP BY
        match_id,
        team_id
),

passes_agg AS (

    SELECT
        match_id,
        team_id,

        COUNT(*) AS total_passes

    FROM football_dev.silver.passes

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
        home_team_name AS team_name,

        home_score AS goals_scored,
        away_score AS goals_conceded,

        'Home' AS match_side

    FROM football_dev.silver.matches

    UNION ALL

    SELECT
        match_id,
        competition_name,
        season_name,
        match_date,

        away_team_id AS team_id,
        away_team_name AS team_name,

        away_score AS goals_scored,
        home_score AS goals_conceded,

        'Away' AS match_side

    FROM football_dev.silver.matches
)

SELECT
    -- Match identifiers
    tm.match_id,

    -- Competition context
    tm.competition_name,
    tm.season_name,
    tm.match_date,

    -- Team attributes
    tm.team_id,
    tm.team_name,
    tm.match_side,

    -- Match KPIs
    tm.goals_scored,
    tm.goals_conceded,

    COALESCE(sa.total_shots, 0) AS total_shots,
    COALESCE(pa.total_passes, 0) AS total_passes,

    -- Goal differential
    tm.goals_scored - tm.goals_conceded AS goal_difference,

    -- Match points
    CASE
        WHEN tm.goals_scored > tm.goals_conceded THEN 3
        WHEN tm.goals_scored = tm.goals_conceded THEN 1
        ELSE 0
    END AS match_points,

    -- Technical metadata
    CURRENT_TIMESTAMP() AS gold_generated_timestamp

FROM team_matches tm

LEFT JOIN shots_agg sa
    ON tm.match_id = sa.match_id
   AND tm.team_id = sa.team_id

LEFT JOIN passes_agg pa
    ON tm.match_id = pa.match_id
   AND tm.team_id = pa.team_id;