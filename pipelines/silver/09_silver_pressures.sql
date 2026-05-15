/*
===============================================================================
Silver Pressures Pipeline
===============================================================================

Description:
    Silver streaming table responsible for extracting and standardizing
    pressure events from the general Silver events table.

Project:
    Football Analytics Lakehouse

Layer:
    Silver

Source:
    football_dev.silver.events

Architecture:
    Silver Events
        -> Silver Pressures
        -> Gold Pressure Analytics / Future ML Features
===============================================================================
*/

CREATE OR REFRESH STREAMING TABLE pressures
(
  CONSTRAINT valid_event_id EXPECT (
    event_id IS NOT NULL
  ),

  CONSTRAINT valid_pressure_event EXPECT (
    event_type_name = 'Pressure'
  ),

  CONSTRAINT valid_team_id EXPECT (
    team_id IS NOT NULL
  ),

  CONSTRAINT valid_player_id EXPECT (
    player_id IS NOT NULL
  )
)

COMMENT "Silver streaming table containing standardized StatsBomb pressure events."

TBLPROPERTIES (
    'data_domain' = 'football_analytics',
    'data_layer' = 'silver',
    'data_product' = 'pressure_events',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'ingestion_type' = 'streaming',
    'refresh_frequency' = 'on_pipeline_run',
    'business_purpose' = 'Provides standardized pressure-level football events for defensive tactical analysis, spatial pressure modeling, and downstream Gold KPIs.'
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

    -- Pressure location
    location_x AS pressure_location_x,
    location_y AS pressure_location_y,

    -- Pressure contextual attributes
    under_pressure,

    -- Event context
    duration,

    -- Technical metadata
    source_system,
    'pressures' AS source_entity,
    ingestion_timestamp,
    source_file

FROM STREAM football_dev.silver.events

WHERE event_type_name = 'Pressure';