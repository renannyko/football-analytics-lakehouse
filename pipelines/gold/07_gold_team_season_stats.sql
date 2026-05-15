/*
===============================================================================
Gold Team Season Stats Pipeline
===============================================================================

Description:
    Gold materialized view responsible for aggregating team-level performance
    metrics across the selected competition and season.

    This model consolidates:
    - match results
    - goals scored and conceded
    - points
    - shots
    - passes
    - match participation

    This dataset is optimized for:
    - Power BI ranking tables
    - team performance dashboards
    - season-level reporting
    - executive summaries

Project:
    Football Analytics Lakehouse

Layer:
    Gold

Source:
    football_dev.gold.team_match_stats

Architecture:
    Gold Team Match Stats
        -> Gold Team Season Stats
        -> Power BI / Executive Analytics
===============================================================================
*/

CREATE OR REFRESH MATERIALIZED VIEW team_season_stats

COMMENT "Gold analytical model containing season-level team performance KPIs, including wins, draws, losses, points, goals, shots, passes, and per-match averages."

TBLPROPERTIES (
    'data_domain' = 'football_analytics',
    'data_layer' = 'gold',
    'data_product' = 'team_season_analytics',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'refresh_frequency' = 'on_pipeline_run',
    'business_purpose' = 'Provides season-level team performance metrics for ranking tables, executive dashboards, and tactical analysis.'
)

AS

SELECT
    -- Competition context
    competition_name,
    season_name,

    -- Team attributes
    team_id,
    team_name,

    -- Match participation
    COUNT(DISTINCT match_id) AS matches_played,

    -- Results
    SUM(CASE WHEN match_points = 3 THEN 1 ELSE 0 END) AS wins,
    SUM(CASE WHEN match_points = 1 THEN 1 ELSE 0 END) AS draws,
    SUM(CASE WHEN match_points = 0 THEN 1 ELSE 0 END) AS losses,

    -- Points
    SUM(match_points) AS total_points,

    -- Goal metrics
    SUM(goals_scored) AS goals_scored,
    SUM(goals_conceded) AS goals_conceded,
    SUM(goal_difference) AS goal_difference,

    -- Event-based metrics
    SUM(total_shots) AS total_shots,
    SUM(total_passes) AS total_passes,

    -- Per-match averages
    ROUND(SUM(goals_scored) / COUNT(DISTINCT match_id), 2) AS avg_goals_scored_per_match,
    ROUND(SUM(goals_conceded) / COUNT(DISTINCT match_id), 2) AS avg_goals_conceded_per_match,
    ROUND(SUM(total_shots) / COUNT(DISTINCT match_id), 2) AS avg_shots_per_match,
    ROUND(SUM(total_passes) / COUNT(DISTINCT match_id), 2) AS avg_passes_per_match,

    -- Technical metadata
    CURRENT_TIMESTAMP() AS gold_generated_timestamp

FROM football_dev.gold.team_match_stats

GROUP BY
    competition_name,
    season_name,
    team_id,
    team_name;