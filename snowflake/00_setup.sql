-- ============================================================================
-- Equipment Predictive Maintenance
-- Predict semiconductor tool failures 72 hours before they occur — IoT sensors stream to Snowflake, ML.FORECAST identifies degradation patterns, and alerts trigger before costly unplanned downtime.
-- ============================================================================
USE ROLE ACCOUNTADMIN;
CREATE DATABASE IF NOT EXISTS SEMICONDUCTOR_MAINTENANCE;
CREATE WAREHOUSE IF NOT EXISTS SEMI_WH WAREHOUSE_SIZE = 'MEDIUM' AUTO_SUSPEND = 120 AUTO_RESUME = TRUE;
USE DATABASE SEMICONDUCTOR_MAINTENANCE;
CREATE SCHEMA IF NOT EXISTS RAW;
CREATE SCHEMA IF NOT EXISTS CURATED;
CREATE SCHEMA IF NOT EXISTS ML;
CREATE SCHEMA IF NOT EXISTS AI;
CREATE SCHEMA IF NOT EXISTS SEARCH;
CREATE SCHEMA IF NOT EXISTS APP;

USE WAREHOUSE SEMI_WH;
