-- ============================================================================
-- 07_SEMANTIC_VIEW.SQL — Semantic View for Equipment Predictive Maintenance
-- ============================================================================
USE DATABASE SEMICONDUCTOR_MAINTENANCE;
USE SCHEMA APP;

CREATE OR REPLACE SEMANTIC VIEW APP.MAINTENANCE_ANALYTICS
  COMMENT = 'Equipment health, predictive maintenance, and downtime analytics'
AS
  TABLES (
    CURATED.EQUIPMENT_HEALTH_SCORE AS equipment_health_score,CURATED.SENSOR_DRIFT_DETECTION AS sensor_drift_detection,CURATED.REMAINING_USEFUL_LIFE AS remaining_useful_life,CURATED.MAINTENANCE_BACKLOG AS maintenance_backlog
  );
