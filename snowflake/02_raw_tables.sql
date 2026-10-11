-- Synthetic tool-day observations for fictional Malaysian semiconductor fabs;
-- no seeded predictions or invented asset counts.
-- Randomness is HASH-seeded so every rebuild is reproducible yet varied:
-- per-tool reliability/age, 24x7 or reduced-loading schedules, wear between PM
-- visits, missed PM, variable restoration times, class-weighted root causes and
-- site-wide power dips.
USE DATABASE IDENTIFIER($DEMO_DB);
USE SCHEMA RAW;
USE WAREHOUSE IDENTIFIER($DEMO_WH);

CREATE TABLE RAW.TOOLS AS
WITH equipment AS (
  SELECT ROW_NUMBER() OVER (ORDER BY SEQ4()) - 1 AS TOOL_INDEX
  FROM TABLE(GENERATOR(ROWCOUNT => 24))
), draws AS (
  SELECT TOOL_INDEX,
         MOD(ABS(HASH(TOOL_INDEX, 'mysm-site')), 1000000) / 1e6 AS U_REGION,
         MOD(ABS(HASH(TOOL_INDEX, 'mysm-class')), 1000000) / 1e6 AS U_CATEGORY,
         MOD(ABS(HASH(TOOL_INDEX, 'mysm-vintage')), 1000000) / 1e6 AS U_AGE,
         MOD(ABS(HASH(TOOL_INDEX, 'mysm-hazard')), 1000000) / 1e6 AS U_RATE,
         MOD(ABS(HASH(TOOL_INDEX, 'mysm-loading')), 1000000) / 1e6 AS U_SHIFT,
         MOD(ABS(HASH(TOOL_INDEX, 'mysm-pmcycle')), 1000000) / 1e6 AS U_PM,
         MOD(ABS(HASH(TOOL_INDEX, 'mysm-pmrigour')), 1000000) / 1e6 AS U_DISCIPLINE
  FROM equipment
)
SELECT 'TOOL-' || LPAD(TOOL_INDEX::VARCHAR, 4, '0') AS ID,
       'Synthetic fab tool ' || LPAD(TOOL_INDEX::VARCHAR, 4, '0') AS NAME,
       CASE WHEN U_REGION < 0.32 THEN 'Penang' WHEN U_REGION < 0.56 THEN 'Kulim'
            WHEN U_REGION < 0.74 THEN 'Melaka' WHEN U_REGION < 0.89 THEN 'Ipoh' ELSE 'Kuching' END AS REGION,
       CASE WHEN U_CATEGORY < 0.30 THEN 'Plasma Etcher' WHEN U_CATEGORY < 0.55 THEN 'CVD Chamber'
            WHEN U_CATEGORY < 0.80 THEN 'Wire Bonder' ELSE 'Wafer Prober' END AS CATEGORY,
       TOOL_INDEX,
       ROUND(2 + U_AGE * 14, 1) AS AGE_YEARS,
       -- Base daily failure probability 0.4%-3.6%; ~12% of tools are "bad actors" (x3).
       (0.004 + U_RATE * 0.032) * IFF(U_RATE > 0.88, 3, 1) AS BASE_FAILURE_RATE,
       IFF(U_SHIFT < 0.7, 24, 20) AS SHIFT_HOURS,
       10 * (1 + FLOOR(U_PM * 3)) AS PM_INTERVAL_DAYS,
       0.6 + U_DISCIPLINE * 0.38 AS PM_COMPLETION_PROB,
       'Active' AS STATUS
FROM draws;

