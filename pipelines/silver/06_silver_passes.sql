/*
===============================================================================
Silver Passes Pipeline
===============================================================================

Description:
    Silver streaming table responsible for extracting and standardizing
    pass events from the general Silver events table.

    This table provides a specialized analytical model for:
    - passing analysis
    - assists and key passes
    - ball progression
    - passing networks
    - tactical analysis
    - future Gold KPIs and ML features

Project:
    Football Analytics Lakehouse

Layer:
    Silver

Source:
    football_dev.silver.events

Architecture:
    Silver Events
        -> Silver Passes
        -> Gold Passing Analytics / Future ML Features
===============================================================================
*/

CREATE OR REFRESH STREAMING TABLE passes
(
  CONSTRAINT valid_event_id EXPECT (
    event_id IS NOT NULL
  ),

  CONSTRAINT valid_pass_event EXPECT (
    event_type_name = 'Pass'
  ),

  CONSTRAINT valid_team_id EXPECT (
    team_id IS NOT NULL
  ),

  CONSTRAINT valid_player_id EXPECT (
    player_id IS NOT NULL
  )
)

COMMENT "Silver streaming table containing standardized StatsBomb pass events."

TBLPROPERTIES (
    'data_domain' = 'football_analytics',
    'data_layer' = 'silver',
    'data_product' = 'pass_events',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'ingestion_type' = 'streaming',
    'refresh_frequency' = 'on_pipeline_run',
    'business_purpose' = 'Provides standardized pass-level football events for passing analytics, possession analysis, tactical modeling, and downstream Gold KPIs.'
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

    -- Pass origin coordinates
    location_x AS pass_start_x,
    location_y AS pass_start_y,

    -- Raw pass payload preserved for deeper modeling
    pass AS pass_payload,

    -- Event context
    duration,
    under_pressure,

    -- Technical metadata
    source_system,
    'passes' AS source_entity,
    ingestion_timestamp,
    source_file

FROM STREAM football_dev.silver.events

WHERE event_type_name = 'Pass';