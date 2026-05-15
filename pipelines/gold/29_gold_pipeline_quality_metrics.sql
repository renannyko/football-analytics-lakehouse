/*
===============================================================================
Gold Pipeline Quality Metrics
===============================================================================
*/

CREATE OR REFRESH MATERIALIZED VIEW pipeline_quality_metrics

COMMENT "Observability model containing basic data quality metrics by monitored table."

AS

SELECT
    'silver' AS layer_name,
    'events' AS table_name,
    'match_id_null_check' AS quality_check_name,
    COUNT(*) AS total_rows,
    SUM(CASE WHEN match_id IS NULL THEN 1 ELSE 0 END) AS failed_rows,
    ROUND(SUM(CASE WHEN match_id IS NULL THEN 1 ELSE 0 END) / COUNT(*), 4) AS failed_ratio,
    CURRENT_TIMESTAMP() AS collected_at
FROM football_dev.silver.events

UNION ALL
SELECT
    'silver',
    'events',
    'event_id_null_check',
    COUNT(*),
    SUM(CASE WHEN event_id IS NULL THEN 1 ELSE 0 END),
    ROUND(SUM(CASE WHEN event_id IS NULL THEN 1 ELSE 0 END) / COUNT(*), 4),
    CURRENT_TIMESTAMP()
FROM football_dev.silver.events

UNION ALL
SELECT
    'gold',
    'shot_events',
    'shot_location_null_check',
    COUNT(*),
    SUM(
        CASE
            WHEN shot_location_x IS NULL OR shot_location_y IS NULL THEN 1
            ELSE 0
        END
    ),
    ROUND(
        SUM(
            CASE
                WHEN shot_location_x IS NULL OR shot_location_y IS NULL THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        4
    ),
    CURRENT_TIMESTAMP()
FROM football_dev.gold.shot_events

UNION ALL
SELECT
    'gold',
    'pressure_events',
    'pressure_location_null_check',
    COUNT(*),
    SUM(
        CASE
            WHEN pressure_location_x IS NULL OR pressure_location_y IS NULL THEN 1
            ELSE 0
        END
    ),
    ROUND(
        SUM(
            CASE
                WHEN pressure_location_x IS NULL OR pressure_location_y IS NULL THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        4
    ),
    CURRENT_TIMESTAMP()
FROM football_dev.gold.pressure_events;