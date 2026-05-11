/*
===============================================================================
Bronze Lineups Pipeline
===============================================================================

Description:
    Bronze streaming table responsible for ingesting StatsBomb lineup JSON
    files for all selected FIFA World Cup 2022 matches.

    This table preserves lineup arrays and enriches each row with operational
    metadata and match-level lineage required for downstream Silver and Gold
    transformations.

Project:
    Football Analytics Lakehouse

Layer:
    Bronze

Source:
    StatsBomb Open Data

Architecture:
    Unity Catalog Volume
        -> Bronze Streaming Table
        -> Silver Lineup Standardization
        -> Gold Analytical Models
===============================================================================
*/

CREATE OR REFRESH STREAMING TABLE raw_lineups

COMMENT "Bronze streaming table containing raw StatsBomb lineup data for selected match files."

AS

SELECT
    -- Match identifier extracted from source file path.
    -- Example path:
    -- /Volumes/football_dev/bronze/raw_files/statsbomb/lineups_3869685/lineups_3869685.json
    CAST(
        regexp_extract(
            _metadata.file_path,
            'lineups_([0-9]+)',
            1
        ) AS INT
    ) AS match_id,

    -- Team attributes
    team_id,
    team_name,

    -- Raw lineup payload
    lineup,

    -- Technical metadata
    'statsbomb' AS source_system,
    'lineups' AS source_entity,
    current_timestamp() AS ingestion_timestamp,
    _metadata.file_path AS source_file

FROM STREAM read_files(
    '/Volumes/football_dev/bronze/raw_files/statsbomb/lineups_*/*.json',
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