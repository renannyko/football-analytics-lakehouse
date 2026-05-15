/*
===============================================================================
Gold Pipeline Execution Metrics
===============================================================================

Description:
    Gold materialized view responsible for providing lightweight operational
    execution health indicators across monitored Lakehouse tables.

    This observability model consolidates:
    - table-level row counts
    - freshness indicators
    - execution health proxies
    - pipeline operational status

    Note:
        This model provides a lightweight execution health proxy based on
        row counts and freshness metrics.

        It is NOT a replacement for:
        - Databricks Job Run History
        - Lakeflow execution logs
        - native orchestration monitoring
        - cluster-level operational telemetry

    This dataset is optimized for:
    - Power BI observability dashboards
    - operational monitoring
    - lightweight SLA tracking
    - pipeline health visualization

Project:
    Football Analytics Lakehouse

Layer:
    Gold

Source:
    football_dev.gold.pipeline_table_metrics
    football_dev.gold.pipeline_freshness_metrics

Architecture:
    Gold Observability Models
        -> Gold Pipeline Execution Metrics
        -> Operational Monitoring / Observability
===============================================================================
*/

CREATE OR REFRESH MATERIALIZED VIEW pipeline_execution_metrics

COMMENT "Gold observability model containing lightweight pipeline execution health indicators, row-count monitoring, freshness status, and operational pipeline visibility."

TBLPROPERTIES (
    'data_domain' = 'platform_observability',
    'data_layer' = 'gold',
    'data_product' = 'pipeline_monitoring',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'internal',
    'refresh_frequency' = 'on_pipeline_run',
    'business_purpose' = 'Provides lightweight operational execution health indicators for monitoring Lakehouse table population, freshness availability, and pipeline observability.'
)

AS

SELECT
    -- Pipeline context
    tm.layer_name,
    tm.table_name,

    -- Operational metrics
    tm.row_count,
    fm.latest_record_timestamp,
    tm.collected_at,

    -- Table health indicators
    CASE
        WHEN tm.row_count > 0
            THEN 'SUCCESS'
        ELSE 'WARNING_EMPTY_TABLE'
    END AS table_health_status,

    -- Freshness indicators
    CASE
        WHEN fm.latest_record_timestamp IS NOT NULL
            THEN 'FRESHNESS_AVAILABLE'
        ELSE 'FRESHNESS_UNAVAILABLE'
    END AS freshness_status

FROM football_dev.gold.pipeline_table_metrics tm

LEFT JOIN football_dev.gold.pipeline_freshness_metrics fm
    ON tm.layer_name = fm.layer_name
   AND tm.table_name = fm.table_name;