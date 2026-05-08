ALTER TABLE football_dev.bronze.raw_competitions
SET TAGS (
  'layer' = 'bronze',
  'domain' = 'football',
  'source' = 'statsbomb',
  'data_classification' = 'public',
  'pipeline_type' = 'streaming_ingestion'
);