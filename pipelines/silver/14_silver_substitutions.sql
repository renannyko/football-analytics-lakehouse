/*
===============================================================================
Silver Substitutions Pipeline
===============================================================================

Description:
    Silver streaming table responsible for extracting and standardizing
    substitution events from the general Silver events table.

    This table provides a specialized analytical model for:
    - player substitution analysis
    - tactical game management
    - minute-based player changes
    - squad rotation analytics
    - future Gold KPIs and ML features

Project:
    Football Analytics Lakehouse

Layer:
    Silver

Source:
    football_dev.silver.events

Architecture:
    Silver Events
        -> Silver Substitutions
        -> Gold Squad Management Analytics / Future ML Features
===============================================================================
*/

CREATE OR REFRESH STREAMING TABLE substitutions
(
  CONSTRAINT valid_event_id EXPECT (
    event_id IS NOT NULL
  ),

  CONSTRAINT valid_substitution_event EXPECT (
    event_type_name = 'Substitution'
  ),

  CONSTRAINT valid_team_id EXPECT (
    team_id IS NOT NULL
  ),

  CONSTRAINT valid_player_id EXPECT (
    player_id IS NOT NULL
  )
)

COMMENT "Silver streaming table containing standardized StatsBomb substitution events."

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

    -- Substitution location
    location_x AS substitution_location_x,
    location_y AS substitution_location_y,

    -- Raw substitution payload preserved for deeper modeling
    substitution AS substitution_payload,

    -- Event context
    duration,
    under_pressure,

    -- Technical metadata
    source_system,
    'substitutions' AS source_entity,
    ingestion_timestamp,
    source_file

FROM STREAM football_dev.silver.events

WHERE event_type_name = 'Substitution';