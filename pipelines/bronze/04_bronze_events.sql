/*
===============================================================================
Bronze Events Pipeline
===============================================================================

Description:
    Bronze streaming table responsible for ingesting StatsBomb event-level JSON
    files for all selected FIFA World Cup 2022 matches.

    This table preserves semi-structured event payloads and enriches each row
    with operational metadata required for downstream Silver and Gold models.

Project:
    Football Analytics Lakehouse

Layer:
    Bronze

Source:
    StatsBomb Open Data

Architecture:
    Unity Catalog Volume
        -> Bronze Streaming Table
        -> Silver Event Standardization
        -> Gold Analytical Models
===============================================================================
*/

CREATE OR REFRESH STREAMING TABLE raw_events

COMMENT "Bronze streaming table containing raw StatsBomb event-level data for selected match files."

TBLPROPERTIES (
    'data_domain' = 'football_analytics',
    'data_layer' = 'bronze',
    'data_product' = 'raw_events',
    'owner_team' = 'analytics_engineering',
    'data_classification' = 'public',
    'ingestion_type' = 'streaming',
    'refresh_frequency' = 'on_pipeline_run',
    'business_purpose' = 'Stores raw StatsBomb event-level data for downstream event standardization, tactical analytics, and analytical processing.'
)

AS

SELECT
    -- Match identifier extracted from the source file path.
    -- Example path:
    -- /Volumes/football_dev/bronze/raw_files/statsbomb/events_3869685/events_3869685.json
    CAST(
    regexp_extract(
        _metadata.file_path,
        'events_([0-9]+)\\.json',
        1
    ) AS INT
)   AS match_id,

    -- Event identifiers
    id AS event_id,
    index AS event_index,

    -- Match timing
    period,
    timestamp AS event_timestamp,
    minute,
    second,

    -- Event classification
    type.id AS event_type_id,
    type.name AS event_type_name,

    -- Possession context
    possession,
    possession_team.id AS possession_team_id,
    possession_team.name AS possession_team_name,

    -- Play pattern context
    play_pattern.id AS play_pattern_id,
    play_pattern.name AS play_pattern_name,

    -- Team attributes
    team.id AS team_id,
    team.name AS team_name,

    -- Player attributes
    player.id AS player_id,
    player.name AS player_name,

    -- Player position
    position.id AS position_id,
    position.name AS position_name,

    -- Event location
    location,

    -- Event metadata
    duration,
    under_pressure,
    off_camera,
    out,

    -- Raw event-type payloads preserved as strings for downstream parsing
    pass,
    shot,
    carry,
    duel,
    dribble,
    foul_committed,
    foul_won,
    goalkeeper,
    clearance,
    interception,
    ball_recovery,
    block,
    substitution,
    tactics,
    related_events,

    -- Technical metadata
    'statsbomb' AS source_system,
    'events' AS source_entity,
    current_timestamp() AS ingestion_timestamp,
    _metadata.file_path AS source_file

FROM STREAM read_files(
    '/Volumes/football_dev/bronze/raw_files/statsbomb/events_*/*.json',
    format => 'json',
    schema => '
        id STRING,
        index INT,
        period INT,
        timestamp STRING,
        minute INT,
        second INT,

        type STRUCT<
            id: INT,
            name: STRING
        >,

        possession INT,

        possession_team STRUCT<
            id: INT,
            name: STRING
        >,

        play_pattern STRUCT<
            id: INT,
            name: STRING
        >,

        team STRUCT<
            id: INT,
            name: STRING
        >,

        player STRUCT<
            id: INT,
            name: STRING
        >,

        position STRUCT<
            id: INT,
            name: STRING
        >,

        location ARRAY<DOUBLE>,

        duration DOUBLE,
        under_pressure BOOLEAN,
        off_camera BOOLEAN,
        out BOOLEAN,

        pass STRING,
        shot STRING,
        carry STRING,
        duel STRING,
        dribble STRING,
        foul_committed STRING,
        foul_won STRING,
        goalkeeper STRING,
        clearance STRING,
        interception STRING,
        ball_recovery STRING,
        block STRING,
        substitution STRING,
        tactics STRING,
        related_events ARRAY<STRING>
    ',
    multiLine => true
);