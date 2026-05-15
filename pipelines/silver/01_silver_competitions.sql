/*
===============================================================================
Silver Competitions Pipeline
===============================================================================

Description:
    Silver streaming table responsible for standardizing and validating
    StatsBomb competition and season data ingested from the Bronze layer.

    This layer applies:
    - basic data quality rules
    - standardized string formatting
    - semantic column organization
    - governance-oriented metadata preservation

Project:
    Football Analytics Lakehouse

Layer:
    Silver

Source:
    football_dev.bronze.raw_competitions

Architecture:
    Bronze Streaming Table
        -> Silver Streaming Table
        -> Gold Analytical Models
===============================================================================
*/

CREATE OR REFRESH STREAMING TABLE competitions
(
  CONSTRAINT valid_competition_id EXPECT (
    competition_id IS NOT NULL
  ),

  CONSTRAINT valid_season_id EXPECT (
    season_id IS NOT NULL
  ),

  CONSTRAINT valid_competition_name EXPECT (
    competition_name IS NOT NULL
  ),

  CONSTRAINT valid_season_name EXPECT (
    season_name IS NOT NULL
  )
)

COMMENT "Silver streaming table containing standardized StatsBomb competition and season data."

TBLPROPERTIES (
    'data_domain' = 'football_analytics',
    'data_layer' = 'silver',
    'data_product' = 'standardized_competitions',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'ingestion_type' = 'streaming',
    'refresh_frequency' = 'on_pipeline_run',
    'business_purpose' = 'Provides standardized competition and season metadata for downstream analytical models, governance, and semantic consistency.'
)

AS

SELECT
    -- Competition identifiers
    competition_id,
    season_id,

    -- Competition attributes
    TRIM(country_name) AS country_name,
    TRIM(competition_name) AS competition_name,
    TRIM(competition_gender) AS competition_gender,

    -- Competition flags
    competition_youth,
    competition_international,

    -- Season attributes
    TRIM(season_name) AS season_name,

    -- Source timestamps
    match_updated,
    match_updated_360,
    match_available_360,
    match_available,

    -- Technical metadata
    'statsbomb' AS source_system,
    'competitions' AS source_entity,
    ingestion_timestamp,
    source_file

FROM STREAM football_dev.bronze.raw_competitions;