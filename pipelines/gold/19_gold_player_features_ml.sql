/*
===============================================================================
Gold Player Features ML Pipeline
===============================================================================

Description:
    Gold materialized view responsible for preparing player-level feature
    engineering datasets for future Machine Learning experimentation.

    This model consolidates:
    - offensive player metrics
    - defensive player metrics
    - season-level player activity
    - composite involvement indicators
    - scouting-oriented analytical features

    This dataset is optimized for:
    - future ML training
    - player clustering
    - scouting experimentation
    - feature engineering workflows

Project:
    Football Analytics Lakehouse

Layer:
    Gold

Source:
    football_dev.gold.player_season_stats
    football_dev.gold.player_offensive_metrics
    football_dev.gold.player_defensive_metrics

Architecture:
    Gold Player Metrics
        -> Gold Player Features ML
        -> Future ML Models
===============================================================================
*/

CREATE OR REFRESH MATERIALIZED VIEW player_features_ml

COMMENT "Gold analytical model containing player-level machine learning feature engineering datasets, including offensive metrics, defensive metrics, involvement indicators, and scouting-oriented analytical features."

TBLPROPERTIES (
    'data_domain' = 'football_analytics',
    'data_layer' = 'gold',
    'data_product' = 'player_ml_features',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'refresh_frequency' = 'on_pipeline_run',
    'business_purpose' = 'Provides engineered player-level features for future machine learning experimentation, player clustering, scouting analytics, and predictive modeling.'
)

AS

SELECT
    -- Team attributes
    pss.team_id,
    pss.team_name,

    -- Player attributes
    pss.player_id,
    pss.player_name,

    -- Participation
    pss.matches_with_events,

    -- Season-level activity
    pss.total_actions,
    pss.avg_actions_per_match,

    -- Offensive metrics
    pss.total_shots,
    pss.total_passes,
    pss.total_carries,
    pss.total_dribbles,
    pom.offensive_involvement_score,

    -- Defensive metrics
    pss.total_pressures,
    pss.total_duels,
    pdm.total_fouls,
    pdm.total_goalkeeper_actions,
    pdm.defensive_involvement_score,

    -- Composite features
    (
        COALESCE(pom.offensive_involvement_score, 0)
        + COALESCE(pdm.defensive_involvement_score, 0)
    ) AS total_involvement_score,

    (
        COALESCE(pom.offensive_involvement_score, 0)
        - COALESCE(pdm.defensive_involvement_score, 0)
    ) AS offensive_defensive_balance,

    ROUND(
        pss.total_actions / NULLIF(pss.matches_with_events, 0),
        2
    ) AS actions_per_match_feature,

    -- Technical metadata
    CURRENT_TIMESTAMP() AS gold_generated_timestamp

FROM football_dev.gold.player_season_stats pss

LEFT JOIN football_dev.gold.player_offensive_metrics pom
    ON pss.player_id = pom.player_id

LEFT JOIN football_dev.gold.player_defensive_metrics pdm
    ON pss.player_id = pdm.player_id;