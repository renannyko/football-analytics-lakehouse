CREATE OR REFRESH STREAMING TABLE raw_lineups
COMMENT "Bronze streaming table containing raw StatsBomb lineup data for the selected match scope."
AS

SELECT
    team_id,
    team_name,
    lineup,

    'statsbomb' AS source_system,
    'lineups' AS source_entity,
    current_timestamp() AS ingestion_timestamp,
    _metadata.file_path AS source_file

FROM STREAM read_files(
    '/Volumes/football_dev/bronze/raw_files/statsbomb/lineups_3869685/',
    format => 'json',
    schema => '
        team_id INT,
        team_name STRING,
        lineup ARRAY<
            STRUCT<
                player_id: INT,
                player_name: STRING,
                player_nickname: STRING,
                jersey_number: INT,
                country: STRUCT<
                    id: INT,
                    name: STRING
                >
            >
        >
    ',
    multiLine => true
);