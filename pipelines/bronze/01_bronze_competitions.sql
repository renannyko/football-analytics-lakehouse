CREATE OR REFRESH STREAMING TABLE raw_competitions
COMMENT "Bronze streaming table containing raw StatsBomb competitions data ingested from JSON source files."
AS

SELECT
    competition_id,
    season_id,
    country_name,
    competition_name,
    competition_gender,
    competition_youth,
    competition_international,
    season_name,
    match_updated,
    match_updated_360,
    match_available_360,
    match_available,
    'statsbomb' AS source_system,
    'competitions' AS source_entity,
    current_timestamp() AS ingestion_timestamp,
    _metadata.file_path AS source_file
FROM STREAM read_files(
    '/Volumes/football_dev/bronze/raw_files/statsbomb/competitions/',
    format => 'json',
    schema => 'competition_id INT, season_id INT, country_name STRING, competition_name STRING, competition_gender STRING, competition_youth BOOLEAN, competition_international BOOLEAN, season_name STRING, match_updated TIMESTAMP, match_updated_360 TIMESTAMP, match_available_360 TIMESTAMP, match_available TIMESTAMP',
    multiLine => true
);