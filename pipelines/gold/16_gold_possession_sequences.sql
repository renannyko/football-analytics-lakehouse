/*
===============================================================================
Gold Possession Sequences Pipeline
===============================================================================

Description:
    Gold materialized view responsible for modeling possession event
    sequences for tactical and flow analysis.

    This model consolidates:
    - possession chains
    - related event sequences
    - event transitions
    - team possession behavior
    - player sequence participation

    This dataset is optimized for:
    - Power BI tactical dashboards
    - possession flow analysis
    - sequence visualization
    - future ML feature engineering

Project:
    Football Analytics Lakehouse

Layer:
    Gold

Source:
    football_dev.silver.event_related_events
    football_dev.silver.events

Architecture:
    Silver Event Relationships
        -> Gold Possession Sequences
        -> Power BI / Tactical Sequence Analytics
===============================================================================
*/

CREATE OR REFRESH MATERIALIZED VIEW possession_sequences

COMMENT "Gold analytical model containing possession and event sequence relationships, including event transitions, sequence ordering, possession chains, and tactical flow context."

TBLPROPERTIES (
    'data_domain' = 'football_analytics',
    'data_layer' = 'gold',
    'data_product' = 'possession_sequence_analytics',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'refresh_frequency' = 'on_pipeline_run',
    'business_purpose' = 'Provides possession chain and event sequence analytics for tactical flow analysis, sequence visualization, and future feature engineering.'
)

AS

WITH base_sequences AS (

    SELECT
        -- Match identifiers
        e.match_id,

        -- Parent event
        ere.event_id AS parent_event_id,
        ere.related_event_id,

        -- Event classification
        ere.event_type_id,
        ere.event_type_name,

        -- Match timing
        ere.period,
        ere.minute,
        ere.second,
        ere.event_timestamp,

        -- Team context
        ere.team_id,
        ere.team_name,

        -- Player context
        ere.player_id,
        ere.player_name,

        -- Possession context
        e.possession,
        e.possession_team_id,
        e.possession_team_name,

        -- Sequence ordering
        ROW_NUMBER() OVER (
            PARTITION BY e.match_id, e.possession
            ORDER BY
                ere.period,
                ere.minute,
                ere.second,
                ere.event_timestamp
        ) AS possession_sequence_order

    FROM football_dev.silver.event_related_events ere

    INNER JOIN football_dev.silver.events e
        ON ere.event_id = e.event_id
)

SELECT
    -- Match identifiers
    match_id,

    -- Possession identifiers
    possession,
    possession_team_id,
    possession_team_name,

    -- Sequence ordering
    possession_sequence_order,

    -- Event identifiers
    parent_event_id,
    related_event_id,

    -- Event classification
    event_type_id,
    event_type_name,

    -- Match timing
    period,
    minute,
    second,
    event_timestamp,

    -- Team and player context
    team_id,
    team_name,
    player_id,
    player_name,

    -- Sequence labeling
    CONCAT(
        'Possession ',
        CAST(possession AS STRING),
        ' - Step ',
        CAST(possession_sequence_order AS STRING)
    ) AS possession_sequence_label,

    -- Technical metadata
    CURRENT_TIMESTAMP() AS gold_generated_timestamp

FROM base_sequences;