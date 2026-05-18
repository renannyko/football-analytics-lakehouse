# Architecture Diagrams

## Football Analytics Lakehouse

---

# Overview

This document provides visual architecture diagrams for the Football Analytics Lakehouse platform.

The diagrams were created using Mermaid and are intended to support:

- technical documentation
- portfolio presentation
- architecture review
- recruiter and interviewer storytelling
- enterprise-style data platform communication

---

# 1. High-Level Lakehouse Architecture

```mermaid
flowchart LR

    A[StatsBomb Open Data] --> B[Unity Catalog Volumes]
    B --> C[Bronze Streaming Tables]
    C --> D[Silver Standardized Tables]
    D --> E[Gold Analytical Models]

    E --> F[Power BI Dashboards]
    E --> G[Observability Models]
    E --> H[Future Advanced Analytics]

    C:::bronze
    D:::silver
    E:::gold
    F:::consumption
    G:::observability
    H:::advanced

    classDef bronze fill:#8B5A2B,color:#fff,stroke:#333;
    classDef silver fill:#8A8A8A,color:#fff,stroke:#333;
    classDef gold fill:#D4AF37,color:#000,stroke:#333;
    classDef consumption fill:#2563EB,color:#fff,stroke:#333;
    classDef observability fill:#7C3AED,color:#fff,stroke:#333;
    classDef advanced fill:#059669,color:#fff,stroke:#333;
```

---

# 2. Medallion Data Flow

```mermaid
flowchart TD

    A[Raw JSON Files] --> B[Bronze Layer]

    B --> B1[raw_competitions]
    B --> B2[raw_matches]
    B --> B3[raw_lineups]
    B --> B4[raw_events]

    B1 --> C[Silver Layer]
    B2 --> C
    B3 --> C
    B4 --> C

    C --> C1[competitions]
    C --> C2[matches]
    C --> C3[lineups]
    C --> C4[events]

    C4 --> C5[shots]
    C4 --> C6[passes]
    C4 --> C7[carries]
    C4 --> C8[dribbles]
    C4 --> C9[pressures]
    C4 --> C10[duels]
    C4 --> C11[fouls]
    C4 --> C12[goalkeeper_actions]
    C4 --> C13[substitutions]
    C4 --> C14[event_related_events]

    C1 --> D[Gold Layer]
    C2 --> D
    C3 --> D
    C5 --> D
    C6 --> D
    C7 --> D
    C8 --> D
    C9 --> D
    C10 --> D
    C11 --> D
    C12 --> D
    C13 --> D
    C14 --> D

    D --> D1[Match Analytics]
    D --> D2[Team Analytics]
    D --> D3[Player Analytics]
    D --> D4[Spatial Analytics]
    D --> D5[Tactical Sequences]
    D --> D6[Semantic Dimensions]
    D --> D7[Observability]

    class B,B1,B2,B3,B4 bronze;
    class C,C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14 silver;
    class D,D1,D2,D3,D4,D5,D6,D7 gold;

    classDef bronze fill:#8B5A2B,color:#fff,stroke:#333;
    classDef silver fill:#8A8A8A,color:#fff,stroke:#333;
    classDef gold fill:#D4AF37,color:#000,stroke:#333;
```

---

# 3. Pipeline Orchestration Flow

```mermaid
flowchart TD

    A[Lakeflow Orchestrator Job] --> B[StatsBomb Ingestion]
    B --> C[Bronze Pipeline]
    C --> D[Silver Pipeline]
    D --> E[Gold Pipeline]

    E --> F[Power BI Serving Layer]
    E --> G[Observability Layer]
    E --> H[Future Advanced Analytics Layer]

    B:::job
    C:::bronze
    D:::silver
    E:::gold
    F:::consumption
    G:::observability
    H:::advanced

    classDef job fill:#0F172A,color:#fff,stroke:#333;
    classDef bronze fill:#8B5A2B,color:#fff,stroke:#333;
    classDef silver fill:#8A8A8A,color:#fff,stroke:#333;
    classDef gold fill:#D4AF37,color:#000,stroke:#333;
    classDef consumption fill:#2563EB,color:#fff,stroke:#333;
    classDef observability fill:#7C3AED,color:#fff,stroke:#333;
    classDef advanced fill:#059669,color:#fff,stroke:#333;
```

---

# 4. Gold Analytical Domains

