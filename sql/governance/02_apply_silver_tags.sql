/*
===============================================================================
Silver Governance Tags
===============================================================================

Description:
    Applies Unity Catalog governance tags to Silver pipeline-managed tables.

Project:
    Football Analytics Lakehouse

Layer:
    Silver
===============================================================================
*/

ALTER STREAMING TABLE football_dev.silver.competitions
SET TAGS (
    'layer' = 'silver',
    'domain' = 'football_analytics',
    'source' = 'statsbomb',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'streaming_transformation',
    'consumption_type' = 'analytics',
    'ml_ready' = 'partial'
);

ALTER STREAMING TABLE football_dev.silver.matches
SET TAGS (
    'layer' = 'silver',
    'domain' = 'football_analytics',
    'source' = 'statsbomb',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'streaming_transformation',
    'consumption_type' = 'analytics',
    'ml_ready' = 'partial'
);

ALTER STREAMING TABLE football_dev.silver.lineups
SET TAGS (
    'layer' = 'silver',
    'domain' = 'football_analytics',
    'source' = 'statsbomb',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'streaming_transformation',
    'consumption_type' = 'analytics',
    'ml_ready' = 'partial'
);

ALTER STREAMING TABLE football_dev.silver.events
SET TAGS (
    'layer' = 'silver',
    'domain' = 'football_analytics',
    'source' = 'statsbomb',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'streaming_transformation',
    'consumption_type' = 'analytics',
    'ml_ready' = 'partial'
);

ALTER STREAMING TABLE football_dev.silver.shots
SET TAGS (
    'layer' = 'silver',
    'domain' = 'football_analytics',
    'source' = 'statsbomb',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'streaming_transformation',
    'consumption_type' = 'analytics',
    'analytics_use_case' = 'shot_analysis',
    'ml_ready' = 'true'
);

ALTER STREAMING TABLE football_dev.silver.passes
SET TAGS (
    'layer' = 'silver',
    'domain' = 'football_analytics',
    'source' = 'statsbomb',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'streaming_transformation',
    'consumption_type' = 'analytics',
    'analytics_use_case' = 'passing_analysis',
    'ml_ready' = 'true'
);

ALTER STREAMING TABLE football_dev.silver.carries
SET TAGS (
    'layer' = 'silver',
    'domain' = 'football_analytics',
    'source' = 'statsbomb',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'streaming_transformation',
    'consumption_type' = 'analytics',
    'analytics_use_case' = 'ball_progression',
    'ml_ready' = 'true'
);

ALTER STREAMING TABLE football_dev.silver.pressures
SET TAGS (
    'layer' = 'silver',
    'domain' = 'football_analytics',
    'source' = 'statsbomb',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'streaming_transformation',
    'consumption_type' = 'analytics',
    'analytics_use_case' = 'defensive_pressure',
    'ml_ready' = 'true'
);

ALTER STREAMING TABLE football_dev.silver.duels
SET TAGS (
    'layer' = 'silver',
    'domain' = 'football_analytics',
    'source' = 'statsbomb',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'streaming_transformation',
    'consumption_type' = 'analytics',
    'analytics_use_case' = 'defensive_duels',
    'ml_ready' = 'true'
);

ALTER STREAMING TABLE football_dev.silver.dribbles
SET TAGS (
    'layer' = 'silver',
    'domain' = 'football_analytics',
    'source' = 'statsbomb',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'streaming_transformation',
    'consumption_type' = 'analytics',
    'analytics_use_case' = 'dribble_analysis',
    'ml_ready' = 'true'
);

ALTER STREAMING TABLE football_dev.silver.fouls
SET TAGS (
    'layer' = 'silver',
    'domain' = 'football_analytics',
    'source' = 'statsbomb',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'streaming_transformation',
    'consumption_type' = 'analytics',
    'analytics_use_case' = 'discipline_analysis',
    'ml_ready' = 'partial'
);

ALTER STREAMING TABLE football_dev.silver.goalkeeper_actions
SET TAGS (
    'layer' = 'silver',
    'domain' = 'football_analytics',
    'source' = 'statsbomb',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'streaming_transformation',
    'consumption_type' = 'analytics',
    'analytics_use_case' = 'goalkeeper_analysis',
    'ml_ready' = 'true'
);

ALTER STREAMING TABLE football_dev.silver.substitutions
SET TAGS (
    'layer' = 'silver',
    'domain' = 'football_analytics',
    'source' = 'statsbomb',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'streaming_transformation',
    'consumption_type' = 'analytics',
    'analytics_use_case' = 'squad_management',
    'ml_ready' = 'partial'
);

ALTER STREAMING TABLE football_dev.silver.event_related_events
SET TAGS (
    'layer' = 'silver',
    'domain' = 'football_analytics',
    'source' = 'statsbomb',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'streaming_transformation',
    'consumption_type' = 'analytics',
    'analytics_use_case' = 'event_sequences',
    'ml_ready' = 'true'
);