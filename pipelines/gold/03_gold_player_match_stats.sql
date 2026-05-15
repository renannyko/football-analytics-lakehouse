/*
===============================================================================
Gold Player Match Stats Pipeline
===============================================================================

Description:
    Gold materialized view responsible for providing player-level match
    statistics and KPIs for analytical consumption.

    This model consolidates:
    - player participation
    - shots and passing volume
    - dribbles and carries
    - pressure actions
    - duel participation
    - offensive and defensive contributions

    This dataset is optimized for:
    - Power BI dashboards
    - player performance analysis
    - scouting and tactical reporting
    - downstream KPI consumption

Project:
    Football Analytics Lakehouse

Layer:
    Gold

Source:
    football_dev.silver.events
    football_dev.silver.shots
    football_dev.silver.passes
    football_dev.silver.carries
    football_dev.silver.dribbles
    football_dev.silver.pressures
    football_dev.silver.duels

Architecture:
    Silver Specialized Tables
        -> Gold Player Match Stats
        -> Power BI / Scouting Analytics
===============================================================================
*/

CREATE OR REFRESH MATERIALIZED VIEW player_match_stats

COMMENT "Gold analytical model containing player-level match KPIs, including offensive actions, defensive actions, total actions, shots, passes, carries, dribbles, pressures, and duels."

TBLPROPERTIES (
    'data_domain' = 'football_analytics',
    'data_layer' = 'gold',
    'data_product' = 'player_analytics',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'refresh_frequency' = 'on_pipeline_run',
    'business_purpose' = 'Provides player-level match performance metrics for scouting, tactical analysis, and Power BI dashboards.'
)

AS

WITH base_players AS (

    SELECT DISTINCT
        match_id,
        team_id,
        team_name,
        player_id,
        player_name

    FROM football_dev.silver.events

    WHERE player_id IS NOT NULL
),

shots_agg AS (

    SELECT
        match_id,
        player_id,

        COUNT(*) AS total_shots

    FROM football_dev.silver.shots

    GROUP BY
        match_id,
        player_id
),

passes_agg AS (

    SELECT
        match_id,
        player_id,

        COUNT(*) AS total_passes

    FROM football_dev.silver.passes

    GROUP BY
        match_id,
        player_id
),

carries_agg AS (

    SELECT
        match_id,
        player_id,

        COUNT(*) AS total_carries

    FROM football_dev.silver.carries

    GROUP BY
        match_id,
        player_id
),

dribbles_agg AS (

    SELECT
        match_id,
        player_id,

        COUNT(*) AS total_dribbles

    FROM football_dev.silver.dribbles

    GROUP BY
        match_id,
        player_id
),

pressures_agg AS (

    SELECT
        match_id,
        player_id,

        COUNT(*) AS total_pressures

    FROM football_dev.silver.pressures

    GROUP BY
        match_id,
        player_id
),

duels_agg AS (

    SELECT
        match_id,
        player_id,

        COUNT(*) AS total_duels

    FROM football_dev.silver.duels

    GROUP BY
        match_id,
        player_id
)

SELECT
    -- Match identifiers
    bp.match_id,

    -- Team attributes
    bp.team_id,
    bp.team_name,

    -- Player attributes
    bp.player_id,
    bp.player_name,

    -- Offensive KPIs
    COALESCE(sa.total_shots, 0) AS total_shots,
    COALESCE(pa.total_passes, 0) AS total_passes,
    COALESCE(ca.total_carries, 0) AS total_carries,
    COALESCE(da.total_dribbles, 0) AS total_dribbles,

    -- Defensive KPIs
    COALESCE(pra.total_pressures, 0) AS total_pressures,
    COALESCE(dua.total_duels, 0) AS total_duels,

    -- Total actions KPI
    (
        COALESCE(sa.total_shots, 0)
        + COALESCE(pa.total_passes, 0)
        + COALESCE(ca.total_carries, 0)
        + COALESCE(da.total_dribbles, 0)
        + COALESCE(pra.total_pressures, 0)
        + COALESCE(dua.total_duels, 0)
    ) AS total_actions,

    -- Technical metadata
    CURRENT_TIMESTAMP() AS gold_generated_timestamp

FROM base_players bp

LEFT JOIN shots_agg sa
    ON bp.match_id = sa.match_id
   AND bp.player_id = sa.player_id

LEFT JOIN passes_agg pa
    ON bp.match_id = pa.match_id
   AND bp.player_id = pa.player_id

LEFT JOIN carries_agg ca
    ON bp.match_id = ca.match_id
   AND bp.player_id = ca.player_id

LEFT JOIN dribbles_agg da
    ON bp.match_id = da.match_id
   AND bp.player_id = da.player_id

LEFT JOIN pressures_agg pra
    ON bp.match_id = pra.match_id
   AND bp.player_id = pra.player_id

LEFT JOIN duels_agg dua
    ON bp.match_id = dua.match_id
   AND bp.player_id = dua.player_id;