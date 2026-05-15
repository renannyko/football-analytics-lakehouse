/*
===============================================================================
Gold Governance Tags
===============================================================================

Description:
    Applies Unity Catalog governance tags to Gold materialized views.

Project:
    Football Analytics Lakehouse

Layer:
    Gold
===============================================================================
*/

ALTER MATERIALIZED VIEW football_dev.gold.match_summary
SET TAGS (
    'layer' = 'gold',
    'domain' = 'football_analytics',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'serving_layer',
    'consumption_type' = 'power_bi',
    'analytics_use_case' = 'executive_reporting',
    'ml_ready' = 'false'
);

ALTER MATERIALIZED VIEW football_dev.gold.team_match_stats
SET TAGS (
    'layer' = 'gold',
    'domain' = 'football_analytics',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'serving_layer',
    'consumption_type' = 'power_bi',
    'analytics_use_case' = 'team_match_analysis',
    'ml_ready' = 'true'
);

ALTER MATERIALIZED VIEW football_dev.gold.player_match_stats
SET TAGS (
    'layer' = 'gold',
    'domain' = 'football_analytics',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'serving_layer',
    'consumption_type' = 'power_bi',
    'analytics_use_case' = 'player_match_analysis',
    'ml_ready' = 'true'
);

ALTER MATERIALIZED VIEW football_dev.gold.shot_events
SET TAGS (
    'layer' = 'gold',
    'domain' = 'football_analytics',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'serving_layer',
    'consumption_type' = 'power_bi',
    'analytics_use_case' = 'shot_map',
    'ml_ready' = 'true'
);

ALTER MATERIALIZED VIEW football_dev.gold.pressure_events
SET TAGS (
    'layer' = 'gold',
    'domain' = 'football_analytics',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'serving_layer',
    'consumption_type' = 'power_bi',
    'analytics_use_case' = 'pressure_map',
    'ml_ready' = 'true'
);

ALTER MATERIALIZED VIEW football_dev.gold.match_momentum
SET TAGS (
    'layer' = 'gold',
    'domain' = 'football_analytics',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'serving_layer',
    'consumption_type' = 'power_bi',
    'analytics_use_case' = 'match_momentum',
    'ml_ready' = 'partial'
);

ALTER MATERIALIZED VIEW football_dev.gold.shot_zones
SET TAGS (
    'layer' = 'gold',
    'domain' = 'football_analytics',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'serving_layer',
    'consumption_type' = 'power_bi',
    'analytics_use_case' = 'spatial_shot_analysis',
    'ml_ready' = 'true'
);

ALTER MATERIALIZED VIEW football_dev.gold.pressure_zones
SET TAGS (
    'layer' = 'gold',
    'domain' = 'football_analytics',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'serving_layer',
    'consumption_type' = 'power_bi',
    'analytics_use_case' = 'spatial_pressure_analysis',
    'ml_ready' = 'true'
);

ALTER MATERIALIZED VIEW football_dev.gold.passing_network
SET TAGS (
    'layer' = 'gold',
    'domain' = 'football_analytics',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'serving_layer',
    'consumption_type' = 'power_bi',
    'analytics_use_case' = 'passing_network',
    'ml_ready' = 'true'
);

ALTER MATERIALIZED VIEW football_dev.gold.possession_sequences
SET TAGS (
    'layer' = 'gold',
    'domain' = 'football_analytics',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'serving_layer',
    'consumption_type' = 'power_bi',
    'analytics_use_case' = 'possession_sequences',
    'ml_ready' = 'true'
);

ALTER MATERIALIZED VIEW football_dev.gold.team_season_stats
SET TAGS (
    'layer' = 'gold',
    'domain' = 'football_analytics',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'serving_layer',
    'consumption_type' = 'power_bi',
    'analytics_use_case' = 'team_season_analysis',
    'ml_ready' = 'partial'
);

ALTER MATERIALIZED VIEW football_dev.gold.player_season_stats
SET TAGS (
    'layer' = 'gold',
    'domain' = 'football_analytics',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'serving_layer',
    'consumption_type' = 'power_bi',
    'analytics_use_case' = 'player_season_analysis',
    'ml_ready' = 'partial'
);

ALTER MATERIALIZED VIEW football_dev.gold.team_offensive_metrics
SET TAGS (
    'layer' = 'gold',
    'domain' = 'football_analytics',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'serving_layer',
    'consumption_type' = 'power_bi',
    'analytics_use_case' = 'team_offensive_analysis',
    'ml_ready' = 'true'
);

