/*
===============================================================================
Gold Match Momentum Pipeline
===============================================================================

Description:
    Gold materialized view responsible for creating time-window based match
    momentum indicators for tactical and dashboard analysis.

    This model consolidates event activity into minute windows and measures:
    - shots
    - passes
    - carries
    - pressures
    - duels
    - attacking and defensive activity indicators

    This dataset is optimized for:
    - Power BI momentum charts
    - match flow analysis
    - tactical storytelling
    - time-window performance comparison

Project:
    Football Analytics Lakehouse

Layer:
    Gold

Source:
    football_dev.silver.events

Architecture:
    Silver Events
        -> Gold Match Momentum
        -> Power BI / Tactical Analytics
===============================================================================
*/

CREATE OR REFRESH MATERIALIZED VIEW match_momentum

COMMENT "Gold analytical model containing time-window based match momentum indicators."

AS

WITH event_windows AS (

    SELECT
        -- Time window definition
        FLOOR(minute / 5) * 5 AS minute_window_start,
        FLOOR(minute / 5) * 5 + 4 AS minute_window_end,

        -- Team context
        team_id,
        team_name,

        -- Event counters
        COUNT(*) AS total_events,

        SUM(CASE WHEN event_type_name = 'Shot' THEN 1 ELSE 0 END) AS total_shots,
        SUM(CASE WHEN event_type_name = 'Pass' THEN 1 ELSE 0 END) AS total_passes,
        SUM(CASE WHEN event_type_name = 'Carry' THEN 1 ELSE 0 END) AS total_carries,
        SUM(CASE WHEN event_type_name = 'Pressure' THEN 1 ELSE 0 END) AS total_pressures,
        SUM(CASE WHEN event_type_name = 'Duel' THEN 1 ELSE 0 END) AS total_duels,

        -- Activity indicators
        SUM(
            CASE
                WHEN event_type_name IN ('Shot', 'Pass', 'Carry', 'Dribble')
                    THEN 1
                ELSE 0
            END
        ) AS attacking_activity,

        SUM(
            CASE
                WHEN event_type_name IN ('Pressure', 'Duel', 'Foul Committed')
                    THEN 1
                ELSE 0
            END
        ) AS defensive_activity

    FROM football_dev.silver.events

    WHERE team_id IS NOT NULL

    GROUP BY
        FLOOR(minute / 5) * 5,
        FLOOR(minute / 5) * 5 + 4,
        team_id,
        team_name
)

SELECT
    -- Time window
    minute_window_start,
    minute_window_end,

    CONCAT(
        CAST(minute_window_start AS STRING),
        '-',
        CAST(minute_window_end AS STRING),
        ' min'
    ) AS minute_window_label,

    -- Team context
    team_id,
    team_name,

    -- Event volume
    total_events,
    total_shots,
    total_passes,
    total_carries,
    total_pressures,
    total_duels,

    -- Momentum indicators
    attacking_activity,
    defensive_activity,

    attacking_activity - defensive_activity AS net_activity_balance,

    -- Technical metadata
    CURRENT_TIMESTAMP() AS gold_generated_timestamp

FROM event_windows;