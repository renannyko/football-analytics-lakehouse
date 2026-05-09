/*
===============================================================================
Gold Passing Network Pipeline
===============================================================================

Description:
    Gold materialized view responsible for creating a player-to-player passing
    network model for tactical and dashboard analysis.

Project:
    Football Analytics Lakehouse

Layer:
    Gold

Source:
    football_dev.silver.passes

Architecture:
    Silver Passes
        -> Gold Passing Network
        -> Power BI / Tactical Network Analytics
===============================================================================
*/

CREATE OR REFRESH MATERIALIZED VIEW passing_network

COMMENT "Gold analytical model containing player-to-player passing network metrics."

AS

WITH parsed_passes AS (

    SELECT
        -- Match identifiers
        match_id,

        -- Team context
        team_id,
        team_name,

        -- Pass origin player
        player_id AS passer_player_id,
        player_name AS passer_player_name,

        -- Receiver information extracted from JSON string payload
        CAST(
            regexp_extract(
                pass_payload,
                '"recipient"\\s*:\\s*\\{[^}]*"id"\\s*:\\s*([0-9]+)',
                1
            ) AS INT
        ) AS recipient_player_id,

        regexp_extract(
            pass_payload,
            '"recipient"\\s*:\\s*\\{[^}]*"name"\\s*:\\s*"([^"]+)"',
            1
        ) AS recipient_player_name,

        -- Pass origin coordinates
        pass_start_x,
        pass_start_y

    FROM football_dev.silver.passes
)

SELECT
    -- Match identifiers
    match_id,

    -- Team context
    team_id,
    team_name,

    -- Pass origin player
    passer_player_id,
    passer_player_name,

    -- Pass receiver player
    recipient_player_id,
    recipient_player_name,

    -- Passing network metrics
    COUNT(*) AS total_passes,

    -- Average pass origin location
    ROUND(AVG(pass_start_x), 2) AS avg_pass_start_x,
    ROUND(AVG(pass_start_y), 2) AS avg_pass_start_y,

    -- Technical metadata
    CURRENT_TIMESTAMP() AS gold_generated_timestamp

FROM parsed_passes

WHERE recipient_player_id IS NOT NULL

GROUP BY
    match_id,
    team_id,
    team_name,
    passer_player_id,
    passer_player_name,
    recipient_player_id,
    recipient_player_name;