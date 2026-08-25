-- ============================================================================
-- 10_ALERTS_NOTIFICATIONS.SQL — Alerts for Equipment Predictive Maintenance
-- ============================================================================
USE DATABASE SEMICONDUCTOR_MAINTENANCE;
USE SCHEMA APP;

-- Notification integration (email)
CREATE OR REPLACE NOTIFICATION INTEGRATION aws_malaysia_semiconductor_maintenance_EMAIL_INT
  TYPE = EMAIL
  ENABLED = TRUE
  ALLOWED_RECIPIENTS = ('<YOUR_EMAIL>');

-- Alert: EQUIPMENT_FAILURE_PREDICTED
CREATE OR REPLACE ALERT APP.EQUIPMENT_FAILURE_PREDICTED
  WAREHOUSE = SEMI_WH
  SCHEDULE = '5 MINUTE'
  COMMENT = 'Equipment predicted to fail within 72 hours'
IF (EXISTS (
  SELECT 1 FROM CURATED.EQUIPMENT_HEALTH_SCORE
  WHERE 1=1 -- Condition: PREDICTED_FAILURE_HOURS < 72 for any equipment
))
THEN
  CALL SYSTEM$SEND_EMAIL(
    'aws_malaysia_semiconductor_maintenance_EMAIL_INT',
    '<YOUR_EMAIL>',
    '[ALERT] Equipment Predictive Maintenance: Equipment predicted to fail within 72 hours',
    'Equipment predicted to fail within 72 hours'
  );

ALTER ALERT APP.EQUIPMENT_FAILURE_PREDICTED RESUME;

-- Alert: SENSOR_DRIFT_CRITICAL
CREATE OR REPLACE ALERT APP.SENSOR_DRIFT_CRITICAL
  WAREHOUSE = SEMI_WH
  SCHEDULE = '5 MINUTE'
  COMMENT = 'Sensor reading drifting beyond critical specification'
IF (EXISTS (
  SELECT 1 FROM CURATED.EQUIPMENT_HEALTH_SCORE
  WHERE 1=1 -- Condition: DRIFT_SEVERITY = 'CRITICAL' for any sensor
))
THEN
  CALL SYSTEM$SEND_EMAIL(
    'aws_malaysia_semiconductor_maintenance_EMAIL_INT',
    '<YOUR_EMAIL>',
    '[ALERT] Equipment Predictive Maintenance: Sensor reading drifting beyond critical specification',
    'Sensor reading drifting beyond critical specification'
  );

ALTER ALERT APP.SENSOR_DRIFT_CRITICAL RESUME;

