/*
===============================================================================
Gold Pressure Events Pipeline
===============================================================================

Description:
    Gold materialized view responsible for providing pressure-level event data
    for tactical defensive analysis and spatial pressure visualization.

    The correct grain of this model is:
    - one match
    - one team
    - one player
    - one pressure event

Project:
    Football Analytics Lakehouse

Layer:
    Gold

Source:
    football_dev.silver.pressures

Architecture:
    Silver Pressures
        -> Gold Pressure Events
        -> Power BI / Tactical Pressure Map
===============================================================================
*/

CREATE OR REFRESH MATERIALIZED VIEW pressure_events

COMMENT "Gold analytical model containing pressure-level events for tactical defensive analysis."

AS

SELECT
    -- Match identifiers
    match_id,
    event_id,
    event_index,

    -- Shared temporal semantic key
    CONCAT(
        CAST(match_id AS STRING),
        '_',
        CAST(FLOOR(minute / 5) * 5 AS STRING)
    ) AS match_time_window_key,

    -- Team attributes
    team_id,
    team_name,

    -- Player attributes
    player_id,
    player_name,
    position_id,
    position_name,

    -- Match timing
    period,
    event_timestamp,
    minute,
    second,

    -- Minute window
    FLOOR(minute / 5) * 5 AS minute_window_start,
    FLOOR(minute / 5) * 5 + 4 AS minute_window_end,

    CONCAT(
        CAST(FLOOR(minute / 5) * 5 AS STRING),
        '-',
        CAST(FLOOR(minute / 5) * 5 + 4 AS STRING),
        ' min'
    ) AS minute_window_label,

    -- Pressure coordinates
    pressure_location_x,
    pressure_location_y,

    -- Pressure contextual attributes
    under_pressure,
    possession,
    possession_team_id,
    possession_team_name,
    play_pattern_id,
    play_pattern_name,

    -- Event context
    duration,

    -- Technical metadata
    source_system,
    ingestion_timestamp,
    source_file,
    CURRENT_TIMESTAMP() AS gold_generated_timestamp

FROM football_dev.silver.pressures

WHERE
    match_id IS NOT NULL
    AND pressure_location_x IS NOT NULL
    AND pressure_location_y IS NOT NULL;