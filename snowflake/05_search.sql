-- ============================================================================
-- 05_SEARCH.SQL — Cortex Search for Equipment Predictive Maintenance
-- ============================================================================
USE DATABASE SEMICONDUCTOR_MAINTENANCE;
USE SCHEMA SEARCH;

CREATE OR REPLACE CORTEX SEARCH SERVICE SEARCH.MAINTENANCE_DOCS_SEARCH
  ON CONTENT
  ATTRIBUTES DOC_TYPE, EQUIPMENT_TYPE, FAILURE_MODE
  WAREHOUSE = SEMI_WH
  TARGET_LAG = '1 hour'
AS (
  SELECT * FROM RAW.MAINTENANCE_DOCS
);
