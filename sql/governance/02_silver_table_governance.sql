/*
===============================================================================
Silver Table Governance Metadata
===============================================================================
*/

ALTER TABLE football_dev.silver.events
SET TBLPROPERTIES (
    'data_domain' = 'football_analytics',
    'data_layer' = 'silver',
    'data_product' = 'standardized_events',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'refresh_frequency' = 'on_pipeline_run',
    'business_purpose' = 'Provides standardized football event-level data for downstream analytical models.'
);

COMMENT ON TABLE football_dev.silver.events IS
'Silver standardized table containing cleaned and normalized StatsBomb event-level data.';


ALTER TABLE football_dev.silver.shots
SET TBLPROPERTIES (
    'data_domain' = 'football_analytics',
    'data_layer' = 'silver',
    'data_product' = 'shot_events',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'refresh_frequency' = 'on_pipeline_run',
    'business_purpose' = 'Provides standardized shot events for tactical and spatial analytics.'
);

COMMENT ON TABLE football_dev.silver.shots IS
'Silver analytical table containing standardized shot-level events extracted from the general events table.';


ALTER TABLE football_dev.silver.pressures
SET TBLPROPERTIES (
    'data_domain' = 'football_analytics',
    'data_layer' = 'silver',
    'data_product' = 'pressure_events',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'refresh_frequency' = 'on_pipeline_run',
    'business_purpose' = 'Provides standardized pressure events for defensive tactical analytics.'
);

COMMENT ON TABLE football_dev.silver.pressures IS
'Silver analytical table containing standardized pressure-level events extracted from the general events table.';


ALTER TABLE football_dev.silver.passes
SET TBLPROPERTIES (
    'data_domain' = 'football_analytics',
    'data_layer' = 'silver',
    'data_product' = 'pass_events',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'refresh_frequency' = 'on_pipeline_run',
    'business_purpose' = 'Provides standardized pass events for possession and passing network analysis.'
);

COMMENT ON TABLE football_dev.silver.passes IS
'Silver analytical table containing standardized pass-level events extracted from the general events table.';