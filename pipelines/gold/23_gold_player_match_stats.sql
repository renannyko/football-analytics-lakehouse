/*
===============================================================================
Gold Player Match Stats Pipeline
===============================================================================

Description:
    Gold materialized view responsible for providing player-level match
    performance metrics for Power BI and downstream analytical consumption.

    The correct grain of this model is:
    - one match
    - one team
    - one player

    This model consolidates:
    - total actions
    - shots
    - passes
    - carries
    - dribbles
    - pressures
    - duels
    - fouls
    - goalkeeper actions

    This dataset is optimized for:
    - player match analysis
    - top player rankings
    - tactical dashboards
    - scouting-style reporting
    - future ML feature engineering

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
    football_dev.silver.fouls
    football_dev.silver.goalkeeper_actions

Architecture:
    Silver Event Models
        -> Gold Player Match Stats
        -> Power BI / Player Analytics
===============================================================================
*/

CREATE OR REFRESH MATERIALIZED VIEW player_match_stats

COMMENT "Gold analytical model containing player-level match performance KPIs, including total actions, offensive actions, defensive actions, shots, passes, carries, dribbles, pressures, duels, fouls, and goalkeeper actions."

TBLPROPERTIES (
    'data_domain' = 'football_analytics',
    'data_layer' = 'gold',
    'data_product' = 'player_match_analytics',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'refresh_frequency' = 'on_pipeline_run',
    'business_purpose' = 'Provides player-level match performance metrics for tactical analysis, scouting-style reporting, Power BI dashboards, and future machine learning feature engineering.'
)

AS

WITH base_players AS (

    SELECT DISTINCT
        -- Match identifiers
        match_id,

        -- Team attributes
        team_id,
        team_name,

        -- Player attributes
        player_id,
        player_name

    FROM football_dev.silver.events

    WHERE player_id IS NOT NULL
),

events_agg AS (

    SELECT
        match_id,
        team_id,
        player_id,

        COUNT(*) AS total_actions

    FROM football_dev.silver.events

    WHERE player_id IS NOT NULL

    GROUP BY
        match_id,
        team_id,
        player_id
),

shots_agg AS (

    SELECT
        match_id,
        team_id,
        player_id,

        COUNT(*) AS total_shots

    FROM football_dev.silver.shots

    GROUP BY
        match_id,
        team_id,
        player_id
),

passes_agg AS (

    SELECT
        match_id,
        team_id,
        player_id,

        COUNT(*) AS total_passes

    FROM football_dev.silver.passes

    GROUP BY
        match_id,
        team_id,
        player_id
),

carries_agg AS (

    SELECT
        match_id,
        team_id,
        player_id,

        COUNT(*) AS total_carries

    FROM football_dev.silver.carries

    GROUP BY
        match_id,
        team_id,
        player_id
),

dribbles_agg AS (

    SELECT
        match_id,
        team_id,
        player_id,

        COUNT(*) AS total_dribbles

    FROM football_dev.silver.dribbles

    GROUP BY
        match_id,
        team_id,
        player_id
),

pressures_agg AS (

    SELECT
        match_id,
        team_id,
        player_id,

        COUNT(*) AS total_pressures

    FROM football_dev.silver.pressures

    GROUP BY
        match_id,
        team_id,
        player_id
),

duels_agg AS (

    SELECT
        match_id,
        team_id,
        player_id,

        COUNT(*) AS total_duels

    FROM football_dev.silver.duels

    GROUP BY
        match_id,
        team_id,
        player_id
),

fouls_agg AS (

    SELECT
        match_id,
        team_id,
        player_id,

        COUNT(*) AS total_fouls

    FROM football_dev.silver.fouls

    GROUP BY
        match_id,
        team_id,
        player_id
),

goalkeeper_agg AS (

    SELECT
        match_id,
        team_id,
        player_id,

        COUNT(*) AS total_goalkeeper_actions

    FROM football_dev.silver.goalkeeper_actions

    GROUP BY
        match_id,
        team_id,
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

    -- Player match metrics
    COALESCE(ea.total_actions, 0) AS total_actions,
    COALESCE(sa.total_shots, 0) AS total_shots,
    COALESCE(pa.total_passes, 0) AS total_passes,
    COALESCE(ca.total_carries, 0) AS total_carries,
    COALESCE(da.total_dribbles, 0) AS total_dribbles,
    COALESCE(pra.total_pressures, 0) AS total_pressures,
    COALESCE(dua.total_duels, 0) AS total_duels,
    COALESCE(fa.total_fouls, 0) AS total_fouls,
    COALESCE(ga.total_goalkeeper_actions, 0) AS total_goalkeeper_actions,

    -- Derived metrics
    (
        COALESCE(sa.total_shots, 0)
        + COALESCE(pa.total_passes, 0)
        + COALESCE(ca.total_carries, 0)
        + COALESCE(da.total_dribbles, 0)
    ) AS offensive_actions,

    (
        COALESCE(pra.total_pressures, 0)
        + COALESCE(dua.total_duels, 0)
        + COALESCE(fa.total_fouls, 0)
        + COALESCE(ga.total_goalkeeper_actions, 0)
    ) AS defensive_actions,

    -- Technical metadata
    CURRENT_TIMESTAMP() AS gold_generated_timestamp

FROM base_players bp

LEFT JOIN events_agg ea
    ON bp.match_id = ea.match_id
   AND bp.team_id = ea.team_id
   AND bp.player_id = ea.player_id

LEFT JOIN shots_agg sa
    ON bp.match_id = sa.match_id
   AND bp.team_id = sa.team_id
   AND bp.player_id = sa.player_id

LEFT JOIN passes_agg pa
    ON bp.match_id = pa.match_id
   AND bp.team_id = pa.team_id
   AND bp.player_id = pa.player_id

LEFT JOIN carries_agg ca
    ON bp.match_id = ca.match_id
   AND bp.team_id = ca.team_id
   AND bp.player_id = ca.player_id

LEFT JOIN dribbles_agg da
    ON bp.match_id = da.match_id
   AND bp.team_id = da.team_id
   AND bp.player_id = da.player_id

LEFT JOIN pressures_agg pra
    ON bp.match_id = pra.match_id
   AND bp.team_id = pra.team_id
   AND bp.player_id = pra.player_id

LEFT JOIN duels_agg dua
    ON bp.match_id = dua.match_id
   AND bp.team_id = dua.team_id
   AND bp.player_id = dua.player_id

LEFT JOIN fouls_agg fa
    ON bp.match_id = fa.match_id
   AND bp.team_id = fa.team_id
   AND bp.player_id = fa.player_id

LEFT JOIN goalkeeper_agg ga
    ON bp.match_id = ga.match_id
   AND bp.team_id = ga.team_id
   AND bp.player_id = ga.player_id;