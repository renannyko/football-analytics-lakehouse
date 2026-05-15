# Football Analytics Lakehouse

## Overview

Football Analytics Lakehouse is an end-to-end modern Data Engineering and Analytics project built on the Databricks Lakehouse Platform.

The project simulates a production-grade sports analytics platform using modern Lakehouse concepts, Medallion Architecture, CI/CD, Data Governance, Observability, Orchestration, and Business Intelligence visualization practices.

The primary objective is to transform raw football event data into curated analytical datasets optimized for:

* Tactical analysis
* Match storytelling
* Spatial event analytics
* Performance monitoring
* Future Machine Learning use cases

---

# Project Objectives

This project focuses on:

* Building a modern Medallion Lakehouse architecture
* Practicing Databricks Data Engineering concepts
* Implementing Delta Lake best practices
* Creating production-style declarative pipelines
* Applying governance using Unity Catalog
* Designing reusable Gold analytical models
* Implementing CI/CD workflows using GitHub Actions
* Creating observability and monitoring datasets
* Building tactical football analytics dashboards in Power BI
* Preparing analytical datasets for future ML applications

---

# Technology Stack

| Layer                  | Technology                           |
| ---------------------- | ------------------------------------ |
| Lakehouse Platform     | Databricks                           |
| Storage Format         | Delta Lake                           |
| Governance             | Unity Catalog                        |
| Pipeline Framework     | Lakeflow Declarative Pipelines / DLT |
| Infrastructure as Code | Databricks Asset Bundles             |
| CI/CD                  | GitHub Actions                       |
| Development            | VS Code                              |
| Version Control        | GitHub                               |
| Visualization          | Power BI                             |
| Data Source            | StatsBomb Open Data                  |
| Languages              | SQL-first approach + Python          |

---

# High-Level Architecture

```text
StatsBomb Open Data
        ↓
Landing / Raw Files
        ↓
Bronze Layer
        ↓
Silver Layer
        ↓
Gold Layer
        ↓
Power BI Analytics
```

---

# Medallion Architecture

## Bronze Layer

The Bronze layer stores raw ingested datasets with minimal transformations.

### Objectives

* Preserve source fidelity
* Maintain raw historical traceability
* Support schema evolution
* Enable replayability

### Example Bronze Tables

* bronze.raw_events
* bronze.raw_matches
* bronze.raw_lineups
* bronze.raw_competitions

---

## Silver Layer

The Silver layer standardizes, cleans, and enriches football event data.

### Objectives

* Normalize structures
* Apply business logic
* Standardize event attributes
* Enforce data quality constraints
* Create analytical-ready entities

### Example Silver Tables

* silver.events
* silver.shots
* silver.pressures
* silver.player_match_stats

### Data Quality

The project uses Delta Live Tables Expectations for:

* Null validation
* Event integrity
* Entity consistency
* Mandatory identifiers

Example:

```sql
CONSTRAINT valid_event_id EXPECT (
    event_id IS NOT NULL
)
```

---

## Gold Layer

The Gold layer contains curated analytical models optimized for BI and tactical analysis.

### Objectives

* Tactical analysis
* Match storytelling
* KPI generation
* Spatial analysis
* Aggregated analytics
* Observability
* Future ML features

### Example Gold Tables

| Table                           | Purpose                           |
| ------------------------------- | --------------------------------- |
| gold.match_summary              | Match KPIs and overview           |
| gold.match_momentum             | Match momentum windows            |
| gold.shot_events                | Shot-level tactical visualization |
| gold.pressure_events            | Pressure event visualization      |
| gold.shot_zones                 | Spatial shot distributions        |
| gold.pressure_zones             | Defensive pressure density        |
| gold.pipeline_table_metrics     | Observability row counts          |
| gold.pipeline_freshness_metrics | Data freshness monitoring         |
| gold.pipeline_quality_metrics   | Data quality metrics              |
| gold.pipeline_execution_metrics | Pipeline health monitoring        |

---

# Data Source

## StatsBomb Open Data

Public football event-level datasets provided by StatsBomb.

### Included Data

* Match metadata
* Event-level actions
* Shots
* Passes
* Pressures
* Tactical structures
* Player actions
* Spatial coordinates
* Possession information

Repository:

