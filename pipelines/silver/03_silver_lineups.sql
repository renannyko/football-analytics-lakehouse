/*
===============================================================================
Silver Lineups Pipeline
===============================================================================

Description:
    Silver streaming table responsible for standardizing and flattening
    StatsBomb lineup data ingested from the Bronze layer.

    This layer applies:
    - lineup array explosion
    - player-level normalization
    - basic data quality rules
    - semantic column organization
    - governance-oriented metadata preservation

Project:
    Football Analytics Lakehouse

Layer:
    Silver

Source:
    football_dev.bronze.raw_lineups

Architecture:
    Bronze Streaming Table
        -> Silver Streaming Table
        -> Gold Analytical Models
===============================================================================
*/

CREATE OR REFRESH STREAMING TABLE lineups
(
  CONSTRAINT valid_team_id EXPECT (
    team_id IS NOT NULL
  ),

  CONSTRAINT valid_player_id EXPECT (
    player_id IS NOT NULL
  ),

  CONSTRAINT valid_player_name EXPECT (
    player_name IS NOT NULL
  )
)

COMMENT "Silver streaming table containing standardized player lineup data."

AS

SELECT
    -- Team attributes
    raw_lineups.team_id,
    TRIM(raw_lineups.team_name) AS team_name,

    -- Player attributes
    player.player_id AS player_id,
    TRIM(player.player_name) AS player_name,
    TRIM(player.player_nickname) AS player_nickname,
    player.jersey_number AS jersey_number,

    -- Country attributes
    player.country.id AS country_id,
    TRIM(player.country.name) AS country_name,

    -- Technical metadata
    raw_lineups.source_system,
    raw_lineups.source_entity,
    raw_lineups.ingestion_timestamp,
    raw_lineups.source_file

FROM STREAM football_dev.bronze.raw_lineups AS raw_lineups
LATERAL VIEW EXPLODE(raw_lineups.lineup) exploded_lineup AS player;