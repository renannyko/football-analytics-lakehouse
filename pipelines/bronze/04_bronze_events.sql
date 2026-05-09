CREATE OR REFRESH STREAMING TABLE raw_events
COMMENT "Bronze streaming table containing raw StatsBomb event-level data for the selected match scope."
AS

SELECT
    3869685 AS match_id,
    id AS event_id,
    index AS event_index,
    period,
    timestamp AS event_timestamp,
    minute,
    second,

    type.id AS event_type_id,
    type.name AS event_type_name,

    possession,
    possession_team.id AS possession_team_id,
    possession_team.name AS possession_team_name,

    play_pattern.id AS play_pattern_id,
    play_pattern.name AS play_pattern_name,

    team.id AS team_id,
    team.name AS team_name,

    player.id AS player_id,
    player.name AS player_name,

    position.id AS position_id,
    position.name AS position_name,

    location,

    duration,
    under_pressure,
    off_camera,
    out,

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

    'statsbomb' AS source_system,
    'events' AS source_entity,
    current_timestamp() AS ingestion_timestamp,
    _metadata.file_path AS source_file

FROM STREAM read_files(
    '/Volumes/football_dev/bronze/raw_files/statsbomb/events_3869685/',
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