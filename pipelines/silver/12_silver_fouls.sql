/*
===============================================================================
Silver Fouls Pipeline
===============================================================================

Description:
    Silver streaming table responsible for extracting and standardizing
    foul-related events from the general Silver events table.

    This table provides a specialized analytical model for:
    - foul analysis
    - disciplinary behavior
    - tactical fouls
    - defensive aggression metrics
    - future Gold KPIs and ML features

Project:
    Football Analytics Lakehouse

Layer:
    Silver

Source:
    football_dev.silver.events

Architecture:
    Silver Events
        -> Silver Fouls
        -> Gold Discipline Analytics / Future ML Features
===============================================================================
*/

CREATE OR REFRESH STREAMING TABLE fouls
(
  CONSTRAINT valid_event_id EXPECT (
    event_id IS NOT NULL
  ),

  CONSTRAINT valid_team_id EXPECT (
    team_id IS NOT NULL
  ),

  CONSTRAINT valid_player_id EXPECT (
    player_id IS NOT NULL
  )
)

COMMENT "Silver streaming table containing standardized StatsBomb foul-related events."

AS

SELECT
    -- Event identifiers
    match_id,
    event_id,
    event_index,

    -- Match timing
    period,
    event_timestamp,
    minute,
    second,

    -- Event classification
    event_type_id,
    event_type_name,

    -- Team and player attributes
    team_id,
    team_name,
    player_id,
    player_name,
    position_id,
    position_name,

    -- Possession context
    possession,
    possession_team_id,
    possession_team_name,
    play_pattern_id,
    play_pattern_name,

    -- Event location
    location_x AS foul_location_x,
    location_y AS foul_location_y,

    -- Raw foul payloads preserved for deeper modeling
    foul_committed AS foul_committed_payload,
    foul_won AS foul_won_payload,

    -- Event context
    duration,
    under_pressure,

    -- Technical metadata
    source_system,
    'fouls' AS source_entity,
    ingestion_timestamp,
    source_file

FROM STREAM football_dev.silver.events

WHERE
    foul_committed IS NOT NULL
    OR foul_won IS NOT NULL;