-- ============================================================================
-- 08_AGENT.SQL — Cortex Agent for Equipment Predictive Maintenance
-- ============================================================================
USE DATABASE SEMICONDUCTOR_MAINTENANCE;
USE SCHEMA APP;

CREATE OR REPLACE CORTEX AGENT APP.MAINTENANCE_INTELLIGENCE_AGENT
  COMMENT = 'Equipment Predictive Maintenance AI Assistant'
  MODEL = 'claude-opus-4-8'
  TOOLS = (
    SEMANTIC_VIEW_TOOL(SEMANTIC_VIEW => 'SEMICONDUCTOR_MAINTENANCE.APP.MAINTENANCE_ANALYTICS'),    CORTEX_SEARCH_TOOL(CORTEX_SEARCH_SERVICE => 'SEMICONDUCTOR_MAINTENANCE.SEARCH.MAINTENANCE_DOCS_SEARCH', TOOL_DESCRIPTION => 'Search documents for Semiconductor & Electronics Manufacturing information')
  )
  SYSTEM_PROMPT = 'You are the Maintenance Intelligence Agent for 120 critical semiconductor manufacturing tools across the Penang/Kulim corridor in Malaysia.';