```mermaid
flowchart TD

    A[Gold Analytical Serving Layer] --> B[Match Analytics]
    A --> C[Team Analytics]
    A --> D[Player Analytics]
    A --> E[Spatial Analytics]
    A --> F[Tactical Sequence Analytics]
    A --> G[Semantic Dimensions]
    A --> H[Observability Models]
    A --> I[Advanced Analytics Preparation]

    B --> B1[match_summary]
    B --> B2[match_momentum]
    B --> B3[match_timeline]

    C --> C1[team_match_stats]
    C --> C2[team_season_stats]
    C --> C3[team_offensive_metrics]
    C --> C4[team_defensive_metrics]

    D --> D1[player_match_stats]
    D --> D2[player_season_stats]
    D --> D3[player_offensive_metrics]
    D --> D4[player_defensive_metrics]

    E --> E1[shot_events]
    E --> E2[pressure_events]
    E --> E3[shot_zones]
    E --> E4[pressure_zones]

    F --> F1[passing_network]
    F --> F2[possession_sequences]

    G --> G1[dim_match]
    G --> G2[dim_team]
    G --> G3[dim_player]
    G --> G4[dim_match_time_window]

    H --> H1[pipeline_table_metrics]
    H --> H2[pipeline_freshness_metrics]
    H --> H3[pipeline_quality_metrics]
    H --> H4[pipeline_execution_metrics]

    I --> I1[expected_goals_features]
    I --> I2[match_features_ml]
    I --> I3[player_features_ml]

    class A gold;
    class B,C,D,E,F,G goldDomain;
    class H observability;
    class I advanced;

    classDef gold fill:#D4AF37,color:#000,stroke:#333;
    classDef goldDomain fill:#FACC15,color:#000,stroke:#333;
    classDef observability fill:#7C3AED,color:#fff,stroke:#333;
    classDef advanced fill:#059669,color:#fff,stroke:#333;
```

---

# 5. Governance Architecture

```mermaid
flowchart TD

    A[Unity Catalog] --> B[Catalogs]

    B --> C[football_dev]
    B --> D[football_prod]

    C --> E[Bronze Schema]
    C --> F[Silver Schema]
    C --> G[Gold Schema]

    D --> H[Bronze Schema]
    D --> I[Silver Schema]
    D --> J[Gold Schema]

    E --> K[Comments]
    F --> K
    G --> K

    E --> L[TBLPROPERTIES]
    F --> L
    G --> L

    E --> M[Unity Catalog Tags]
    F --> M
    G --> M

    K --> N[Semantic Documentation]
    L --> O[Technical Metadata]
    M --> P[Governance Discovery]

    N --> Q[Catalog Explorer]
    O --> Q
    P --> Q

    class A governance;
    class C,D catalog;
    class E,H bronze;
    class F,I silver;
    class G,J gold;
    class K,L,M metadata;
    class Q discovery;

    classDef governance fill:#0F172A,color:#fff,stroke:#333;
    classDef catalog fill:#1E40AF,color:#fff,stroke:#333;
    classDef bronze fill:#8B5A2B,color:#fff,stroke:#333;
    classDef silver fill:#8A8A8A,color:#fff,stroke:#333;
    classDef gold fill:#D4AF37,color:#000,stroke:#333;
    classDef metadata fill:#7C3AED,color:#fff,stroke:#333;
    classDef discovery fill:#059669,color:#fff,stroke:#333;
```

---

# 6. Observability Architecture

```mermaid
flowchart TD

    A[Bronze Tables] --> D[pipeline_table_metrics]
    B[Silver Tables] --> D
    C[Gold Tables] --> D

    A --> E[pipeline_freshness_metrics]
    B --> E
    C --> E

    B --> F[pipeline_quality_metrics]
    C --> F

    D --> G[pipeline_execution_metrics]
    E --> G
    F --> G

    G --> H[Power BI Observability Dashboard]
    G --> I[Future Alerting Layer]

    A:::bronze
    B:::silver
    C:::gold
    D:::observability
    E:::observability
    F:::observability
    G:::observability
    H:::consumption
    I:::alerting

    classDef bronze fill:#8B5A2B,color:#fff,stroke:#333;
    classDef silver fill:#8A8A8A,color:#fff,stroke:#333;
    classDef gold fill:#D4AF37,color:#000,stroke:#333;
    classDef observability fill:#7C3AED,color:#fff,stroke:#333;
    classDef consumption fill:#2563EB,color:#fff,stroke:#333;
    classDef alerting fill:#DC2626,color:#fff,stroke:#333;
```

---

# 7. CI/CD Deployment Flow

