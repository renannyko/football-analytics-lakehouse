/*
===============================================================================
Silver Events Pipeline
===============================================================================

Description:
    Silver streaming table responsible for standardizing StatsBomb event-level
    data ingested from the Bronze layer.

    This layer applies:
    - event-level normalization
    - extraction of common event attributes
    - location coordinate parsing
    - basic data quality rules
    - semantic column organization
    - governance-oriented metadata preservation

Project:
    Football Analytics Lakehouse

Layer:
    Silver

Source:
    football_dev.bronze.raw_events

Architecture:
    Bronze Streaming Table
        -> Silver Streaming Table
        -> Gold Analytical Models / Future ML Features
===============================================================================
*/

CREATE OR REFRESH STREAMING TABLE events
(
  CONSTRAINT valid_event_id EXPECT (
    event_id IS NOT NULL
  ),

  CONSTRAINT valid_event_index EXPECT (
    event_index IS NOT NULL
  ),

  CONSTRAINT valid_match_period EXPECT (
    period IS NOT NULL
  ),

  CONSTRAINT valid_event_type EXPECT (
    event_type_id IS NOT NULL
    AND event_type_name IS NOT NULL
  ),

  CONSTRAINT valid_team_id EXPECT (
    team_id IS NOT NULL
  )
)

COMMENT "Silver streaming table containing standardized StatsBomb event-level data."

TBLPROPERTIES (
    'data_domain' = 'football_analytics',
    'data_layer' = 'silver',
    'data_product' = 'standardized_events',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'ingestion_type' = 'streaming',
    'refresh_frequency' = 'on_pipeline_run',
    'business_purpose' = 'Provides standardized football event-level data for downstream tactical analytics, event specialization, semantic modeling, and future machine learning workflows.'
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
    TRIM(event_type_name) AS event_type_name,

    -- Possession context
    possession,
    possession_team_id,
    TRIM(possession_team_name) AS possession_team_name,

    -- Play pattern context
    play_pattern_id,
    TRIM(play_pattern_name) AS play_pattern_name,

    -- Team attributes
    team_id,
    TRIM(team_name) AS team_name,

    -- Player attributes
    player_id,
    TRIM(player_name) AS player_name,

    -- Player position
    position_id,
    TRIM(position_name) AS position_name,

    -- Event location coordinates
    location[0] AS location_x,
    location[1] AS location_y,

    -- Event flags and duration
    duration,
    under_pressure,
    off_camera,
    out,

    -- Raw semi-structured event payloads preserved for future Silver specialization
    pass,
    shot,
    carry,
    duel,
    dribble,
    foul_committed,
    foul_won,
    goalkeeper,
    clearance,
    interception,
    ball_recovery,
    block,
    substitution,
    tactics,
    related_events,

    -- Technical metadata
    source_system,
    source_entity,
    ingestion_timestamp,
    source_file

FROM STREAM football_dev.bronze.raw_events;