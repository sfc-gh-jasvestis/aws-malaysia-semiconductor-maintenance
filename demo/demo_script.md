# Equipment Predictive Maintenance

**Malaysia - Semiconductor & Electronics Manufacturing**
Use case: Predictive Maintenance

> Predict semiconductor tool failures 72 hours before they occur — IoT sensors stream to Snowflake, ML.FORECAST identifies degradation patterns, and alerts trigger before costly unplanned downtime.

## Why Snowflake

Snowflake predicts equipment failures before they happen — IoT telemetry, ML forecasting, and automated alerts, all in one platform without external ML infrastructure

- **Snowpipe Streaming for IoT telemetry** - Only demo ingesting 1M sensor readings with sub-second latency directly into Snowflake
- **ML.FORECAST for remaining useful life** - Predicts equipment failure 72 hours ahead without external SageMaker or custom models
- **ML.ANOMALY_DETECTION for sensor drift** - Detects subtle degradation patterns that operators miss in raw sensor dashboards
- **Alerts + Notification Integration** - Automated alerting pipeline replaces SNS — failure prediction triggers immediate notification
- **100 maintenance documents searchable** - Equipment manuals and failure mode guides instantly queryable for corrective actions
- **Malaysian semiconductor equipment context** - Realistic Applied Materials, ASML, Lam Research tool names and sensor parameters

## What is deployed

| | |
|---|---|
| Database | `MY_SEMICONDUCTOR_MAINTENANCE` |
| Service | `MY_SEMICONDUCTOR_MAINTENANCE_APP` |
| Compute pool | `SEA_DEMOS_MALAYSIA_POOL` |
| Dimension table | `RAW.MAINTENANCE_DOCS` (20 rows) |
| Fact table | `RAW.TELEMETRY` (250,000 rows, 90 days) |
| Curated layer | `CURATED.PERFORMANCE_SUMMARY`, `CURATED.TREND_ANALYSIS`, `CURATED.KPI_SUMMARY` |
| Currency | MYR (RM) |

Regions in play: Selangor, Johor, Penang, Sabah, Sarawak
Segments: Die Bonder, Wire Bonder, Molding Press, Test Handler

Dynamic tables are created suspended and refreshed on demand:

```bash
./refresh_demo_data.sh MY_SEMICONDUCTOR_MAINTENANCE
```

## KPI cards

Every card below is served live from `CURATED.KPI_SUMMARY`. The app keeps the
original literal as a fallback, so it still renders if Snowflake is unreachable.

| Card | Value | Backed by |
|---|---|---|
| Equipment Uptime | `96.8%` | average per event |
| Unplanned Downtime | `1.2%` | average per event |
| PM Compliance | `98%` | average per event |
| Tools Managed | `847` | total across Maintenance Docs |
| Predicted Failures (7d) | `4` | total across Maintenance Docs |
| Parts at Risk | `12` | total across Maintenance Docs |
| Spare Coverage | `94%` | average per event |


## Demo flow

1. Maintenance Overview
2. Equipment Health
3. Predictive Analytics
4. Ask AI
5. Architecture & Data

## Talking points

- **120 critical tools** - monitored across Penang/Kulim fabs
- **RM 12M** - annual unplanned downtime cost (US$2.8M)
- **72-hour window** - failure prediction lead time (ML.FORECAST)
- **8 tools** - currently in ALARM state
- **3,000 work orders** - tracked (preventive + corrective)
- **100 maintenance docs** - indexed and searchable via Cortex Search

## Business impact

- Malaysia semiconductor exports reached RM 450B (US$98B) in 2023, representing 18.4% of GDP (MIDA)
- Predictive maintenance in semiconductor fabs reduces unplanned downtime by 30-50% (Deloitte Smart Factory)
- A single unplanned equipment failure in a semiconductor fab costs $100K-$500K per incident (McKinsey Semiconductors)
- Yamaha Motor achieved real-time manufacturing intelligence on Snowflake (Snowflake Customers)

---
Generated from `generator/demo_specs/aws-malaysia-semiconductor-maintenance.json`. Do not hand-edit: run
`python3 generator/gen_repo_docs.py aws-malaysia-semiconductor-maintenance` instead.
