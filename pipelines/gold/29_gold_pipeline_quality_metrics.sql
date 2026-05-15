/*
===============================================================================
Gold Pipeline Quality Metrics
===============================================================================

Description:
    Gold materialized view responsible for monitoring basic data quality
    indicators across Silver and Gold Lakehouse tables.

    This observability model provides:
    - null validation metrics
    - failed row indicators
    - quality check monitoring
    - data quality ratios

    This dataset is optimized for:
    - Power BI observability dashboards
    - operational governance
    - data quality monitoring
    - pipeline validation workflows

Project:
    Football Analytics Lakehouse

Layer:
    Gold

Architecture:
    Silver / Gold Tables
        -> Gold Pipeline Quality Metrics
        -> Operational Monitoring / Observability
===============================================================================
*/

CREATE OR REFRESH MATERIALIZED VIEW pipeline_quality_metrics

COMMENT "Gold observability model containing basic data quality metrics, null validation indicators, failed row counts, and quality monitoring KPIs across monitored Lakehouse tables."

TBLPROPERTIES (
    'data_domain' = 'platform_observability',
    'data_layer' = 'gold',
    'data_product' = 'pipeline_monitoring',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'internal',
    'refresh_frequency' = 'on_pipeline_run',
    'business_purpose' = 'Provides operational data quality monitoring metrics for validating null checks, failed record ratios, and overall Lakehouse pipeline quality.'
)

AS

SELECT
    'silver' AS layer_name,
    'events' AS table_name,
    'match_id_null_check' AS quality_check_name,

    COUNT(*) AS total_rows,

    SUM(
        CASE
            WHEN match_id IS NULL THEN 1
            ELSE 0
        END
    ) AS failed_rows,

    ROUND(
        SUM(
            CASE
                WHEN match_id IS NULL THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        4
    ) AS failed_ratio,

    CURRENT_TIMESTAMP() AS collected_at

FROM football_dev.silver.events

UNION ALL

SELECT
    'silver',
    'events',
    'event_id_null_check',

    COUNT(*),

    SUM(
        CASE
            WHEN event_id IS NULL THEN 1
            ELSE 0
        END
    ),

    ROUND(
        SUM(
            CASE
                WHEN event_id IS NULL THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        4
    ),

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
            WHEN shot_location_x IS NULL
              OR shot_location_y IS NULL
                THEN 1
            ELSE 0
        END
    ),

    ROUND(
        SUM(
            CASE
                WHEN shot_location_x IS NULL
                  OR shot_location_y IS NULL
                    THEN 1
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
            WHEN pressure_location_x IS NULL
              OR pressure_location_y IS NULL
                THEN 1
            ELSE 0
        END
    ),

    ROUND(
        SUM(
            CASE
                WHEN pressure_location_x IS NULL
                  OR pressure_location_y IS NULL
                    THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        4
    ),

    CURRENT_TIMESTAMP()

FROM football_dev.gold.pressure_events;