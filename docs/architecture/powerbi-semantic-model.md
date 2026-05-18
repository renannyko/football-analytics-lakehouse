# Power BI Semantic Model

## Football Analytics Lakehouse

---

# Overview

The Football Analytics Lakehouse semantic model was designed to support scalable and reusable analytical consumption in Power BI.

The semantic strategy follows modern dimensional modeling principles and organizes the Gold layer into:

- dimensions
- analytical fact-style tables
- tactical event datasets
- observability datasets
- ML-ready feature datasets

The model was optimized for:

- executive dashboards
- tactical football analysis
- player scouting analytics
- spatial visualizations
- observability monitoring
- future analytical extensibility

---

# Semantic Modeling Principles

The semantic model follows these principles:

- star-schema-oriented relationships
- reusable dimensions
- low-cardinality filtering
- semantic consistency
- analytical scalability
- Power BI performance optimization
- tactical visualization support
- future ML extensibility

---

# Semantic Architecture Overview

```text
Dimensions
    ↓
Analytical Fact Tables
    ↓
Power BI Measures
    ↓
Dashboards / Tactical Analytics
```

---

# Dimension Tables

## dim_match

### Purpose

Central match-level dimension used for filtering and contextual analysis.

### Key

```text
match_id
```

### Main Attributes

- competition_name
- season_name
- match_date
- match_week
- home_team_name
- away_team_name
- scoreline
- stadium_name
- referee_name

### Usage

Used by:

- shot_events
- pressure_events
- match_momentum
- team_match_stats
- player_match_stats

---

## dim_team

### Purpose

Reusable team-level dimension for analytical filtering.

### Key

```text
team_id
```

### Main Attributes

- team_name

### Usage

Used by:

- team_match_stats
- team_season_stats
- team_offensive_metrics
- team_defensive_metrics
- player_match_stats

---

## dim_player

### Purpose

Reusable player-level dimension for scouting and tactical analysis.

### Key

```text
player_id
```

### Main Attributes

- player_name
- team_name

### Usage

Used by:

- player_match_stats
- player_season_stats
- player_offensive_metrics
- player_defensive_metrics
- shot_events
- pressure_events

---

## dim_match_time_window

### Purpose

Shared temporal tactical dimension for five-minute match slicing.

### Key

```text
match_time_window_key
```

### Main Attributes

- minute_window_start
- minute_window_end
- minute_window_label
- window_sort_order

### Usage

Used by:

- match_momentum
- shot_events
- pressure_events
- pressure_zones

---

# Analytical Fact-Style Tables

---

# Match Analytics

## match_summary

### Purpose

Executive match-level KPI and contextual analysis.

### Grain

```text
One row per match
```

### Main KPIs

- goals
- scoreline
- result
- match outcome

---

## match_momentum

### Purpose

Tactical momentum and temporal match flow analysis.

### Grain

```text
One row per match time window
```

### Main KPIs

- shots
- pressures
- offensive momentum
- defensive momentum

---

# Team Analytics

## team_match_stats

### Purpose

Team-level match KPIs.

### Grain

```text
One row per match per team
```

### Main KPIs

- goals scored
- goals conceded
- points
- shots
- passes

---

## team_season_stats

### Purpose

Season-level team aggregation.

### Grain

```text
One row per season per team
```

### Main KPIs

- wins
- draws
- losses
- total points
- average goals

---

## team_offensive_metrics

### Purpose

Offensive tactical team analysis.

### Grain

```text
One row per match per team
```

### Main KPIs

- shots
- passes
- carries
- dribbles
- offensive intensity

---

## team_defensive_metrics

### Purpose

Defensive tactical team analysis.

### Grain

```text
One row per match per team
```

### Main KPIs

- pressures
- duels
- fouls
- goalkeeper actions
- defensive intensity

---

# Player Analytics

## player_match_stats

### Purpose

Player-level match performance analysis.

### Grain

```text
One row per player per match
```

### Main KPIs

- offensive actions
- defensive actions
- total actions

---

## player_season_stats

### Purpose

Season-level player aggregation.

### Grain

```text
One row per player
```

### Main KPIs

- total actions
- average actions
- shots
- passes
- pressures

---

## player_offensive_metrics

### Purpose

Scouting-oriented offensive player analysis.

### Grain

```text
One row per player
```

### Main KPIs

- shots
- passes
- carries
- dribbles
- offensive involvement score

---

## player_defensive_metrics

### Purpose

Scouting-oriented defensive player analysis.

### Grain

```text
One row per player
```

### Main KPIs

- pressures
- duels
- fouls
- goalkeeper actions
- defensive involvement score

---

# Spatial Analytics Tables

## shot_events

### Purpose

Shot-level tactical and spatial analysis.

### Grain

```text
One row per shot event
```

### Main Visualizations

- shot maps
- xG maps
- goal analysis
- shot timelines

---

## pressure_events

### Purpose

Pressure-level tactical defensive analysis.

### Grain

```text
One row per pressure event
```

### Main Visualizations

- pressure heatmaps
- defensive zones
- pressing analysis

