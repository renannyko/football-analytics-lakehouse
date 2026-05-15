/*
===============================================================================
Gold Match Timeline Pipeline
===============================================================================

Description:
    Gold materialized view responsible for creating a chronological timeline
    of relevant match events for dashboard storytelling and tactical analysis.

    This model consolidates:
    - goals and shot events
    - substitutions
    - foul-related events
    - goalkeeper actions
    - pressure and duel events
    - relevant event context by minute and period

    This dataset is optimized for:
    - Power BI timeline visuals
    - match storytelling
    - tactical event exploration
    - chronological reporting

Project:
    Football Analytics Lakehouse

Layer:
    Gold

Source:
    football_dev.silver.events
    football_dev.silver.shots
    football_dev.silver.substitutions
    football_dev.silver.fouls
    football_dev.silver.goalkeeper_actions

Architecture:
    Silver Event Models
        -> Gold Match Timeline
        -> Power BI / Match Storytelling
===============================================================================
*/

CREATE OR REFRESH MATERIALIZED VIEW match_timeline

COMMENT "Gold analytical model containing a chronological timeline of relevant match events for storytelling, tactical analysis, and dashboard exploration."

TBLPROPERTIES (
    'data_domain' = 'football_analytics',
    'data_layer' = 'gold',
    'data_product' = 'match_storytelling',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'refresh_frequency' = 'on_pipeline_run',
    'business_purpose' = 'Provides chronological match event context for tactical storytelling and Power BI timeline visuals.'
)

AS

WITH relevant_events AS (

    SELECT
        -- Match identifiers
        match_id,

        -- Event identifiers
        event_id,
        event_index,

        -- Match timing
        period,
        minute,
        second,
        event_timestamp,

        -- Event classification
        event_type_name,

        -- Team and player context
        team_id,
        team_name,
        player_id,
        player_name,

        -- Spatial context
        location_x,
        location_y,

        -- Event labels
        CASE
            WHEN event_type_name = 'Shot' THEN 'Shot'
            WHEN event_type_name = 'Substitution' THEN 'Substitution'
            WHEN event_type_name IN ('Foul Committed', 'Foul Won') THEN 'Foul'
            WHEN event_type_name = 'Goal Keeper' THEN 'Goalkeeper Action'
            WHEN event_type_name = 'Pressure' THEN 'Pressure'
            WHEN event_type_name = 'Duel' THEN 'Duel'
            ELSE event_type_name
        END AS timeline_event_group,

        -- Event importance for dashboard filtering
        CASE
            WHEN event_type_name = 'Shot' THEN 1
            WHEN event_type_name = 'Substitution' THEN 2
            WHEN event_type_name = 'Goal Keeper' THEN 3
            WHEN event_type_name IN ('Foul Committed', 'Foul Won') THEN 4
            WHEN event_type_name IN ('Pressure', 'Duel') THEN 5
            ELSE 9
        END AS event_priority,

        -- Technical metadata
        source_system,
        ingestion_timestamp

    FROM football_dev.silver.events

    WHERE event_type_name IN (
        'Shot',
        'Substitution',
        'Foul Committed',
        'Foul Won',
        'Goal Keeper',
        'Pressure',
        'Duel'
    )
)

SELECT
    -- Timeline ordering
    ROW_NUMBER() OVER (
        PARTITION BY match_id
        ORDER BY
            period,
            minute,
            second,
            event_index
    ) AS timeline_sequence,

    -- Match identifiers
    match_id,

    -- Event identifiers
    event_id,
    event_index,

    -- Match timing
    period,
    minute,
    second,
    event_timestamp,

    -- Event classification
    event_type_name,
    timeline_event_group,
    event_priority,

    -- Team and player context
    team_id,
    team_name,
    player_id,
    player_name,

    -- Spatial context
    location_x,
    location_y,

    -- Dashboard label
    CONCAT(
        'P',
        CAST(period AS STRING),
        ' ',
        LPAD(CAST(minute AS STRING), 2, '0'),
        ':',
        LPAD(CAST(second AS STRING), 2, '0'),
        ' - ',
        team_name,
        ' - ',
        event_type_name
    ) AS timeline_label,

    -- Technical metadata
    source_system,
    ingestion_timestamp,
    CURRENT_TIMESTAMP() AS gold_generated_timestamp

FROM relevant_events;