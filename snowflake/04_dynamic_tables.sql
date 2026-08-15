-- ============================================================================
-- 04_DYNAMIC_TABLES.SQL — Curated layer for Equipment Predictive Maintenance
-- ============================================================================
USE DATABASE SEMICONDUCTOR_MAINTENANCE;
USE SCHEMA CURATED;

-- EQUIPMENT_HEALTH_SCORE: Real-time equipment health scoring based on telemetry aggregation
-- Source: EQUIPMENT, TELEMETRY
CREATE OR REPLACE DYNAMIC TABLE CURATED.EQUIPMENT_HEALTH_SCORE
  TARGET_LAG = '5 minutes'
  WAREHOUSE = SEMI_WH
AS
SELECT * FROM RAW.EQUIPMENT;
-- TODO: Replace with actual join/aggregation logic per demo

-- SENSOR_DRIFT_DETECTION: Rolling window sensor drift analysis with spec threshold comparison
-- Source: TELEMETRY
CREATE OR REPLACE DYNAMIC TABLE CURATED.SENSOR_DRIFT_DETECTION
  TARGET_LAG = '5 minutes'
  WAREHOUSE = SEMI_WH
AS
SELECT * FROM RAW.TELEMETRY;
-- TODO: Replace with actual join/aggregation logic per demo

-- REMAINING_USEFUL_LIFE: ML-driven remaining useful life estimation per equipment
-- Source: EQUIPMENT, TELEMETRY, WORK_ORDERS
CREATE OR REPLACE DYNAMIC TABLE CURATED.REMAINING_USEFUL_LIFE
  TARGET_LAG = '5 minutes'
  WAREHOUSE = SEMI_WH
AS
SELECT * FROM RAW.EQUIPMENT;
-- TODO: Replace with actual join/aggregation logic per demo

-- MAINTENANCE_BACKLOG: Overdue and upcoming preventive maintenance scheduling
-- Source: EQUIPMENT, WORK_ORDERS
CREATE OR REPLACE DYNAMIC TABLE CURATED.MAINTENANCE_BACKLOG
  TARGET_LAG = '5 minutes'
  WAREHOUSE = SEMI_WH
AS
SELECT * FROM RAW.EQUIPMENT;
-- TODO: Replace with actual join/aggregation logic per demo

