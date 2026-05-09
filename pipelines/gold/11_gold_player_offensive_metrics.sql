/*
===============================================================================
Gold Player Offensive Metrics Pipeline
===============================================================================

Description:
    Gold materialized view responsible for aggregating offensive player-level
    metrics for analytical and scouting consumption.

    This model consolidates:
    - shots
    - passes
    - carries
    - dribbles
    - offensive involvement
    - attacking intensity indicators

    This dataset is optimized for:
    - Power BI offensive dashboards
    - scouting analysis
    - attacking player comparisons
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

Architecture:
    Silver Specialized Tables
        -> Gold Player Offensive Metrics
        -> Power BI / Scouting Analytics
===============================================================================
*/

CREATE OR REFRESH MATERIALIZED VIEW player_offensive_metrics

COMMENT "Gold analytical model containing offensive player-level KPIs."

AS

WITH shots_agg AS (

    SELECT
        player_id,
        player_name,
        team_id,
        team_name,

        COUNT(*) AS total_shots

    FROM football_dev.silver.shots

    GROUP BY
        player_id,
        player_name,
        team_id,
        team_name
),

passes_agg AS (

    SELECT
        player_id,

        COUNT(*) AS total_passes

    FROM football_dev.silver.passes

    GROUP BY
        player_id
),

carries_agg AS (

    SELECT
        player_id,

        COUNT(*) AS total_carries

    FROM football_dev.silver.carries

    GROUP BY
        player_id
),

dribbles_agg AS (

    SELECT
        player_id,

        COUNT(*) AS total_dribbles

    FROM football_dev.silver.dribbles

    GROUP BY
        player_id
)

SELECT
    -- Team attributes
    sa.team_id,
    sa.team_name,

    -- Player attributes
    sa.player_id,
    sa.player_name,

    -- Offensive metrics
    sa.total_shots,
    COALESCE(pa.total_passes, 0) AS total_passes,
    COALESCE(ca.total_carries, 0) AS total_carries,
    COALESCE(da.total_dribbles, 0) AS total_dribbles,

    -- Offensive involvement score
    (
        sa.total_shots * 5
        + COALESCE(pa.total_passes, 0)
        + COALESCE(ca.total_carries, 0) * 2
        + COALESCE(da.total_dribbles, 0) * 3
    ) AS offensive_involvement_score,

    -- Technical metadata
    CURRENT_TIMESTAMP() AS gold_generated_timestamp

FROM shots_agg sa

LEFT JOIN passes_agg pa
    ON sa.player_id = pa.player_id

LEFT JOIN carries_agg ca
    ON sa.player_id = ca.player_id

LEFT JOIN dribbles_agg da
    ON sa.player_id = da.player_id;