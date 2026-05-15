/*
===============================================================================
Bronze Table Governance Metadata
===============================================================================
*/

ALTER TABLE football_dev.bronze.raw_competitions
SET TBLPROPERTIES (
    'data_domain' = 'football_analytics',
    'data_layer' = 'bronze',
    'data_product' = 'raw_reference_data',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'refresh_frequency' = 'on_pipeline_run',
    'business_purpose' = 'Stores raw StatsBomb competition and season metadata.'
);

COMMENT ON TABLE football_dev.bronze.raw_competitions IS
'Bronze raw table containing StatsBomb competition and season metadata ingested from JSON files.';


ALTER TABLE football_dev.bronze.raw_matches
SET TBLPROPERTIES (
    'data_domain' = 'football_analytics',
    'data_layer' = 'bronze',
    'data_product' = 'raw_match_data',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'refresh_frequency' = 'on_pipeline_run',
    'business_purpose' = 'Stores raw StatsBomb match metadata for selected competitions and seasons.'
);

COMMENT ON TABLE football_dev.bronze.raw_matches IS
'Bronze raw table containing StatsBomb match-level metadata including teams, scores, competition, season, stadium, and referee context.';


ALTER TABLE football_dev.bronze.raw_lineups
SET TBLPROPERTIES (
    'data_domain' = 'football_analytics',
    'data_layer' = 'bronze',
    'data_product' = 'raw_lineup_data',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'refresh_frequency' = 'on_pipeline_run',
    'business_purpose' = 'Stores raw StatsBomb lineup data by match and team.'
);

COMMENT ON TABLE football_dev.bronze.raw_lineups IS
'Bronze raw table containing StatsBomb lineup payloads with player and team context.';


ALTER TABLE football_dev.bronze.raw_events
SET TBLPROPERTIES (
    'data_domain' = 'football_analytics',
    'data_layer' = 'bronze',
    'data_product' = 'raw_event_data',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'refresh_frequency' = 'on_pipeline_run',
    'business_purpose' = 'Stores raw StatsBomb event-level data used as the foundation for Silver and Gold analytical models.'
);

COMMENT ON TABLE football_dev.bronze.raw_events IS
'Bronze raw table containing StatsBomb event-level records, source metadata, and raw event payloads for downstream processing.';