/*
===============================================================================
Gold Pipeline Table Metrics
===============================================================================
*/

CREATE OR REFRESH MATERIALIZED VIEW pipeline_table_metrics

COMMENT "Observability model containing row counts by monitored Lakehouse table."

AS

SELECT 'bronze' AS layer_name, 'raw_competitions' AS table_name, COUNT(*) AS row_count, CURRENT_TIMESTAMP() AS collected_at
FROM football_dev.bronze.raw_competitions

UNION ALL
SELECT 'bronze', 'raw_matches', COUNT(*), CURRENT_TIMESTAMP()
FROM football_dev.bronze.raw_matches

UNION ALL
SELECT 'bronze', 'raw_lineups', COUNT(*), CURRENT_TIMESTAMP()
FROM football_dev.bronze.raw_lineups

UNION ALL
SELECT 'bronze', 'raw_events', COUNT(*), CURRENT_TIMESTAMP()
FROM football_dev.bronze.raw_events

UNION ALL
SELECT 'silver', 'events', COUNT(*), CURRENT_TIMESTAMP()
FROM football_dev.silver.events

UNION ALL
SELECT 'silver', 'shots', COUNT(*), CURRENT_TIMESTAMP()
FROM football_dev.silver.shots

UNION ALL
SELECT 'silver', 'pressures', COUNT(*), CURRENT_TIMESTAMP()
FROM football_dev.silver.pressures

UNION ALL
SELECT 'gold', 'match_summary', COUNT(*), CURRENT_TIMESTAMP()
FROM football_dev.gold.match_summary

UNION ALL
SELECT 'gold', 'match_momentum', COUNT(*), CURRENT_TIMESTAMP()
FROM football_dev.gold.match_momentum

UNION ALL
SELECT 'gold', 'shot_events', COUNT(*), CURRENT_TIMESTAMP()
FROM football_dev.gold.shot_events

UNION ALL
SELECT 'gold', 'pressure_events', COUNT(*), CURRENT_TIMESTAMP()
FROM football_dev.gold.pressure_events;