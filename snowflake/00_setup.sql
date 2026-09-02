-- Generated from generator/demo_specs/aws-malaysia-semiconductor-maintenance.json
-- Regenerate with: python3 generator/gen_repo_docs.py aws-malaysia-semiconductor-maintenance
-- This is the schema that is actually deployed for MY_SEMICONDUCTOR_MAINTENANCE.

-- MY_SEMICONDUCTOR_MAINTENANCE  (Equipment Predictive Maintenance)
-- generated from generator/demo_specs/aws-malaysia-semiconductor-maintenance.json - do not hand-edit
CREATE DATABASE IF NOT EXISTS MY_SEMICONDUCTOR_MAINTENANCE;
CREATE SCHEMA IF NOT EXISTS MY_SEMICONDUCTOR_MAINTENANCE.RAW;
CREATE SCHEMA IF NOT EXISTS MY_SEMICONDUCTOR_MAINTENANCE.CURATED;
CREATE SCHEMA IF NOT EXISTS MY_SEMICONDUCTOR_MAINTENANCE.APP;
USE DATABASE MY_SEMICONDUCTOR_MAINTENANCE;

-- 5 real regions; entity names carry their region so the two always agree