---

## shot_zones

### Purpose

Spatial shot aggregation analysis.

### Grain

```text
One row per shot zone
```

### Main Visualizations

- shot density maps
- conversion heatmaps

---

## pressure_zones

### Purpose

Spatial pressure aggregation analysis.

### Grain

```text
One row per pressure zone
```

### Main Visualizations

- pressure density maps
- pressing intensity zones

---

# Tactical Sequence Analytics

## passing_network

### Purpose

Player-to-player passing network visualization.

### Grain

```text
One row per passing connection
```

### Main Visualizations

- passing networks
- centrality analysis
- tactical structure

---

## possession_sequences

### Purpose

Possession flow and event sequence analysis.

### Grain

```text
One row per possession sequence step
```

### Main Visualizations

- possession flows
- sequence timelines
- tactical progression

---

# Observability Tables

## pipeline_table_metrics

### Purpose

Row count monitoring.

---

## pipeline_freshness_metrics

### Purpose

Freshness monitoring.

---

## pipeline_quality_metrics

### Purpose

Data quality monitoring.

---

## pipeline_execution_metrics

### Purpose

Pipeline health visibility.

---

# Recommended Relationships

## Match Relationships

```text
dim_match[match_id]
    1 → *
shot_events[match_id]

dim_match[match_id]
    1 → *
pressure_events[match_id]

dim_match[match_id]
    1 → *
team_match_stats[match_id]

dim_match[match_id]
    1 → *
player_match_stats[match_id]
```

---

## Team Relationships

```text
dim_team[team_id]
    1 → *
team_match_stats[team_id]

dim_team[team_id]
    1 → *
team_season_stats[team_id]

dim_team[team_id]
    1 → *
player_match_stats[team_id]
```

---

## Player Relationships

```text
dim_player[player_id]
    1 → *
player_match_stats[player_id]

dim_player[player_id]
    1 → *
shot_events[player_id]

dim_player[player_id]
    1 → *
pressure_events[player_id]
```

---

## Time Window Relationships

```text
dim_match_time_window[match_time_window_key]
    1 → *
match_momentum[match_time_window_key]

dim_match_time_window[match_time_window_key]
    1 → *
shot_events[match_time_window_key]

dim_match_time_window[match_time_window_key]
    1 → *
pressure_events[match_time_window_key]
```

---

# Recommended Filter Direction

Recommended relationship behavior:

```text
Single Direction
Dimension → Fact
```

Avoid:

```text
Both-direction relationships
```

unless strictly necessary.

---

# Recommended Power BI Measures

## Goals Scored

```DAX
Goals Scored =
SUM(team_match_stats[goals_scored])
```

---

## Total Points

```DAX
Total Points =
SUM(team_match_stats[match_points])
```

---

## Average Goals Per Match

```DAX
Average Goals Per Match =
DIVIDE(
    SUM(team_match_stats[goals_scored]),
    DISTINCTCOUNT(team_match_stats[match_id])
)
```

---

## Shot Conversion Rate

```DAX
Shot Conversion Rate =
DIVIDE(
    SUM(shot_events[is_goal]),
    COUNTROWS(shot_events)
)
```

---

## Offensive Intensity

```DAX
Total Offensive Intensity =
SUM(team_offensive_metrics[offensive_intensity_score])
```

---

## Defensive Intensity

```DAX
Total Defensive Intensity =
SUM(team_defensive_metrics[defensive_intensity_score])
```

---

# Recommended Dashboard Domains

## Executive Dashboard

Recommended visuals:

- standings table
- goals scored
- win rate
- match KPIs
- competition overview

---

## Tactical Dashboard

Recommended visuals:

- shot maps
- pressure maps
- passing networks
- possession flow
- momentum charts

---

## Scouting Dashboard

Recommended visuals:

- player rankings
- offensive involvement
- defensive involvement
- radar charts
- player comparisons

---

## Observability Dashboard

Recommended visuals:

- freshness monitoring
- pipeline health
- row count monitoring
- quality validation

---

# Performance Recommendations

Recommended Power BI optimization strategies:

- use star schema relationships
- avoid bi-directional filters
- hide technical columns
- pre-aggregate heavy metrics in Gold
- avoid large calculated columns in Power BI
- prioritize DAX measures over duplicated logic
- use semantic dimensions for filtering

---

# Future Semantic Enhancements

Potential future improvements include:

- dedicated calendar dimension
- advanced DAX KPI library
- calculation groups
- semantic metric layer
- role-based row-level security
- advanced tactical metrics
- ML scoring integration
- real-time dashboard refresh

---

# Conclusion

The Football Analytics Lakehouse semantic model was designed to provide a scalable, reusable, and enterprise-style analytical foundation for Power BI.

The model combines:

- dimensional modeling principles
- tactical football analytics
- observability monitoring
- semantic consistency
- ML-ready datasets
- scalable analytical serving

This architecture enables executive reporting, tactical analysis, scouting workflows, and future Machine Learning experimentation using a unified Lakehouse semantic layer.