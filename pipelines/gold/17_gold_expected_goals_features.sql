/*
===============================================================================
Gold Expected Goals Features Pipeline
===============================================================================

Description:
    Gold materialized view responsible for preparing shot-level feature
    engineering datasets for future Expected Goals (xG) modeling.

Project:
    Football Analytics Lakehouse

Layer:
    Gold

Source:
    football_dev.silver.shots

Architecture:
    Silver Shots
        -> Gold xG Features
        -> Future ML Models
===============================================================================
*/

CREATE OR REFRESH MATERIALIZED VIEW expected_goals_features

COMMENT "Gold analytical model containing shot-level machine learning features for future Expected Goals (xG) modeling and feature engineering workflows."

TBLPROPERTIES (
    'data_domain' = 'football_analytics',
    'data_layer' = 'gold',
    'data_product' = 'expected_goals_features',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'refresh_frequency' = 'on_pipeline_run',
    'business_purpose' = 'Provides engineered shot-level features for tactical analytics, future xG machine learning models, and advanced feature engineering.'
)

AS

SELECT
    -- Match identifiers
    match_id,

    -- Team attributes
    team_id,
    team_name,

    -- Player attributes
    player_id,
    player_name,

    -- Match timing
    period,
    minute,
    second,

    -- Spatial attributes
    shot_location_x,
    shot_location_y,

    -- Distance approximation to goal center
    ROUND(
        SQRT(
            POWER(120 - shot_location_x, 2)
            + POWER(40 - shot_location_y, 2)
        ),
        2
    ) AS approximate_distance_to_goal,

    -- Contextual attributes
    under_pressure,
    play_pattern_name,

    -- Extracted shot attributes from JSON string payload
    regexp_extract(
        shot_payload,
        '"body_part"\\s*:\\s*\\{[^}]*"name"\\s*:\\s*"([^"]+)"',
        1
    ) AS shot_body_part,

    regexp_extract(
        shot_payload,
        '"technique"\\s*:\\s*\\{[^}]*"name"\\s*:\\s*"([^"]+)"',
        1
    ) AS shot_technique,

    regexp_extract(
        shot_payload,
        '"outcome"\\s*:\\s*\\{[^}]*"name"\\s*:\\s*"([^"]+)"',
        1
    ) AS shot_outcome,

    CASE
        WHEN LOWER(
            regexp_extract(
                shot_payload,
                '"outcome"\\s*:\\s*\\{[^}]*"name"\\s*:\\s*"([^"]+)"',
                1
            )
        ) = 'goal'
            THEN 1
        ELSE 0
    END AS is_goal,

    -- First-time shot indicator extracted from JSON string payload
    CASE
        WHEN LOWER(
            regexp_extract(
                shot_payload,
                '"first_time"\\s*:\\s*(true|false)',
                1
            )
        ) = 'true'
            THEN 1
        ELSE 0
    END AS is_first_time_shot,

    -- Open play indicator
    CASE
        WHEN LOWER(play_pattern_name) = 'regular play'
            THEN 1
        ELSE 0
    END AS is_open_play,

    -- Raw payload preserved for future feature extraction
    shot_payload,

    -- Technical metadata
    source_system,
    ingestion_timestamp,
    CURRENT_TIMESTAMP() AS gold_generated_timestamp

FROM football_dev.silver.shots;