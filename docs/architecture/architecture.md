# Architecture

## Football Analytics Lakehouse

---

# Executive Architecture Vision

The Football Analytics Lakehouse was designed as a modern enterprise-style analytical platform built on Databricks using Lakehouse architecture principles, Medallion data modeling, declarative pipelines, metadata-driven engineering, and centralized governance.

The platform simulates real-world analytical engineering patterns commonly used in scalable enterprise data platforms while focusing on football analytics, tactical reporting, observability monitoring, and semantic analytical serving.

The architecture combines:

- scalable ingestion pipelines
- Medallion Architecture
- Delta Live Tables
- Unity Catalog governance
- metadata-driven engineering
- observability monitoring
- semantic Power BI modeling
- CI/CD deployment automation
- reusable analytical domains

The project uses StatsBomb Open Data as its primary source system and was intentionally designed to emphasize enterprise engineering best practices instead of isolated notebook experimentation.

---

# Architectural Principles

The platform architecture follows these principles:

- declarative engineering
- metadata-driven design
- modular analytical domains
- scalable Medallion Architecture
- semantic consistency
- governance-first engineering
- observability-first architecture
- reusable analytical modeling
- CI/CD automation
- environment isolation

---

# High-Level Platform Architecture

```text
StatsBomb Open Data
        │
        ▼
Unity Catalog Volumes
        │
        ▼
Bronze Streaming Layer
        │
        ▼
Silver Standardized Layer
        │
        ▼
Gold Analytical Serving Layer
        │
        ├── Power BI Dashboards
        ├── Tactical Analytics
        ├── Observability Layer
        └── Future Advanced Analytics
```

---

# Platform Architecture Layers

---

# 1. Source Layer

## Source System

The platform uses:

```text
StatsBomb Open Data
```

as the primary source system.

## Source Characteristics

The source dataset contains:

- competitions
- matches
- lineups
- event-level football actions
- tactical event metadata
- spatial event coordinates

## Source Format

Source files are provided as:

```text
JSON
```

files stored inside Unity Catalog Volumes.

---

# 2. Storage Layer

## Unity Catalog Volumes

Raw source files are stored inside Unity Catalog Volumes.

### Responsibilities

- centralized storage
- governance integration
- secure file access
- ingestion standardization
- lineage enablement

### Example Path

```text
/Volumes/football_dev/bronze/raw_files/statsbomb/
```

---

# 3. Bronze Layer

## Purpose

The Bronze layer preserves raw source fidelity and ingestion lineage.

## Architectural Characteristics

- streaming ingestion
- raw source preservation
- minimal transformation
- operational metadata enrichment
- ingestion lineage tracking

## Main Responsibilities

- raw ingestion
- source preservation
- ingestion metadata
- operational traceability

## Main Tables

- raw_competitions
- raw_matches
- raw_lineups
- raw_events

## Metadata Standards

Bronze tables include:

- table comments
- TBLPROPERTIES
- Unity Catalog TAGS
- ingestion timestamps
- source file lineage

---

# 4. Silver Layer

## Purpose

The Silver layer standardizes and validates football event structures.

## Architectural Characteristics

- streaming standardization
- semantic normalization
- data quality enforcement
- event specialization
- reusable analytical structures

## Main Responsibilities

- event normalization
- semantic organization
- data quality enforcement
- analytical standardization

## Data Quality Strategy

The Silver layer implements Delta Live Tables Expectations.

### Example

```sql
CONSTRAINT valid_event_id EXPECT (
    event_id IS NOT NULL
)
```

## Main Tables

### Core Standardized Tables

- competitions
- matches
- lineups
- events

### Specialized Event Tables

- shots
- passes
- carries
- dribbles
- pressures
- duels
- fouls
- goalkeeper_actions
- substitutions
- event_related_events

---

# 5. Gold Layer

## Purpose

The Gold layer delivers analytical, tactical, semantic, and observability datasets optimized for Power BI and advanced analytical consumption.

## Architectural Characteristics

- analytical serving layer
- semantic-ready datasets
- tactical analytical models
- observability models
- reusable KPIs
- pre-aggregated analytics

## Main Responsibilities

- KPI generation
- tactical analysis
- semantic modeling
- observability monitoring
- analytical serving

---

# Gold Analytical Domains

---

## Match Analytics

### Main Tables

- match_summary
- match_momentum
- match_timeline

### Main Capabilities

- match-level KPIs
- temporal analysis
- momentum analysis
- executive reporting

---

## Team Analytics

### Main Tables

- team_match_stats
- team_season_stats
- team_offensive_metrics
- team_defensive_metrics

### Main Capabilities

- team performance analysis
- offensive metrics
- defensive metrics
- tactical team comparisons

---

## Player Analytics

### Main Tables

- player_match_stats
- player_season_stats
- player_offensive_metrics
- player_defensive_metrics

### Main Capabilities

- scouting analysis
- player comparisons
- offensive involvement
- defensive involvement

---

## Spatial Analytics

### Main Tables

- shot_events
- pressure_events
- shot_zones
- pressure_zones

### Main Capabilities

- shot maps
- pressure heatmaps
- tactical spatial analysis
- density visualization

---

## Tactical Sequence Analytics

### Main Tables

