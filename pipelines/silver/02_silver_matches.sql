/*
===============================================================================
Silver Matches Pipeline
===============================================================================

Description:
    Silver streaming table responsible for standardizing and validating
    StatsBomb match-level data ingested from the Bronze layer.

    This layer applies:
    - basic data quality rules
    - standardized team and match attributes
    - derived match result fields
    - semantic column organization
    - governance-oriented metadata preservation

Project:
    Football Analytics Lakehouse

Layer:
    Silver

Source:
    football_dev.bronze.raw_matches

Architecture:
    Bronze Streaming Table
        -> Silver Streaming Table
        -> Gold Analytical Models
===============================================================================
*/

CREATE OR REFRESH STREAMING TABLE matches
(
  CONSTRAINT valid_match_id EXPECT (
    match_id IS NOT NULL
  ),

  CONSTRAINT valid_competition_id EXPECT (
    competition_id IS NOT NULL
  ),

  CONSTRAINT valid_season_id EXPECT (
    season_id IS NOT NULL
  ),

  CONSTRAINT valid_home_team_id EXPECT (
    home_team_id IS NOT NULL
  ),

  CONSTRAINT valid_away_team_id EXPECT (
    away_team_id IS NOT NULL
  ),

  CONSTRAINT valid_scores EXPECT (
    home_score >= 0
    AND away_score >= 0
  )
)

COMMENT "Silver streaming table containing standardized StatsBomb match-level data."

TBLPROPERTIES (
    'data_domain' = 'football_analytics',
    'data_layer' = 'silver',
    'data_product' = 'standardized_matches',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'ingestion_type' = 'streaming',
    'refresh_frequency' = 'on_pipeline_run',
    'business_purpose' = 'Provides standardized match-level football data for downstream tactical analytics, semantic modeling, and Gold analytical consumption.'
)

AS

SELECT
    -- Match identifiers
    match_id,
    competition_id,
    season_id,

    -- Match timing
    match_date,
    kick_off,
    match_week,

    -- Match status
    match_status,
    match_status_360,
    last_updated,
    last_updated_360,

    -- Competition attributes
    TRIM(competition_name) AS competition_name,
    TRIM(competition_country_name) AS competition_country_name,
    TRIM(season_name) AS season_name,

    -- Home team attributes
    home_team_id,
    TRIM(home_team_name) AS home_team_name,
    TRIM(home_team_gender) AS home_team_gender,

    -- Away team attributes
    away_team_id,
    TRIM(away_team_name) AS away_team_name,
    TRIM(away_team_gender) AS away_team_gender,

    -- Match score
    home_score,
    away_score,

    -- Match result derivations
    CASE
        WHEN home_score > away_score THEN home_team_id
        WHEN away_score > home_score THEN away_team_id
        ELSE NULL
    END AS winner_team_id,

    CASE
        WHEN home_score > away_score THEN TRIM(home_team_name)
        WHEN away_score > home_score THEN TRIM(away_team_name)
        ELSE 'Draw'
    END AS match_result,

    CASE
        WHEN home_score = away_score THEN TRUE
        ELSE FALSE
    END AS is_draw,

    -- Competition stage
    competition_stage_id,
    TRIM(competition_stage_name) AS competition_stage_name,

    -- Venue and referee
    stadium_id,
    TRIM(stadium_name) AS stadium_name,
    referee_id,
    TRIM(referee_name) AS referee_name,

    -- StatsBomb metadata
    data_version,
    shot_fidelity_version,
    xy_fidelity_version,

    -- Technical metadata
    source_system,
    source_entity,
    ingestion_timestamp,
    source_file

FROM STREAM football_dev.bronze.raw_matches;