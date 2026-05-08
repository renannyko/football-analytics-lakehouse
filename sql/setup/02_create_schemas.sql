CREATE SCHEMA IF NOT EXISTS football_dev.bronze
COMMENT 'Bronze layer containing raw ingested data from StatsBomb Open Data.';

CREATE SCHEMA IF NOT EXISTS football_dev.silver
COMMENT 'Silver layer containing cleansed and standardized football datasets.';

CREATE SCHEMA IF NOT EXISTS football_dev.gold
COMMENT 'Gold layer containing business-ready analytical datasets and KPIs.';

CREATE SCHEMA IF NOT EXISTS football_prod.bronze
COMMENT 'Bronze layer containing production raw ingested data from StatsBomb Open Data.';

CREATE SCHEMA IF NOT EXISTS football_prod.silver
COMMENT 'Silver layer containing production cleansed and standardized football datasets.';

CREATE SCHEMA IF NOT EXISTS football_prod.gold
COMMENT 'Gold layer containing production business-ready analytical datasets and KPIs.';