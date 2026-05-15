/*
===============================================================================
Gold Match Summary Pipeline
===============================================================================

Description:
    Gold materialized view responsible for providing match-level analytical
    summaries for reporting and dashboard consumption.

    This model consolidates:
    - match metadata
    - home and away teams
    - match scores
    - competition context
    - season information
    - match date attributes

    This dataset is optimized for:
    - Power BI dashboards
    - executive reporting
    - analytical serving
    - downstream KPI consumption

Project:
    Football Analytics Lakehouse

Layer:
    Gold

Source:
    football_dev.silver.matches

Architecture:
    Silver Matches
        -> Gold Match Summary
        -> Power BI / Executive Analytics
===============================================================================
*/

CREATE OR REFRESH MATERIALIZED VIEW match_summary

COMMENT "Gold analytical model containing match-level summaries, match metadata, scorelines, teams, competition context, and executive KPIs."

TBLPROPERTIES (
    'data_domain' = 'football_analytics',
    'data_layer' = 'gold',
    'data_product' = 'match_analytics',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'refresh_frequency' = 'on_pipeline_run',
    'business_purpose' = 'Provides match-level KPIs and executive overview metrics.'
)

AS

SELECT
    -- Match identifiers
    match_id,

    -- Competition context
    competition_id,
    competition_name,

    -- Season context
    season_id,
    season_name,

    -- Match metadata
    match_date,
    kick_off,
    match_week,

    -- Home team attributes
    home_team_id,
    home_team_name,
    home_score,

    -- Away team attributes
    away_team_id,
    away_team_name,
    away_score,

    -- Match outcome
    CASE
        WHEN home_score > away_score THEN home_team_name
        WHEN away_score > home_score THEN away_team_name
        ELSE 'Draw'
    END AS match_result,

    CASE
        WHEN home_score = away_score THEN 'Draw'
        ELSE 'Win/Loss'
    END AS result_type,

    -- Match score formatting
    CONCAT(
        CAST(home_score AS STRING),
        ' - ',
        CAST(away_score AS STRING)
    ) AS scoreline,

    -- Stadium and referee context
    stadium_name,
    referee_name,

    -- Metadata
    source_system,
    ingestion_timestamp

FROM football_dev.silver.matches;