/*
===============================================================================
Gold Team Offensive Metrics Pipeline
===============================================================================

Description:
    Gold materialized view responsible for aggregating offensive team-level
    metrics across matches and seasons.

    This model consolidates:
    - shots
    - passes
    - carries
    - dribbles
    - attacking activity indicators
    - offensive intensity metrics

    This dataset is optimized for:
    - Power BI offensive dashboards
    - tactical analysis
    - attacking performance comparisons
    - downstream KPI consumption

Project:
    Football Analytics Lakehouse

Layer:
    Gold

Source:
    football_dev.silver.shots
    football_dev.silver.passes
    football_dev.silver.carries
    football_dev.silver.dribbles
    football_dev.silver.matches

Architecture:
    Silver Specialized Tables
        -> Gold Team Offensive Metrics
        -> Power BI / Tactical Analytics
===============================================================================
*/

CREATE OR REFRESH MATERIALIZED VIEW team_offensive_metrics

COMMENT "Gold analytical model containing offensive team-level KPIs."

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

carries_agg AS (

    SELECT
        match_id,
        team_id,
        COUNT(*) AS total_carries

    FROM football_dev.silver.carries

    GROUP BY
        match_id,
        team_id
),

dribbles_agg AS (

    SELECT
        match_id,
        team_id,
        COUNT(*) AS total_dribbles

    FROM football_dev.silver.dribbles

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

    -- Offensive metrics
    COALESCE(sa.total_shots, 0) AS total_shots,
    COALESCE(pa.total_passes, 0) AS total_passes,
    COALESCE(ca.total_carries, 0) AS total_carries,
    COALESCE(da.total_dribbles, 0) AS total_dribbles,

    -- Offensive intensity score
    (
        COALESCE(sa.total_shots, 0) * 5
        + COALESCE(pa.total_passes, 0)
        + COALESCE(ca.total_carries, 0) * 2
        + COALESCE(da.total_dribbles, 0) * 3
    ) AS offensive_intensity_score,

    -- Technical metadata
    CURRENT_TIMESTAMP() AS gold_generated_timestamp

FROM team_matches tm

LEFT JOIN shots_agg sa
    ON tm.match_id = sa.match_id
   AND tm.team_id = sa.team_id

LEFT JOIN passes_agg pa
    ON tm.match_id = pa.match_id
   AND tm.team_id = pa.team_id

LEFT JOIN carries_agg ca
    ON tm.match_id = ca.match_id
   AND tm.team_id = ca.team_id

LEFT JOIN dribbles_agg da
    ON tm.match_id = da.match_id
   AND tm.team_id = da.team_id;