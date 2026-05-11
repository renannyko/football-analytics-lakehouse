/*
===============================================================================
Gold Match Momentum Pipeline
===============================================================================

Description:
    Gold materialized view responsible for creating time-window based match
    momentum indicators for tactical and dashboard analysis.

    The correct grain of this model is:
    - one match
    - one team
    - one five-minute window

Project:
    Football Analytics Lakehouse

Layer:
    Gold

Source:
    football_dev.silver.events
    football_dev.silver.matches

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
        -- Match identifiers
        e.match_id,

        -- Time window definition
        FLOOR(e.minute / 5) * 5 AS minute_window_start,
        FLOOR(e.minute / 5) * 5 + 4 AS minute_window_end,

        -- Team context
        e.team_id,
        e.team_name,

        -- Event counters
        COUNT(*) AS total_events,

        SUM(CASE WHEN e.event_type_name = 'Shot' THEN 1 ELSE 0 END) AS total_shots,
        SUM(CASE WHEN e.event_type_name = 'Pass' THEN 1 ELSE 0 END) AS total_passes,
        SUM(CASE WHEN e.event_type_name = 'Carry' THEN 1 ELSE 0 END) AS total_carries,
        SUM(CASE WHEN e.event_type_name = 'Pressure' THEN 1 ELSE 0 END) AS total_pressures,
        SUM(CASE WHEN e.event_type_name = 'Duel' THEN 1 ELSE 0 END) AS total_duels,

        -- Activity indicators
        SUM(
            CASE
                WHEN e.event_type_name IN ('Shot', 'Pass', 'Carry', 'Dribble')
                    THEN 1
                ELSE 0
            END
        ) AS attacking_activity,

        SUM(
            CASE
                WHEN e.event_type_name IN ('Pressure', 'Duel', 'Foul Committed')
                    THEN 1
                ELSE 0
            END
        ) AS defensive_activity

    FROM football_dev.silver.events e

    WHERE e.team_id IS NOT NULL

    GROUP BY
        e.match_id,
        FLOOR(e.minute / 5) * 5,
        FLOOR(e.minute / 5) * 5 + 4,
        e.team_id,
        e.team_name
)

SELECT
    -- Match identifiers
    ew.match_id,

    -- Competition context
    m.competition_name,
    m.season_name,
    m.match_date,

    -- Time window
    ew.minute_window_start,
    ew.minute_window_end,

    CONCAT(
        CAST(ew.minute_window_start AS STRING),
        '-',
        CAST(ew.minute_window_end AS STRING),
        ' min'
    ) AS minute_window_label,

    -- Team context
    ew.team_id,
    ew.team_name,

    -- Event volume
    ew.total_events,
    ew.total_shots,
    ew.total_passes,
    ew.total_carries,
    ew.total_pressures,
    ew.total_duels,

    -- Momentum indicators
    ew.attacking_activity,
    ew.defensive_activity,

    ew.attacking_activity - ew.defensive_activity AS net_activity_balance,

    -- Technical metadata
    CURRENT_TIMESTAMP() AS gold_generated_timestamp

FROM event_windows ew

LEFT JOIN football_dev.silver.matches m
    ON ew.match_id = m.match_id;