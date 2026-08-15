-- ============================================================================
-- 03_STAGING.SQL — Generate synthetic data for Equipment Predictive Maintenance
-- Country: MALAYSIA | Currency: MYR
-- ============================================================================
USE DATABASE SEMICONDUCTOR_MAINTENANCE;
USE SCHEMA RAW;

-- Data generation scripts are demo-specific.
-- See the handcrafted SQL in the aws-malaysia-semiconductor-yield demo for
-- the full pattern: GENERATOR + UNIFORM + LATERAL for distribution,
-- Cortex Complete for text generation, engineered key demo numbers.

-- Target row counts:
-- EQUIPMENT: 120 rows — Critical semiconductor manufacturing tools (lithography, etch, CVD, implant)
-- TELEMETRY: 1,000,000 rows — IoT sensor readings — vibration, temperature, pressure, RF power, flow rate
-- WORK_ORDERS: 3,000 rows — Preventive and corrective maintenance work orders
-- SPARE_PARTS: 500 rows — Spare parts inventory with lead times and criticality ratings
-- MAINTENANCE_DOCS: 100 rows — Equipment manuals, failure mode guides, corrective action procedures
-- DOWNTIME_EVENTS: 800 rows — Historical unplanned downtime events with root cause and cost
