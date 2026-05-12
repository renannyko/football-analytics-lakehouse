/*
===============================================================================
Gold Shot Events Pipeline
===============================================================================

Description:
    Gold materialized view responsible for providing shot-level event data for
    tactical spatial analysis and time-based Power BI filtering.

    The correct grain of this model is:
    - one match
    - one team
    - one player
    - one shot event

Project:
    Football Analytics Lakehouse

Layer:
    Gold

Source:
    football_dev.silver.shots

Architecture:
    Silver Shots
        -> Gold Shot Events
        -> Power BI / Tactical Shot Map
===============================================================================
*/

CREATE OR REFRESH MATERIALIZED VIEW shot_events

COMMENT "Gold analytical model containing shot-level events for tactical spatial analysis."

AS

SELECT
    -- Match identifiers
    match_id,
    event_id,
    event_index,

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

    -- Minute window for tactical filtering
    FLOOR(minute / 5) * 5 AS minute_window_start,
    FLOOR(minute / 5) * 5 + 4 AS minute_window_end,

    CONCAT(
        CAST(FLOOR(minute / 5) * 5 AS STRING),
        '-',
        CAST(FLOOR(minute / 5) * 5 + 4 AS STRING),
        ' min'
    ) AS minute_window_label,

    -- Possession context
    possession,
    possession_team_id,
    possession_team_name,
    play_pattern_id,
    play_pattern_name,

    -- Shot coordinates
    shot_location_x,
    shot_location_y,

    -- Shot spatial features
    ROUND(
        SQRT(
            POWER(120 - shot_location_x, 2)
            + POWER(40 - shot_location_y, 2)
        ),
        2
    ) AS approximate_distance_to_goal,

    -- Shot attributes extracted from JSON string payload
    regexp_extract(
        shot_payload,
        '"type"\\s*:\\s*\\{[^}]*"name"\\s*:\\s*"([^"]+)"',
        1
    ) AS shot_type,

    regexp_extract(
        shot_payload,
        '"body_part"\\s*:\\s*\\{[^}]*"name"\\s*:\\s*"([^"]+)"',
        1
    ) AS shot_body_part,

    regexp_extract(
        shot_payload,
        '"technique"\\s*:\\s*\\{[^}]*"name"\\s*:\\s*"([^"]+)"',
        1
    ) AS shot_technique,

    regexp_extract(
        shot_payload,
        '"outcome"\\s*:\\s*\\{[^}]*"name"\\s*:\\s*"([^"]+)"',
        1
    ) AS shot_outcome,

    CAST(
        regexp_extract(
            shot_payload,
            '"statsbomb_xg"\\s*:\\s*([0-9.]+)',
            1
        ) AS DOUBLE
    ) AS statsbomb_xg,

    -- Shot outcome flags
    CASE
        WHEN LOWER(
            regexp_extract(
                shot_payload,
                '"outcome"\\s*:\\s*\\{[^}]*"name"\\s*:\\s*"([^"]+)"',
                1
            )
        ) = 'goal'
            THEN 1
        ELSE 0
    END AS is_goal,

    CASE
        WHEN LOWER(
            regexp_extract(
                shot_payload,
                '"first_time"\\s*:\\s*(true|false)',
                1
            )
        ) = 'true'
            THEN 1
        ELSE 0
    END AS is_first_time_shot,

    -- Event context
    duration,
    under_pressure,

    -- Raw payload preserved for future feature extraction
    shot_payload,

    -- Technical metadata
    source_system,
    ingestion_timestamp,
    source_file,
    CURRENT_TIMESTAMP() AS gold_generated_timestamp

FROM football_dev.silver.shots

WHERE
    match_id IS NOT NULL
    AND shot_location_x IS NOT NULL
    AND shot_location_y IS NOT NULL;