- passing_network
- possession_sequences

### Main Capabilities

- passing network visualization
- possession flow analysis
- tactical progression analysis

---

## Semantic Dimensions

### Main Tables

- dim_match
- dim_team
- dim_player
- dim_match_time_window

### Main Capabilities

- semantic filtering
- star-schema modeling
- Power BI optimization

---

## Observability Models

### Main Tables

- pipeline_table_metrics
- pipeline_freshness_metrics
- pipeline_quality_metrics
- pipeline_execution_metrics

### Main Capabilities

- row count monitoring
- freshness validation
- quality monitoring
- execution health visibility

---

# Governance Architecture

The platform implements centralized governance using Unity Catalog.

## Governance Components

- Unity Catalog
- semantic comments
- TBLPROPERTIES
- Unity Catalog TAGS
- metadata-driven discovery
- lineage visibility

## Governance Strategy

Governance is implemented directly inside the pipeline definitions using:

- declarative metadata
- embedded governance standards
- metadata-driven engineering

## Metadata Categories

### Technical Metadata

- ingestion timestamps
- source lineage
- source system
- source entity

### Governance Metadata

- data domain
- data layer
- owner team
- data classification
- refresh frequency

### Semantic Metadata

- table comments
- business descriptions
- analytical purpose

---

# Metadata-Driven Engineering

The platform heavily adopts metadata-driven engineering principles.

## Implemented Metadata Standards

### Table Comments

```sql
COMMENT "Gold analytical model containing tactical football metrics."
```

### TBLPROPERTIES

```sql
TBLPROPERTIES (
    'data_domain' = 'football_analytics',
    'data_layer' = 'gold',
    'owner_team' = 'analytics_engineering'
)
```

### Unity Catalog TAGS

```sql
SET TAGS (
    'layer' = 'gold',
    'consumption_type' = 'power_bi'
)
```

---

# Observability Architecture

The platform implements lightweight observability directly inside the Lakehouse.

## Monitoring Categories

### Operational Monitoring

- row counts
- freshness validation
- execution health

### Data Quality Monitoring

- null validations
- quality ratios
- semantic consistency

### Pipeline Health Monitoring

- execution visibility
- freshness availability
- table population validation

## Observability Philosophy

The observability layer was intentionally designed to remain lightweight while demonstrating enterprise-style monitoring patterns directly inside the Lakehouse.

---

# Power BI Semantic Architecture

The Gold layer was intentionally designed for scalable semantic modeling inside Power BI.

## Semantic Design Principles

- reusable dimensions
- star-schema orientation
- semantic consistency
- low-cardinality filtering
- analytical scalability

## Main Dimensions

- dim_match
- dim_team
- dim_player
- dim_match_time_window

## Main Analytical Domains

- executive analytics
- tactical analytics
- scouting analytics
- spatial analytics
- observability analytics

---

# CI/CD Architecture

The platform uses GitHub Actions and Databricks Asset Bundles for deployment automation.

## CI/CD Flow

```text
VS Code
    ↓
Git Commit
    ↓
Git Push
    ↓
GitHub Actions
    ↓
DEV Deployment
    ↓
Approval Gate
    ↓
PROD Deployment
```

## CI/CD Capabilities

- automated validation
- DEV deployment automation
- PROD approval gates
- reproducible deployments
- environment isolation
- governance-as-code

## Environment Strategy

### DEV Environment

Used for:

- active development
- validation
- testing
- architecture refinement

### PROD Environment

Used for:

- stable serving
- production deployment
- controlled promotion
- approved releases

---

# Declarative Engineering Strategy

The platform adopts declarative engineering patterns using:

- Delta Live Tables
- declarative SQL
- Databricks Asset Bundles
- metadata-driven configuration

## Benefits

- reproducibility
- maintainability
- scalability
- governance integration
- simplified deployment automation

---

# Repository Architecture

```text
football-analytics-lakehouse/
│
├── .github/
│   └── workflows/
│
├── docs/
│   ├── architecture.md
│   ├── architecture-diagrams.md
│   ├── governance.md
│   └── powerbi-semantic-model.md
│
├── resources/
│   ├── bronze_pipeline.yml
│   ├── silver_pipeline.yml
│   ├── gold_pipeline.yml
│   └── orchestrator.job.yml
│
├── src/
│   ├── bronze/
│   ├── silver/
│   ├── gold/
│   └── ingestion/
│
├── databricks.yml
│
└── README.md
```

---

# Future Architectural Evolution

Potential future enhancements include:

- real-time ingestion evolution
- enhanced observability dashboards
- automated alerting
- advanced semantic metric layers
- feature engineering expansion
- advanced tactical dashboards
- future advanced analytical experimentation

---

# Architectural Summary

The Football Analytics Lakehouse demonstrates how modern Databricks technologies can be combined to build a scalable enterprise-style analytical platform using:

- Medallion Architecture
- Delta Live Tables
- Unity Catalog Governance
- Declarative SQL Pipelines
- Metadata-Driven Engineering
- CI/CD Automation
- Tactical Football Analytics
- Semantic Power BI Modeling
- Lightweight Observability

The architecture intentionally prioritizes:

- modularity
- governance
- semantic consistency
- analytical scalability
- deployment automation
- enterprise engineering practices