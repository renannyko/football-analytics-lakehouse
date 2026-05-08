CREATE OR REFRESH STREAMING TABLE raw_matches
COMMENT "Bronze streaming table containing raw StatsBomb match data for the selected competition and season."
AS

SELECT
    match_id,
    match_date,
    kick_off,
    home_score,
    away_score,
    match_status,
    match_status_360,
    last_updated,
    last_updated_360,
    match_week,

    competition.competition_id AS competition_id,
    competition.competition_name AS competition_name,
    competition.country_name AS competition_country_name,

    season.season_id AS season_id,
    season.season_name AS season_name,

    home_team.home_team_id AS home_team_id,
    home_team.home_team_name AS home_team_name,
    home_team.home_team_gender AS home_team_gender,

    away_team.away_team_id AS away_team_id,
    away_team.away_team_name AS away_team_name,
    away_team.away_team_gender AS away_team_gender,

    competition_stage.id AS competition_stage_id,
    competition_stage.name AS competition_stage_name,

    stadium.id AS stadium_id,
    stadium.name AS stadium_name,

    referee.id AS referee_id,
    referee.name AS referee_name,

    metadata.data_version AS data_version,
    metadata.shot_fidelity_version AS shot_fidelity_version,
    metadata.xy_fidelity_version AS xy_fidelity_version,

    'statsbomb' AS source_system,
    'matches' AS source_entity,
    current_timestamp() AS ingestion_timestamp,
    _metadata.file_path AS source_file

FROM STREAM read_files(
    '/Volumes/football_dev/bronze/raw_files/statsbomb/matches_43_106/',
    format => 'json',
    schema => '
        match_id INT,
        match_date DATE,
        kick_off STRING,
        home_score INT,
        away_score INT,
        match_status STRING,
        match_status_360 STRING,
        last_updated TIMESTAMP,
        last_updated_360 TIMESTAMP,
        match_week INT,

        competition STRUCT<
            competition_id: INT,
            country_name: STRING,
            competition_name: STRING
        >,

        season STRUCT<
            season_id: INT,
            season_name: STRING
        >,

        home_team STRUCT<
            home_team_id: INT,
            home_team_name: STRING,
            home_team_gender: STRING
        >,

        away_team STRUCT<
            away_team_id: INT,
            away_team_name: STRING,
            away_team_gender: STRING
        >,

        competition_stage STRUCT<
            id: INT,
            name: STRING
        >,

        stadium STRUCT<
            id: INT,
            name: STRING
        >,

        referee STRUCT<
            id: INT,
            name: STRING
        >,

        metadata STRUCT<
            data_version: STRING,
            shot_fidelity_version: STRING,
            xy_fidelity_version: STRING
        >
    ',
    multiLine => true
);