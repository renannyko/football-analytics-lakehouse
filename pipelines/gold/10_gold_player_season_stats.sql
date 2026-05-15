/*
===============================================================================
Gold Player Season Stats Pipeline
===============================================================================

Description:
    Gold materialized view responsible for aggregating player-level performance
    metrics across the selected competition and season.

    This model consolidates:
    - player participation
    - offensive actions
    - defensive actions
    - total actions
    - team context

    This dataset is optimized for:
    - Power BI player ranking dashboards
    - scouting analysis
    - season-level player summaries
    - downstream KPI consumption

Project:
    Football Analytics Lakehouse

Layer:
    Gold

Source:
    football_dev.gold.player_match_stats

Architecture:
    Gold Player Match Stats
        -> Gold Player Season Stats
        -> Power BI / Player Analytics
===============================================================================
*/

CREATE OR REFRESH MATERIALIZED VIEW player_season_stats

COMMENT "Gold analytical model containing season-level player performance KPIs, including match participation, offensive actions, defensive actions, total actions, and per-match averages."

TBLPROPERTIES (
    'data_domain' = 'football_analytics',
    'data_layer' = 'gold',
    'data_product' = 'player_season_analytics',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'refresh_frequency' = 'on_pipeline_run',
    'business_purpose' = 'Provides season-level player performance metrics for ranking dashboards, scouting analysis, and Power BI reporting.'
)

AS

SELECT
    -- Team attributes
    team_id,
    team_name,

    -- Player attributes
    player_id,
    player_name,

    -- Match participation
    COUNT(DISTINCT match_id) AS matches_with_events,

    -- Offensive KPIs
    SUM(total_shots) AS total_shots,
    SUM(total_passes) AS total_passes,
    SUM(total_carries) AS total_carries,
    SUM(total_dribbles) AS total_dribbles,

    -- Defensive KPIs
    SUM(total_pressures) AS total_pressures,
    SUM(total_duels) AS total_duels,

    -- Overall activity
    SUM(total_actions) AS total_actions,

    -- Per-match averages
    ROUND(SUM(total_shots) / COUNT(DISTINCT match_id), 2) AS avg_shots_per_match,
    ROUND(SUM(total_passes) / COUNT(DISTINCT match_id), 2) AS avg_passes_per_match,
    ROUND(SUM(total_actions) / COUNT(DISTINCT match_id), 2) AS avg_actions_per_match,

    -- Technical metadata
    CURRENT_TIMESTAMP() AS gold_generated_timestamp

FROM football_dev.gold.player_match_stats

GROUP BY
    team_id,
    team_name,
    player_id,
    player_name;