ALTER MATERIALIZED VIEW football_dev.gold.team_defensive_metrics
SET TAGS (
    'layer' = 'gold',
    'domain' = 'football_analytics',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'serving_layer',
    'consumption_type' = 'power_bi',
    'analytics_use_case' = 'team_defensive_analysis',
    'ml_ready' = 'true'
);

ALTER MATERIALIZED VIEW football_dev.gold.player_offensive_metrics
SET TAGS (
    'layer' = 'gold',
    'domain' = 'football_analytics',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'serving_layer',
    'consumption_type' = 'power_bi',
    'analytics_use_case' = 'player_offensive_analysis',
    'ml_ready' = 'true'
);

ALTER MATERIALIZED VIEW football_dev.gold.player_defensive_metrics
SET TAGS (
    'layer' = 'gold',
    'domain' = 'football_analytics',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'serving_layer',
    'consumption_type' = 'power_bi',
    'analytics_use_case' = 'player_defensive_analysis',
    'ml_ready' = 'true'
);

ALTER MATERIALIZED VIEW football_dev.gold.expected_goals_features
SET TAGS (
    'layer' = 'gold',
    'domain' = 'football_analytics',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'feature_engineering',
    'consumption_type' = 'machine_learning',
    'analytics_use_case' = 'expected_goals_features',
    'ml_ready' = 'true'
);

ALTER MATERIALIZED VIEW football_dev.gold.match_features_ml
SET TAGS (
    'layer' = 'gold',
    'domain' = 'football_analytics',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'feature_engineering',
    'consumption_type' = 'machine_learning',
    'analytics_use_case' = 'match_ml_features',
    'ml_ready' = 'true'
);

ALTER MATERIALIZED VIEW football_dev.gold.player_features_ml
SET TAGS (
    'layer' = 'gold',
    'domain' = 'football_analytics',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'feature_engineering',
    'consumption_type' = 'machine_learning',
    'analytics_use_case' = 'player_ml_features',
    'ml_ready' = 'true'
);

ALTER MATERIALIZED VIEW football_dev.gold.dim_team
SET TAGS (
    'layer' = 'gold',
    'domain' = 'football_analytics',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'semantic_dimension',
    'consumption_type' = 'power_bi',
    'analytics_use_case' = 'semantic_modeling',
    'ml_ready' = 'false'
);

ALTER MATERIALIZED VIEW football_dev.gold.dim_player
SET TAGS (
    'layer' = 'gold',
    'domain' = 'football_analytics',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'semantic_dimension',
    'consumption_type' = 'power_bi',
    'analytics_use_case' = 'semantic_modeling',
    'ml_ready' = 'false'
);

ALTER MATERIALIZED VIEW football_dev.gold.dim_match
SET TAGS (
    'layer' = 'gold',
    'domain' = 'football_analytics',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'semantic_dimension',
    'consumption_type' = 'power_bi',
    'analytics_use_case' = 'semantic_modeling',
    'ml_ready' = 'false'
);

ALTER MATERIALIZED VIEW football_dev.gold.dim_match_time_window
SET TAGS (
    'layer' = 'gold',
    'domain' = 'football_analytics',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'semantic_dimension',
    'consumption_type' = 'power_bi',
    'analytics_use_case' = 'temporal_semantic_modeling',
    'ml_ready' = 'false'
);

ALTER MATERIALIZED VIEW football_dev.gold.pipeline_table_metrics
SET TAGS (
    'layer' = 'gold',
    'domain' = 'platform_observability',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'internal',
    'pipeline_type' = 'observability',
    'consumption_type' = 'monitoring',
    'analytics_use_case' = 'row_count_monitoring',
    'ml_ready' = 'false'
);

ALTER MATERIALIZED VIEW football_dev.gold.pipeline_freshness_metrics
SET TAGS (
    'layer' = 'gold',
    'domain' = 'platform_observability',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'internal',
    'pipeline_type' = 'observability',
    'consumption_type' = 'monitoring',
    'analytics_use_case' = 'freshness_monitoring',
    'ml_ready' = 'false'
);

ALTER MATERIALIZED VIEW football_dev.gold.pipeline_quality_metrics
SET TAGS (
    'layer' = 'gold',
    'domain' = 'platform_observability',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'internal',
    'pipeline_type' = 'observability',
    'consumption_type' = 'monitoring',
    'analytics_use_case' = 'quality_monitoring',
    'ml_ready' = 'false'
);

ALTER MATERIALIZED VIEW football_dev.gold.pipeline_execution_metrics
SET TAGS (
    'layer' = 'gold',
    'domain' = 'platform_observability',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'internal',
    'pipeline_type' = 'observability',
    'consumption_type' = 'monitoring',
    'analytics_use_case' = 'execution_health_monitoring',
    'ml_ready' = 'false'
);