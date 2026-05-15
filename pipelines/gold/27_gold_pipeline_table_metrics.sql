/*
===============================================================================
Gold Pipeline Table Metrics
===============================================================================

Description:
    Gold materialized view responsible for monitoring row-count metrics across
    Bronze, Silver, and Gold Lakehouse layers.

    This observability model provides:
    - table-level row counts
    - ingestion visibility
    - pipeline monitoring metrics
    - operational observability indicators

    This dataset is optimized for:
    - Power BI observability dashboards
    - pipeline health monitoring
    - operational governance
    - ingestion validation

Project:
    Football Analytics Lakehouse

Layer:
    Gold

Architecture:
    Bronze / Silver / Gold Tables
        -> Gold Pipeline Table Metrics
        -> Operational Monitoring / Observability
===============================================================================
*/

CREATE OR REFRESH MATERIALIZED VIEW pipeline_table_metrics

COMMENT "Gold observability model containing row-count metrics across monitored Bronze, Silver, and Gold Lakehouse tables."

TBLPROPERTIES (
    'data_domain' = 'platform_observability',
    'data_layer' = 'gold',
    'data_product' = 'pipeline_monitoring',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'internal',
    'refresh_frequency' = 'on_pipeline_run',
    'business_purpose' = 'Provides operational observability metrics for monitoring pipeline ingestion volume, table growth, and Lakehouse processing health.'
)

AS

SELECT
    'bronze' AS layer_name,
    'raw_competitions' AS table_name,
    COUNT(*) AS row_count,
    CURRENT_TIMESTAMP() AS collected_at

FROM football_dev.bronze.raw_competitions

UNION ALL

SELECT
    'bronze',
    'raw_matches',
    COUNT(*),
    CURRENT_TIMESTAMP()

FROM football_dev.bronze.raw_matches

UNION ALL

SELECT
    'bronze',
    'raw_lineups',
    COUNT(*),
    CURRENT_TIMESTAMP()

FROM football_dev.bronze.raw_lineups

UNION ALL

SELECT
    'bronze',
    'raw_events',
    COUNT(*),
    CURRENT_TIMESTAMP()

FROM football_dev.bronze.raw_events

UNION ALL

SELECT
    'silver',
    'events',
    COUNT(*),
    CURRENT_TIMESTAMP()

FROM football_dev.silver.events

UNION ALL

SELECT
    'silver',
    'shots',
    COUNT(*),
    CURRENT_TIMESTAMP()

FROM football_dev.silver.shots

UNION ALL

SELECT
    'silver',
    'pressures',
    COUNT(*),
    CURRENT_TIMESTAMP()

FROM football_dev.silver.pressures

UNION ALL

SELECT
    'gold',
    'match_summary',
    COUNT(*),
    CURRENT_TIMESTAMP()

FROM football_dev.gold.match_summary

UNION ALL

SELECT
    'gold',
    'match_momentum',
    COUNT(*),
    CURRENT_TIMESTAMP()

FROM football_dev.gold.match_momentum

UNION ALL

SELECT
    'gold',
    'shot_events',
    COUNT(*),
    CURRENT_TIMESTAMP()

FROM football_dev.gold.shot_events

UNION ALL

SELECT
    'gold',
    'pressure_events',
    COUNT(*),
    CURRENT_TIMESTAMP()

FROM football_dev.gold.pressure_events;