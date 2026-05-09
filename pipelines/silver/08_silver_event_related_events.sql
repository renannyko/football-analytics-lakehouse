/*
===============================================================================
Silver Event Related Events Pipeline
===============================================================================

Description:
    Silver streaming table responsible for normalizing event relationship
    structures from the general Silver events table.

    This table provides a specialized analytical model for:
    - event sequence analysis
    - assist chains
    - possession flows
    - tactical event relationships
    - future Gold KPIs and ML features

Project:
    Football Analytics Lakehouse

Layer:
    Silver

Source:
    football_dev.silver.events

Architecture:
    Silver Events
        -> Silver Event Related Events
        -> Gold Event Sequence Analytics / Future ML Features
===============================================================================
*/

CREATE OR REFRESH STREAMING TABLE event_related_events
(
  CONSTRAINT valid_event_id EXPECT (
    event_id IS NOT NULL
  ),

  CONSTRAINT valid_related_event_id EXPECT (
    related_event_id IS NOT NULL
  )
)

COMMENT "Silver streaming table containing normalized StatsBomb related event relationships."

AS

SELECT
    -- Parent event identifiers
    match_id,
    event_id,
    event_index,

    -- Related event identifier
    related_event_id,

    -- Event classification
    event_type_id,
    event_type_name,

    -- Team and player attributes
    team_id,
    team_name,
    player_id,
    player_name,

    -- Match timing
    period,
    event_timestamp,
    minute,
    second,

    -- Technical metadata
    source_system,
    'event_related_events' AS source_entity,
    ingestion_timestamp,
    source_file

FROM STREAM football_dev.silver.events

LATERAL VIEW EXPLODE(related_events) exploded_related_events AS related_event_id;