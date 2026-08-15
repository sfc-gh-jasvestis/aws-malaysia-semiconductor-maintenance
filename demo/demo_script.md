# Demo Script: Equipment Predictive Maintenance
## ~4-Minute Recorded Walkthrough
**Format**: Screen recording with voiceover
**Target**: Customer meeting / booth loop / social share
**Narrative**: "Snowflake predicts equipment failures before they happen — IoT telemetry, ML forecasting, and automated alerts, all in one platform without external ML infrastructure"
**Demo Mode**: Open app with `?demo=true` for presenter notes

---

## Two Personas

| Persona | Role | Tool | What they care about |
|---|---|---|---|
| **Rajesh Kumar** | Maintenance Director | React App (SPCS) | Equipment uptime, maintenance cost optimization, spare parts inventory, unplanned downtime reduction |
| **Wong Mei Ling** | Equipment Engineer | Amazon QuickSight | Sensor drift patterns, vibration analysis, remaining useful life, corrective action history |

---

## What's Built

| Layer | Component | Detail |
|---|---|---|
| **RAW** | 6 tables | EQUIPMENT (120), TELEMETRY (1000000), WORK_ORDERS (3000), SPARE_PARTS (500), MAINTENANCE_DOCS (100), DOWNTIME_EVENTS (800) |
| **CURATED** | 4 Dynamic Tables | EQUIPMENT_HEALTH_SCORE, SENSOR_DRIFT_DETECTION, REMAINING_USEFUL_LIFE, MAINTENANCE_BACKLOG |
| **ML** | ML.FORECAST + ML.ANOMALY_DETECTION | Forecasting + anomaly detection |
| **AI** | COMPLETE, AI_CLASSIFY, SUMMARIZE | Classification + extraction |
| **Search** | Cortex Search | 100 documents indexed |
| **Agent** | MAINTENANCE_INTELLIGENCE_AGENT | Semantic View + Search tools |


---

## The Story

Malaysia's semiconductor fabs operate 120 critical tools worth RM 2 billion in capital equipment. Unplanned downtime costs RM 12M annually — a single lithography tool failure halts an entire production line for 48+ hours. Traditional time-based maintenance either replaces parts too early (wasting RM 3M in premature replacements) or too late (causing cascading failures). The Maintenance Director needs prediction, not reaction.

---

## Script

### [0:00–0:45] MAINTENANCE OVERVIEW

**Show**: Maintenance Overview tab

> "RM 12 million in unplanned downtime costs this year across 120 critical semiconductor tools."

**Action**: Point at RM 12M downtime cost KPI

### [0:45–1:30] EQUIPMENT HEALTH

**Show**: Equipment Health tab

> "EQ-0023 — Applied Materials etch chamber — vibration trending 2.3x above baseline over 14 days."

**Action**: Click EQ-0023 in equipment list

### [1:30–2:15] PREDICTIVE ANALYTICS

**Show**: Predictive Analytics tab

> "ML.FORECAST projects remaining useful life for all 120 tools — updated every 4 hours."

**Action**: Show RUL forecast chart with confidence bands

### [2:15–3:00] ASK AI

**Show**: Ask AI tab

> "Rajesh asks: 'Which tools should I schedule for maintenance this week?'"

**Action**: Type: 'Which tools need maintenance this week?'

### [3:00–3:45] ARCHITECTURE & DATA

**Show**: Architecture & Data tab

> "IoT Core streams 1 million sensor readings via Snowpipe Streaming — sub-second latency."

**Action**: Walk through architecture diagram


---

## Key Demo Differentiators

1. **Snowpipe Streaming for IoT telemetry** — Only demo ingesting 1M sensor readings with sub-second latency directly into Snowflake
2. **ML.FORECAST for remaining useful life** — Predicts equipment failure 72 hours ahead without external SageMaker or custom models
3. **ML.ANOMALY_DETECTION for sensor drift** — Detects subtle degradation patterns that operators miss in raw sensor dashboards
4. **Alerts + Notification Integration** — Automated alerting pipeline replaces SNS — failure prediction triggers immediate notification
5. **100 maintenance documents searchable** — Equipment manuals and failure mode guides instantly queryable for corrective actions
6. **Malaysian semiconductor equipment context** — Realistic Applied Materials, ASML, Lam Research tool names and sensor parameters


---

## Demo Prep Checklist

### Data Verification
- [ ] `SELECT COUNT(*) FROM SEMICONDUCTOR_MAINTENANCE.RAW.EQUIPMENT` → 120
- [ ] `SELECT COUNT(*) FROM SEMICONDUCTOR_MAINTENANCE.RAW.TELEMETRY` → 1000000
- [ ] `SELECT COUNT(*) FROM SEMICONDUCTOR_MAINTENANCE.CURATED.EQUIPMENT_HEALTH_SCORE WHERE STATUS = 'ALARM'` → 8

### ML Model Verification
- [ ] `SELECT COUNT(*) FROM SEMICONDUCTOR_MAINTENANCE.ML.RUL_FORECAST_RESULTS` → >0
- [ ] `SELECT COUNT(*) FROM SEMICONDUCTOR_MAINTENANCE.ML.SENSOR_DRIFT_RESULTS WHERE IS_ANOMALY = TRUE` → >=5

### AI/Agent Verification
- [ ] `SELECT COUNT(*) FROM SEMICONDUCTOR_MAINTENANCE.AI.DOC_CLASSIFICATION` → 100

