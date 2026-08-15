-- ============================================================================
-- 11_TASK_PIPELINE.SQL — Task DAG for Equipment Predictive Maintenance
-- ============================================================================
USE DATABASE SEMICONDUCTOR_MAINTENANCE;
USE SCHEMA APP;

CREATE OR REPLACE TASK APP.TASK_RETRAIN_MODELS
  WAREHOUSE = SEMI_WH
  SCHEDULE = 'USING CRON 0 */4 * * * UTC'
  COMMENT = 'Retrain RUL forecast and sensor drift models'
AS
  SELECT 1; -- Replace with actual refresh logic

CREATE OR REPLACE TASK APP.TASK_REFRESH_AI
  WAREHOUSE = SEMI_WH
  AFTER APP.TASK_RETRAIN_MODELS
  COMMENT = 'Refresh failure mode classifications and recommendations'
AS
  SELECT 1; -- Replace with actual refresh logic

CREATE OR REPLACE TASK APP.TASK_CHECK_ALERTS
  WAREHOUSE = SEMI_WH
  AFTER APP.TASK_REFRESH_AI
  COMMENT = 'Evaluate alert conditions and send notifications'
AS
  SELECT 1; -- Replace with actual refresh logic

ALTER TASK APP.TASK_CHECK_ALERTS RESUME;
ALTER TASK APP.TASK_REFRESH_AI RESUME;
ALTER TASK APP.TASK_RETRAIN_MODELS RESUME;
