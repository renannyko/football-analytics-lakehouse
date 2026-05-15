/*
===============================================================================
Silver Carries Pipeline
===============================================================================

Description:
    Silver streaming table responsible for extracting and standardizing
    carry events from the general Silver events table.

    This table provides a specialized analytical model for:
    - ball progression analysis
    - player movement tracking
    - offensive transitions
    - possession advancement
    - future Gold KPIs and ML features

Project:
    Football Analytics Lakehouse

Layer:
    Silver

Source:
    football_dev.silver.events

Architecture:
    Silver Events
        -> Silver Carries
        -> Gold Ball Progression Analytics / Future ML Features
===============================================================================
*/

CREATE OR REFRESH STREAMING TABLE carries
(
  CONSTRAINT valid_event_id EXPECT (
    event_id IS NOT NULL
  ),

  CONSTRAINT valid_carry_event EXPECT (
    event_type_name = 'Carry'
  ),

  CONSTRAINT valid_team_id EXPECT (
    team_id IS NOT NULL
  ),

  CONSTRAINT valid_player_id EXPECT (
    player_id IS NOT NULL
  )
)

COMMENT "Silver streaming table containing standardized StatsBomb carry events."

TBLPROPERTIES (
    'data_domain' = 'football_analytics',
    'data_layer' = 'silver',
    'data_product' = 'carry_events',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'ingestion_type' = 'streaming',
    'refresh_frequency' = 'on_pipeline_run',
    'business_purpose' = 'Provides standardized carry-level football events for ball progression analysis, offensive transition modeling, tactical analytics, and downstream Gold KPIs.'
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

    -- Carry origin coordinates
    location_x AS carry_start_x,
    location_y AS carry_start_y,

    -- Raw carry payload preserved for deeper modeling
    carry AS carry_payload,

    -- Event context
    duration,
    under_pressure,

    -- Technical metadata
    source_system,
    'carries' AS source_entity,
    ingestion_timestamp,
    source_file

FROM STREAM football_dev.silver.events

WHERE event_type_name = 'Carry';