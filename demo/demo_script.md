# Predictive Maintenance for Semiconductor Fab Tools

**Malaysia - Semiconductor Manufacturing**
Use case: Predictive maintenance for fab tools

> Predictive maintenance for 24 synthetic fab tools at five fictional Malaysian sites (Penang, Kulim, Melaka, Ipoh, Kuching). Dynamic tables, a holdout-evaluated down-risk classifier, a downtime forecast, vibration anomaly detection and grounded AI answers.

## Why Snowflake

- **Dynamic tables** reconcile tool availability KPIs from RAW tool-day rows, with checks in `run_core.py`
- **Down-risk classification** gives a holdout-evaluated next-7-day probability of an unscheduled down per tool
- **Downtime forecast** projects 14 days of fab-wide downtime with prediction intervals
- **Grounded AI**: the Cortex Agent (Analyst over a semantic view, plus Search over fab tool SOPs) shows its SQL and SOP citations. The memo is written by Cortex AI_COMPLETE (Snowflake-only build) or Amazon Bedrock (AWS build)
- **Live ingestion**: `APP.SIMULATE_TELEMETRY` or AWS IoT Core to S3 to Snowpipe, then an alert and email

## What is built

| | |
|---|---|
| Dimension table | `RAW.TOOLS` (24 rows) |
| Fact table | `RAW.SENSOR_READINGS` (2,160 tool-days, 90 days) |
| Curated layer | `CURATED.KPI_SUMMARY`, `PERFORMANCE_SUMMARY`, `DOWNTIME_CAUSES`, `TREND_ANALYSIS` |
| ML | `ML.FAILURE_RISK_SCORES`, `ML.FAILURE_RISK_HOLDOUT_METRICS`, `ML.DOWNTIME_FORECAST`, `ML.VIBRATION_ANOMALIES` |

Sites: Penang, Kulim, Melaka, Ipoh, Kuching (the fab operator is fictional).
Tool classes: Plasma Etcher, CVD Chamber, Wire Bonder, Wafer Prober.

## KPI cards (live from `CURATED.KPI_SUMMARY`; no fallback values)

| Card | Value in a fresh build |
|---|---|
| Tool Availability | 98.4% |
| Unscheduled Downs | 201 |
| Mean Time Between Downs | 225.6 hrs |
| Fab Tools Tracked | 24 |
| Critical Spares on Order | 11 |
| Critical Spare Coverage | 56.4% |

Values are synthetic. A rebuild reproduces them because the data is HASH-seeded.

## Demo flow

1. Executive Cockpit (Nurul Aisyah Rahman, VP Fab Operations): availability KPIs, daily availability and downtime by root cause
2. Predictive (Tan Wei Jie, Equipment Engineer): holdout metrics, risk bands, 14-day downtime forecast, vibration anomalies
3. PM Planning: critical spares, PM compliance vs yield, then Generate a memo from Snowflake tables only
4. Live IoT: run `CALL APP.SIMULATE_TELEMETRY(20)` (or, in the AWS build, `python aws/publish_telemetry.py --count 20`; messages appear about 20-60 s later). Then run `EXECUTE ALERT APP.LIVE_ALARM_ALERT` and show the alert log and email.
5. Ask AI: the Cortex Agent answers metric questions through the semantic view and cites SOPs from Cortex Search. The SQL is shown.
6. QuickSight (AWS build only): the same Snowflake tables through DIRECT_QUERY; risk and IoT visuals
7. Architecture: both diagrams, the current build first

## Talking points

- Availability ranges from 93.42% to 100% by tool. TOOL-0010 (a Kulim plasma etcher) and TOOL-0013 (a Penang CVD chamber) lose the most hours.
- Plasma etchers and CVD chambers account for most unscheduled downs; RF generator faults and heater drift are the top causes by hours.
- The risk model is evaluated on a time-based holdout: precision 0.51 and recall 0.52 at 0.5, against a 0.29 base rate. Present it as triage, not a guarantee.
- Site-wide power dips are excluded from failure labels.

## Business impact

Use only the sourced references in the README's Business Impact section.
