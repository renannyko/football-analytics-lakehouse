/*
===============================================================================
Gold Pipeline Execution Metrics
===============================================================================

Note:
    This model provides a lightweight execution health proxy based on row counts
    and freshness. It is not a replacement for Databricks native job run logs.
===============================================================================
*/

CREATE OR REFRESH MATERIALIZED VIEW pipeline_execution_metrics

COMMENT "Observability model containing lightweight pipeline execution health indicators."

AS

SELECT
    tm.layer_name,
    tm.table_name,
    tm.row_count,
    fm.latest_record_timestamp,
    tm.collected_at,

    CASE
        WHEN tm.row_count > 0 THEN 'SUCCESS'
        ELSE 'WARNING_EMPTY_TABLE'
    END AS table_health_status,

    CASE
        WHEN fm.latest_record_timestamp IS NOT NULL THEN 'FRESHNESS_AVAILABLE'
        ELSE 'FRESHNESS_UNAVAILABLE'
    END AS freshness_status

FROM football_dev.gold.pipeline_table_metrics tm

LEFT JOIN football_dev.gold.pipeline_freshness_metrics fm
    ON tm.layer_name = fm.layer_name
   AND tm.table_name = fm.table_name;