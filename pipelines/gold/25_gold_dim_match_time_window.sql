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
===============================================================================
*/

CREATE OR REFRESH MATERIALIZED VIEW dim_match_time_window

COMMENT "Gold dimension containing match-level five-minute time windows for semantic modeling."

AS

SELECT DISTINCT
    CONCAT(CAST(match_id AS STRING), '_', CAST(minute_window_start AS STRING)) AS match_time_window_key,
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