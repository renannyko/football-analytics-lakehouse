/*
===============================================================================
Gold Team Dimension Pipeline
===============================================================================

Description:
    Gold materialized view responsible for creating the official team dimension
    used by Power BI and downstream analytical models.

    This dimension consolidates unique team records from Gold analytical models
    and provides a stable team-level lookup table for star schema modeling.

    This dataset is optimized for:
    - Power BI semantic modeling
    - star schema relationships
    - team-level filtering
    - reusable analytical consumption

Project:
    Football Analytics Lakehouse

Layer:
    Gold

Source:
    football_dev.gold.team_match_stats

Architecture:
    Gold Analytical Models
        -> Gold Team Dimension
        -> Power BI Semantic Model
===============================================================================
*/

CREATE OR REFRESH MATERIALIZED VIEW dim_team

COMMENT "Gold dimension containing unique football teams for semantic modeling."

AS

SELECT DISTINCT
    -- Team identifiers
    team_id,

    -- Team attributes
    team_name,

    -- Technical metadata
    CURRENT_TIMESTAMP() AS gold_generated_timestamp

FROM football_dev.gold.team_match_stats

WHERE
    team_id IS NOT NULL
    AND team_name IS NOT NULL;