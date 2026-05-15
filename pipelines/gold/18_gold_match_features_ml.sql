/*
===============================================================================
Gold Match Features ML Pipeline
===============================================================================

Description:
    Gold materialized view responsible for preparing match-level feature
    engineering datasets for future Machine Learning experimentation.

    This model consolidates:
    - shots
    - passes
    - carries
    - pressures
    - duels
    - fouls
    - goals scored
    - offensive and defensive intensity indicators

    This dataset is optimized for:
    - future ML training
    - match prediction experimentation
    - tactical modeling
    - feature engineering workflows

Project:
    Football Analytics Lakehouse

Layer:
    Gold

Source:
    football_dev.gold.team_match_stats
    football_dev.gold.team_offensive_metrics
    football_dev.gold.team_defensive_metrics

Architecture:
    Gold Match Metrics
        -> Gold Match Features ML
        -> Future ML Models
===============================================================================
*/

CREATE OR REFRESH MATERIALIZED VIEW match_features_ml

COMMENT "Gold analytical model containing match-level machine learning feature engineering datasets, including offensive metrics, defensive metrics, intensity indicators, and efficiency features."

TBLPROPERTIES (
    'data_domain' = 'football_analytics',
    'data_layer' = 'gold',
    'data_product' = 'match_ml_features',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'refresh_frequency' = 'on_pipeline_run',
    'business_purpose' = 'Provides engineered match-level features for future machine learning experimentation, tactical modeling, and predictive analytics.'
)

AS

SELECT
    -- Competition context
    tms.competition_name,
    tms.season_name,
    tms.match_date,

    -- Match identifiers
    tms.match_id,

    -- Team attributes
    tms.team_id,
    tms.team_name,
    tms.match_side,

    -- Match KPIs
    tms.goals_scored,
    tms.goals_conceded,
    tms.goal_difference,
    tms.match_points,

    -- Offensive metrics
    tom.total_shots,
    tom.total_passes,
    tom.total_carries,
    tom.total_dribbles,
    tom.offensive_intensity_score,

    -- Defensive metrics
    tdm.total_pressures,
    tdm.total_duels,
    tdm.total_fouls,
    tdm.total_goalkeeper_actions,
    tdm.defensive_intensity_score,

    -- Composite indicators
    (
        tom.offensive_intensity_score
        - tdm.defensive_intensity_score
    ) AS net_match_intensity,

    -- Simple attacking efficiency
    ROUND(
        tms.goals_scored / NULLIF(tom.total_shots, 0),
        4
    ) AS shot_conversion_rate,

    -- Technical metadata
    CURRENT_TIMESTAMP() AS gold_generated_timestamp

FROM football_dev.gold.team_match_stats tms

LEFT JOIN football_dev.gold.team_offensive_metrics tom
    ON tms.match_id = tom.match_id
   AND tms.team_id = tom.team_id

LEFT JOIN football_dev.gold.team_defensive_metrics tdm
    ON tms.match_id = tdm.match_id
   AND tms.team_id = tdm.team_id;