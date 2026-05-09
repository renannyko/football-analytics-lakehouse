/*
===============================================================================
Gold Player Defensive Metrics Pipeline
===============================================================================

Description:
    Gold materialized view responsible for aggregating defensive player-level
    metrics for analytical and scouting consumption.

    This model consolidates:
    - pressures
    - duels
    - fouls
    - goalkeeper actions
    - defensive involvement
    - defensive intensity indicators

    This dataset is optimized for:
    - Power BI defensive dashboards
    - scouting analysis
    - defensive player comparisons
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

Architecture:
    Silver Specialized Tables
        -> Gold Player Defensive Metrics
        -> Power BI / Scouting Analytics
===============================================================================
*/

CREATE OR REFRESH MATERIALIZED VIEW player_defensive_metrics

COMMENT "Gold analytical model containing defensive player-level KPIs."

AS

WITH pressures_agg AS (

    SELECT
        player_id,
        player_name,
        team_id,
        team_name,

        COUNT(*) AS total_pressures

    FROM football_dev.silver.pressures

    GROUP BY
        player_id,
        player_name,
        team_id,
        team_name
),

duels_agg AS (

    SELECT
        player_id,

        COUNT(*) AS total_duels

    FROM football_dev.silver.duels

    GROUP BY
        player_id
),

fouls_agg AS (

    SELECT
        player_id,

        COUNT(*) AS total_fouls

    FROM football_dev.silver.fouls

    GROUP BY
        player_id
),

goalkeeper_agg AS (

    SELECT
        player_id,

        COUNT(*) AS total_goalkeeper_actions

    FROM football_dev.silver.goalkeeper_actions

    GROUP BY
        player_id
)

SELECT
    -- Team attributes
    pa.team_id,
    pa.team_name,

    -- Player attributes
    pa.player_id,
    pa.player_name,

    -- Defensive metrics
    pa.total_pressures,
    COALESCE(da.total_duels, 0) AS total_duels,
    COALESCE(fa.total_fouls, 0) AS total_fouls,
    COALESCE(ga.total_goalkeeper_actions, 0) AS total_goalkeeper_actions,

    -- Defensive involvement score
    (
        pa.total_pressures * 3
        + COALESCE(da.total_duels, 0) * 2
        + COALESCE(fa.total_fouls, 0)
        + COALESCE(ga.total_goalkeeper_actions, 0) * 4
    ) AS defensive_involvement_score,

    -- Technical metadata
    CURRENT_TIMESTAMP() AS gold_generated_timestamp

FROM pressures_agg pa

LEFT JOIN duels_agg da
    ON pa.player_id = da.player_id

LEFT JOIN fouls_agg fa
    ON pa.player_id = fa.player_id

LEFT JOIN goalkeeper_agg ga
    ON pa.player_id = ga.player_id;