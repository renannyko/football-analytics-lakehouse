/*
===============================================================================
Gold Match Time Window Dimension Pipeline
===============================================================================

Description:
    Gold materialized view responsible for creating a shared match time-window
    dimension for Power BI slicers and tactical analysis.

Project:
    Football Analytics Lakehouse

Layer:
    Gold

Source:
    football_dev.gold.match_momentum
    football_dev.gold.shot_events

Architecture:
    Gold Tactical Models
        -> Gold Match Time Window Dimension
        -> Power BI Semantic Model
===============================================================================
*/

CREATE OR REFRESH MATERIALIZED VIEW dim_match_time_window

COMMENT "Gold dimension containing match-level five-minute time windows for semantic modeling, tactical filtering, and Power BI slicers."

TBLPROPERTIES (
    'data_domain' = 'football_analytics',
    'data_layer' = 'gold',
    'data_product' = 'semantic_dimensions',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'refresh_frequency' = 'on_pipeline_run',
    'business_purpose' = 'Provides reusable five-minute tactical time windows for Power BI filtering, tactical analysis, and semantic modeling.'
)

AS

SELECT DISTINCT
    CONCAT(
        CAST(match_id AS STRING),
        '_',
        CAST(minute_window_start AS STRING)
    ) AS match_time_window_key,

    match_id,

    minute_window_start,
    minute_window_end,

    minute_window_label,

    minute_window_start AS window_sort_order,

    CURRENT_TIMESTAMP() AS gold_generated_timestamp

FROM football_dev.gold.match_momentum

WHERE
    match_id IS NOT NULL
    AND minute_window_start IS NOT NULL;