```mermaid
flowchart LR

    A[VS Code] --> B[Git Commit]
    B --> C[Git Push]
    C --> D[GitHub Repository]
    D --> E[GitHub Actions]

    E --> F[Validate DEV Bundle]
    E --> G[Validate PROD Bundle]

    F --> H[Deploy DEV]
    G --> I[Manual Approval Gate]

    I --> J[Deploy PROD]

    H --> K[Databricks DEV Target]
    J --> L[Databricks PROD Target]

    K --> M[DEV Validation]
    L --> N[Production Serving]

    A:::dev
    D:::github
    E:::actions
    H:::devDeploy
    I:::approval
    J:::prodDeploy
    K:::devEnv
    L:::prodEnv

    classDef dev fill:#334155,color:#fff,stroke:#333;
    classDef github fill:#111827,color:#fff,stroke:#333;
    classDef actions fill:#2563EB,color:#fff,stroke:#333;
    classDef devDeploy fill:#059669,color:#fff,stroke:#333;
    classDef approval fill:#F97316,color:#fff,stroke:#333;
    classDef prodDeploy fill:#DC2626,color:#fff,stroke:#333;
    classDef devEnv fill:#22C55E,color:#000,stroke:#333;
    classDef prodEnv fill:#B91C1C,color:#fff,stroke:#333;
```

---

# 8. Power BI Semantic Model

```mermaid
erDiagram

    dim_match ||--o{ match_summary : filters
    dim_match ||--o{ match_momentum : filters
    dim_match ||--o{ passing_network : filters
    dim_match ||--o{ player_match_stats : filters
    dim_match ||--o{ pressure_events : filters
    dim_match ||--o{ pressure_zones : filters
    dim_match ||--o{ shot_events : filters
    dim_match ||--o{ shot_zones : filters
    dim_match ||--o{ team_match_stats : filters

    dim_team ||--o{ match_momentum : filters
    dim_team ||--o{ passing_network : filters
    dim_team ||--o{ pressure_events : filters
    dim_team ||--o{ pressure_zones : filters
    dim_team ||--o{ shot_zones : filters
    dim_team ||--o{ team_match_stats : filters
    dim_team ||--o{ team_season_stats : filters

    dim_player ||--o{ player_match_stats : filters
    dim_player ||--o{ player_season_stats : filters
    dim_player ||--o{ pressure_events : filters
    dim_player ||--o{ pressure_zones : filters
    dim_player ||--o{ shot_zones : filters

    dim_match_time_window ||--o{ match_momentum : filters
    dim_match_time_window ||--o{ pressure_events : filters
    dim_match_time_window ||--o{ pressure_zones : filters
    dim_match_time_window ||--o{ shot_events : filters

    dim_match {
        int match_id
        string competition_name
        string season_name
        date match_date
        string match_result
    }

    dim_team {
        int team_id
        string team_name
    }

    dim_player {
        int player_id
        string player_name
        int team_id
        string team_name
    }

    dim_match_time_window {
        string match_time_window_key
        int match_id
        int minute_window_start
        int minute_window_end
        string minute_window_label
    }

    match_summary {
        int match_id
        int home_team_id
        int away_team_id
        string competition_name
    }

    match_momentum {
        int match_id
        int team_id
        string match_time_window_key
    }

    passing_network {
        int match_id
        int team_id
        int passer_player_id
        int recipient_player_id
    }

    player_match_stats {
        int match_id
        int player_id
        string player_name
    }

    player_season_stats {
        int player_id
        string player_name
        int team_id
    }

    pressure_events {
        int match_id
        int player_id
        int team_id
        string match_time_window_key
    }

    pressure_zones {
        int match_id
        int player_id
        int team_id
        string match_time_window_key
    }

    shot_events {
        int match_id
        string match_time_window_key
        boolean possession_distance_to_goal
    }

    shot_zones {
        int match_id
        int player_id
        int team_id
    }

    team_match_stats {
        int match_id
        int team_id
    }

    team_season_stats {
        int team_id
    }
```

---

# 9. Advanced Analytics Preparation Flow

```mermaid
flowchart TD

    A[Silver Shots] --> B[expected_goals_features]
    C[Gold Team Metrics] --> D[match_features_ml]
    E[Gold Player Metrics] --> F[player_features_ml]

    B --> G[Future xG Experimentation]
    D --> H[Future Match-Level Modeling]
    F --> I[Future Player-Level Analysis]

    A:::silver
    C:::gold
    E:::gold
    B:::advanced
    D:::advanced
    F:::advanced
    G:::future
    H:::future
    I:::future

    classDef silver fill:#8A8A8A,color:#fff,stroke:#333;
    classDef gold fill:#D4AF37,color:#000,stroke:#333;
    classDef advanced fill:#059669,color:#fff,stroke:#333;
    classDef future fill:#0F766E,color:#fff,stroke:#333;
```

---

# Conclusion

These architecture diagrams provide a visual representation of the Football Analytics Lakehouse platform across:

- data ingestion
- Medallion architecture
- pipeline orchestration
- analytical domains
- governance
- observability
- CI/CD
- Power BI semantic modeling
- future advanced analytics

They support the technical storytelling of the project and help communicate the platform as an enterprise-style modern data engineering solution.