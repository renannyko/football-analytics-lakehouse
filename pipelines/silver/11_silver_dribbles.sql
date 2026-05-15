/*
===============================================================================
Silver Dribbles Pipeline
===============================================================================

Description:
    Silver streaming table responsible for extracting and standardizing
    dribble events from the general Silver events table.

    This table provides a specialized analytical model for:
    - one-versus-one analysis
    - offensive progression
    - player dribbling efficiency
    - attacking behavior analysis
    - future Gold KPIs and ML features

Project:
    Football Analytics Lakehouse

Layer:
    Silver

Source:
    football_dev.silver.events

Architecture:
    Silver Events
        -> Silver Dribbles
        -> Gold Attacking Analytics / Future ML Features
===============================================================================
*/

CREATE OR REFRESH STREAMING TABLE dribbles
(
  CONSTRAINT valid_event_id EXPECT (
    event_id IS NOT NULL
  ),

  CONSTRAINT valid_dribble_event EXPECT (
    event_type_name = 'Dribble'
  ),

  CONSTRAINT valid_team_id EXPECT (
    team_id IS NOT NULL
  ),

  CONSTRAINT valid_player_id EXPECT (
    player_id IS NOT NULL
  )
)

COMMENT "Silver streaming table containing standardized StatsBomb dribble events."

TBLPROPERTIES (
    'data_domain' = 'football_analytics',
    'data_layer' = 'silver',
    'data_product' = 'dribble_events',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'ingestion_type' = 'streaming',
    'refresh_frequency' = 'on_pipeline_run',
    'business_purpose' = 'Provides standardized dribble-level football events for offensive progression analysis, player dribbling analytics, tactical modeling, and downstream Gold KPIs.'
)

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

    -- Dribble location
    location_x AS dribble_location_x,
    location_y AS dribble_location_y,

    -- Raw dribble payload preserved for deeper modeling
    dribble AS dribble_payload,

    -- Event context
    duration,
    under_pressure,

    -- Technical metadata
    source_system,
    'dribbles' AS source_entity,
    ingestion_timestamp,
    source_file

FROM STREAM football_dev.silver.events

WHERE event_type_name = 'Dribble';