CREATE TABLE RAW.SENSOR_READINGS AS
WITH days AS (
  SELECT ROW_NUMBER() OVER (ORDER BY SEQ4()) - 1 AS DAY_INDEX
  FROM TABLE(GENERATOR(ROWCOUNT => 90))
), outages AS (
  -- Two site-wide power dips in the window.
  SELECT * FROM VALUES (31, 'Kulim', 3.5), (67, 'Penang', 2.0) AS o(DAY_INDEX, REGION, HOURS)
), base AS (
  SELECT m.ID AS ENTITY_ID, m.TOOL_INDEX, m.CATEGORY, m.REGION, m.AGE_YEARS,
         m.BASE_FAILURE_RATE, m.PM_INTERVAL_DAYS, m.PM_COMPLETION_PROB, d.DAY_INDEX,
         DATEADD('day', d.DAY_INDEX - 89, CURRENT_DATE()) AS EVENT_DATE,
         -- Weekly chamber-clean and qualification window every seventh day of the window.
         IFF(MOD(d.DAY_INDEX, 7) = 6, 18.0, m.SHIFT_HOURS) AS PLANNED_HOURS,
         MOD(d.DAY_INDEX + m.TOOL_INDEX * 7, m.PM_INTERVAL_DAYS) AS DAYS_SINCE_PM,
         MOD(ABS(HASH(m.ID, d.DAY_INDEX, 'mysm-down')), 1000000) / 1e6 AS U_FAIL,
         MOD(ABS(HASH(m.ID, d.DAY_INDEX, 'mysm-restore')), 1000000) / 1e6 + 1e-6 AS U_RESTORE,
         MOD(ABS(HASH(m.ID, d.DAY_INDEX, 'mysm-cause')), 1000000) / 1e6 AS U_CAUSE,
         MOD(ABS(HASH(m.ID, d.DAY_INDEX, 'mysm-pmdone')), 1000000) / 1e6 AS U_PMDONE,
         MOD(ABS(HASH(m.ID, d.DAY_INDEX, 'mysm-wafers')), 1000000) / 1e6 AS U_UNITS,
         MOD(ABS(HASH(m.ID, d.DAY_INDEX, 'mysm-jitter')), 1000000) / 1e6 AS U_NOISE,
         o.HOURS AS OUTAGE_HOURS
  FROM RAW.TOOLS m CROSS JOIN days d
  LEFT JOIN outages o ON o.DAY_INDEX = d.DAY_INDEX AND o.REGION = m.REGION
), pm AS (
  SELECT *,
         IFF(DAYS_SINCE_PM = 0, 1, 0) AS PM_DUE,
         IFF(DAYS_SINCE_PM = 0 AND U_PMDONE < PM_COMPLETION_PROB, 1, 0) AS PM_COMPLETED,
         -- Wear rises between visits; weak PM discipline adds carried-over wear.
         DAYS_SINCE_PM / PM_INTERVAL_DAYS + (1 - PM_COMPLETION_PROB) AS WEAR,
         -- A sustained high facility cooling-load period (days 30-74 of the window) stresses CVD chamber heaters.
         IFF(CATEGORY = 'CVD Chamber' AND DAY_INDEX BETWEEN 30 AND 74, 1.35, 1.0) AS HEAT_FACTOR
  FROM base
), failures AS (
  SELECT *,
         LEAST(0.6, BASE_FAILURE_RATE * (0.35 + 1.7 * WEAR) * (1 + AGE_YEARS / 25) * HEAT_FACTOR) AS P_FAIL
  FROM pm
), events AS (
  SELECT *,
         CASE WHEN OUTAGE_HOURS IS NOT NULL THEN 1
              WHEN U_FAIL < P_FAIL / 5 THEN 2
              WHEN U_FAIL < P_FAIL THEN 1 ELSE 0 END AS FAILURE_COUNT
  FROM failures
), timed AS (
  SELECT *,
         -- Exponential restoration durations; mean depends on tool class.
         CASE WHEN FAILURE_COUNT = 0 THEN 0.0
              WHEN OUTAGE_HOURS IS NOT NULL THEN OUTAGE_HOURS
              ELSE LEAST(PLANNED_HOURS - 0.5, ROUND(FAILURE_COUNT * (0.5 - LN(U_RESTORE) *
                     CASE CATEGORY WHEN 'CVD Chamber' THEN 5.0 WHEN 'Plasma Etcher' THEN 4.0
                                   WHEN 'Wafer Prober' THEN 2.5 ELSE 1.8 END), 1)) END AS DOWNTIME_HOURS
  FROM events
)
SELECT ENTITY_ID || '-' || TO_CHAR(EVENT_DATE, 'YYYYMMDD') AS EVENT_ID,
       ENTITY_ID, EVENT_DATE, PLANNED_HOURS, DOWNTIME_HOURS,
       PLANNED_HOURS - DOWNTIME_HOURS AS OPERATING_HOURS,
       FAILURE_COUNT,
       CASE WHEN FAILURE_COUNT = 0 THEN 'None'
            WHEN OUTAGE_HOURS IS NOT NULL THEN 'Power disturbance'
            WHEN CATEGORY = 'Plasma Etcher' THEN IFF(U_CAUSE < 0.5, 'RF generator fault', IFF(U_CAUSE < 0.8, 'Chamber contamination', 'Sensor fault'))
            WHEN CATEGORY = 'CVD Chamber' THEN IFF(U_CAUSE < 0.45, 'Heater drift', IFF(U_CAUSE < 0.75, 'Gas flow fault', 'Vacuum pump wear'))
            WHEN CATEGORY = 'Wire Bonder' THEN IFF(U_CAUSE < 0.5, 'Capillary wear', IFF(U_CAUSE < 0.8, 'Wire break', 'Alignment'))
            ELSE IFF(U_CAUSE < 0.6, 'Probe card wear', 'Chuck vacuum fault') END AS ROOT_CAUSE,
       PM_DUE, PM_COMPLETED,
       ROUND(OPERATING_HOURS * (9 + U_UNITS * 7)) AS TOTAL_UNITS,
       FLOOR(ROUND(OPERATING_HOURS * (9 + U_UNITS * 7)) *
             LEAST(0.995, GREATEST(0.82, 0.988 - 0.035 * WEAR - 0.03 * FAILURE_COUNT - 0.012 * U_NOISE))) AS GOOD_UNITS,
       100.0 * (PLANNED_HOURS - DOWNTIME_HOURS) / PLANNED_HOURS AS KPI_EQUIPMENT_UPTIME,
       ROUND(1.5 + 3.8 * WEAR + 1.6 * FAILURE_COUNT + U_NOISE * 0.9, 2) AS VIBRATION_MM_S,
       ROUND(48 + 7 * WEAR + IFF(HEAT_FACTOR > 1, 8, 0) + U_NOISE * 3.5, 1) AS TEMPERATURE_C,
       CURRENT_TIMESTAMP() AS LOADED_AT
FROM timed;

CREATE TABLE RAW.SPARE_PARTS AS
SELECT ID AS ENTITY_ID,
       CASE CATEGORY WHEN 'Plasma Etcher' THEN 'RF match unit' WHEN 'CVD Chamber' THEN 'Heater assembly'
                     WHEN 'Wire Bonder' THEN 'Capillary set' ELSE 'Probe card' END AS PART_TYPE,
       1 + MOD(ABS(HASH(ID, 'mysm-need')), 4) AS REQUIRED_QTY,
       MOD(ABS(HASH(ID, 'mysm-stock')), 5) AS ON_HAND_QTY,
       IFF(MOD(ABS(HASH(ID, 'mysm-stock')), 5) < 1 + MOD(ABS(HASH(ID, 'mysm-need')), 4),
           MOD(ABS(HASH(ID, 'mysm-po')), 3), 0) AS ON_ORDER_QTY,
       CURRENT_DATE() AS SNAPSHOT_DATE
FROM RAW.TOOLS;
