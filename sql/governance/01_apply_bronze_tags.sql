/*
===============================================================================
Bronze Governance Tags
===============================================================================

Description:
    Applies Unity Catalog governance tags to Bronze pipeline-managed tables.

Project:
    Football Analytics Lakehouse

Layer:
    Bronze
===============================================================================
*/

ALTER STREAMING TABLE football_dev.bronze.raw_competitions
SET TAGS (
    'layer' = 'bronze',
    'domain' = 'football_analytics',
    'source' = 'statsbomb',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'streaming_ingestion',
    'consumption_type' = 'engineering',
    'ml_ready' = 'false'
);

ALTER STREAMING TABLE football_dev.bronze.raw_matches
SET TAGS (
    'layer' = 'bronze',
    'domain' = 'football_analytics',
    'source' = 'statsbomb',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'streaming_ingestion',
    'consumption_type' = 'engineering',
    'ml_ready' = 'false'
);

ALTER STREAMING TABLE football_dev.bronze.raw_lineups
SET TAGS (
    'layer' = 'bronze',
    'domain' = 'football_analytics',
    'source' = 'statsbomb',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'streaming_ingestion',
    'consumption_type' = 'engineering',
    'ml_ready' = 'false'
);

ALTER STREAMING TABLE football_dev.bronze.raw_events
SET TAGS (
    'layer' = 'bronze',
    'domain' = 'football_analytics',
    'source' = 'statsbomb',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'pipeline_type' = 'streaming_ingestion',
    'consumption_type' = 'engineering',
    'ml_ready' = 'false'
);