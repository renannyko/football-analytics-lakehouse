/*
===============================================================================
Gold Pipeline Freshness Metrics
===============================================================================
*/

CREATE OR REFRESH MATERIALIZED VIEW pipeline_freshness_metrics

COMMENT "Observability model containing freshness indicators by monitored Lakehouse table."

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