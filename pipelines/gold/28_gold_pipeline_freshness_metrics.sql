/*
===============================================================================
Gold Pipeline Freshness Metrics
===============================================================================

Description:
    Gold materialized view responsible for monitoring freshness indicators
    across Bronze, Silver, and Gold Lakehouse tables.

    This observability model provides:
    - latest ingestion timestamps
    - latest Gold generation timestamps
    - freshness monitoring indicators
    - operational pipeline visibility

    This dataset is optimized for:
    - Power BI observability dashboards
    - freshness SLA monitoring
    - operational governance
    - pipeline monitoring

Project:
    Football Analytics Lakehouse

Layer:
    Gold

Architecture:
    Bronze / Silver / Gold Tables
        -> Gold Pipeline Freshness Metrics
        -> Operational Monitoring / Observability
===============================================================================
*/

CREATE OR REFRESH MATERIALIZED VIEW pipeline_freshness_metrics

COMMENT "Gold observability model containing freshness indicators across monitored Bronze, Silver, and Gold Lakehouse tables."

TBLPROPERTIES (
    'data_domain' = 'platform_observability',
    'data_layer' = 'gold',
    'data_product' = 'pipeline_monitoring',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'internal',
    'refresh_frequency' = 'on_pipeline_run',
    'business_purpose' = 'Provides operational freshness monitoring metrics for validating ingestion recency, Gold refresh activity, and Lakehouse pipeline health.'
)

AS

SELECT
    'bronze' AS layer_name,
    'raw_events' AS table_name,
    MAX(ingestion_timestamp) AS latest_record_timestamp,
    CURRENT_TIMESTAMP() AS collected_at

FROM football_dev.bronze.raw_events

UNION ALL

SELECT
    'silver',
    'events',
    MAX(ingestion_timestamp),
    CURRENT_TIMESTAMP()

FROM football_dev.silver.events

UNION ALL

SELECT
    'silver',
    'shots',
    MAX(ingestion_timestamp),
    CURRENT_TIMESTAMP()

FROM football_dev.silver.shots

UNION ALL

SELECT
    'silver',
    'pressures',
    MAX(ingestion_timestamp),
    CURRENT_TIMESTAMP()

FROM football_dev.silver.pressures

UNION ALL

SELECT
    'gold',
    'match_summary',
    MAX(ingestion_timestamp),
    CURRENT_TIMESTAMP()

FROM football_dev.gold.match_summary

UNION ALL

SELECT
    'gold',
    'match_momentum',
    MAX(gold_generated_timestamp),
    CURRENT_TIMESTAMP()

FROM football_dev.gold.match_momentum

UNION ALL

SELECT
    'gold',
    'shot_events',
    MAX(gold_generated_timestamp),
    CURRENT_TIMESTAMP()

FROM football_dev.gold.shot_events

UNION ALL

SELECT
    'gold',
    'pressure_events',
    MAX(gold_generated_timestamp),
    CURRENT_TIMESTAMP()

FROM football_dev.gold.pressure_events;