[https://github.com/statsbomb/open-data](https://github.com/statsbomb/open-data)

---

# Tactical Analytics Features

The project currently includes:

* Shot Location Maps
* Pressure Maps
* Match Momentum Analysis
* Spatial Tactical Visualization
* Temporal Match Windows
* Event-level Tactical Exploration
* Player Match Statistics

---

# Power BI Dashboard

The Power BI layer was designed using a tactical dark-theme football visualization approach.

### Dashboard Features

* Tactical event maps
* Interactive match filtering
* Minute window analysis
* Shot outcome visualization
* Pressure intensity analysis
* Match momentum exploration
* Football field spatial rendering

---

# CI/CD Architecture

The project implements CI/CD using GitHub Actions and Databricks Asset Bundles.

## Continuous Integration (CI)

Every push to the repository automatically:

```text
Git Push
    ↓
Validate DEV Bundle
    ↓
Validate PROD Bundle
```

### Benefits

* Early validation of bundle errors
* Automated deployment checks
* Safer development workflow
* Infrastructure consistency

---

## Continuous Deployment (CD)

The deployment flow separates DEV and PROD environments.

### DEV Deployment

Automatically deployed after successful validation.

```text
Git Push
    ↓
Deploy DEV
```

### PROD Deployment

Protected by manual approval.

```text
Manual Approval
    ↓
Deploy PROD
```

### Benefits

* Controlled production releases
* Environment separation
* Safer deployment process
* Enterprise-style release management

---

# Environment Strategy

The project currently uses:

| Environment | Catalog       |
| ----------- | ------------- |
| DEV         | football_dev  |
| PROD        | football_prod |

---

# Orchestration

The project includes a centralized orchestration workflow.

```text
StatsBomb Ingestion Job
        ↓
Bronze Pipeline
        ↓
Silver Pipeline
        ↓
Gold Pipeline
```

This orchestration demonstrates:

* Dependency management
* Production-style execution sequencing
* Automated pipeline coordination
* Lakehouse operational workflows

---

# Observability Layer

The project includes an operational observability layer.

## Monitoring Features

* Row count monitoring
* Freshness monitoring
* Data quality metrics
* Pipeline execution health

## Example Observability Models

| Table                      | Purpose                     |
| -------------------------- | --------------------------- |
| pipeline_table_metrics     | Row count monitoring        |
| pipeline_freshness_metrics | Data freshness tracking     |
| pipeline_quality_metrics   | Data quality validation     |
| pipeline_execution_metrics | Operational pipeline health |

---

# Repository Structure

```text
football-analytics-lakehouse/
│
├── .github/
│   └── workflows/
│
├── docs/
├── notebooks/
├── pipelines/
├── resources/
├── sql/
├── src/
│   └── ingestion/
├── tests/
│
├── databricks.yml
├── README.md
└── LICENSE
```

---

# Development Workflow

```text
Code Changes
    ↓
Git Commit
    ↓
Git Push
    ↓
GitHub Actions Validation
    ↓
Automatic DEV Deployment
    ↓
DEV Testing
    ↓
Manual PROD Approval
    ↓
Production Deployment
```

---

# Screenshots

## Tactical Analysis

> Add Power BI tactical analysis screenshot here.

---

## Pressure Map

> Add pressure map screenshot here.

---

## GitHub Actions CI/CD

> Add GitHub Actions workflow screenshot here.

---

## Databricks Observability Models

> Add observability metrics screenshot here.

---

# Additional Documentation

| Document | Description |
|---|---|
| [Architecture Documentation](docs/architecture.md) | Detailed technical architecture, CI/CD, observability, orchestration, and Lakehouse design documentation. |

---

# Future Roadmap

Planned future enhancements:

* xThreat (Expected Threat)
* Passing Network Analysis
* Player Radar Charts
* Real-time ingestion
* Streaming analytics
* ML feature engineering
* Match prediction models
* Tactical clustering
* Event sequence analysis
* Automated alerting

---

# Key Engineering Concepts Demonstrated

This project demonstrates:

* Modern Lakehouse Architecture
* Medallion Data Modeling
* Declarative Pipelines
* Data Governance
* CI/CD for Data Engineering
* Observability and Monitoring
* Environment Separation
* Orchestration Workflows
* Tactical Sports Analytics
* Production-style Engineering Practices

---

# Author

Renan Vitor Nyko

LinkedIn:
[https://www.linkedin.com/in/renannyko/](https://www.linkedin.com/in/renannyko/)

GitHub:
[https://github.com/renannyko](https://github.com/renannyko)