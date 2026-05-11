/*
===============================================================================
Gold Player Dimension Pipeline
===============================================================================

Description:
    Gold materialized view responsible for creating the official player
    dimension used by Power BI and downstream analytical models.

    This dimension consolidates unique player records from Gold analytical
    models and includes team context for simplified dashboard filtering.

    This dataset is optimized for:
    - Power BI semantic modeling
    - star schema relationships
    - player-level filtering
    - scouting and player analytics

Project:
    Football Analytics Lakehouse

Layer:
    Gold

Source:
    football_dev.gold.player_season_stats

Architecture:
    Gold Analytical Models
        -> Gold Player Dimension
        -> Power BI Semantic Model
===============================================================================
*/

CREATE OR REFRESH MATERIALIZED VIEW dim_player

COMMENT "Gold dimension containing unique football players for semantic modeling."

AS

SELECT DISTINCT
    -- Player identifiers
    player_id,

    -- Player attributes
    player_name,

    -- Current analytical team context
    team_id,
    team_name,

    -- Technical metadata
    CURRENT_TIMESTAMP() AS gold_generated_timestamp

FROM football_dev.gold.player_season_stats

WHERE
    player_id IS NOT NULL
    AND player_name IS NOT NULL;