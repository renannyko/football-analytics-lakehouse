/*
===============================================================================
Silver Goalkeeper Actions Pipeline
===============================================================================

Description:
    Silver streaming table responsible for extracting and standardizing
    goalkeeper-related events from the general Silver events table.

    This table provides a specialized analytical model for:
    - goalkeeper saves
    - goalkeeper claims and collections
    - shot-stopping analysis
    - defensive last-line actions
    - future Gold KPIs and ML features

Project:
    Football Analytics Lakehouse

Layer:
    Silver

Source:
    football_dev.silver.events

Architecture:
    Silver Events
        -> Silver Goalkeeper Actions
        -> Gold Goalkeeper Analytics / Future ML Features
===============================================================================
*/

CREATE OR REFRESH STREAMING TABLE goalkeeper_actions
(
  CONSTRAINT valid_event_id EXPECT (
    event_id IS NOT NULL
  ),

  CONSTRAINT valid_goalkeeper_event EXPECT (
    event_type_name = 'Goal Keeper'
  ),

  CONSTRAINT valid_team_id EXPECT (
    team_id IS NOT NULL
  ),

  CONSTRAINT valid_player_id EXPECT (
    player_id IS NOT NULL
  )
)

COMMENT "Silver streaming table containing standardized StatsBomb goalkeeper-related events."

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

    -- Goalkeeper action location
    location_x AS goalkeeper_location_x,
    location_y AS goalkeeper_location_y,

    -- Event context
    duration,
    under_pressure,

    -- Technical metadata
    source_system,
    'goalkeeper_actions' AS source_entity,
    ingestion_timestamp,
    source_file

FROM STREAM football_dev.silver.events

WHERE
    event_type_name = 'Goal Keeper'