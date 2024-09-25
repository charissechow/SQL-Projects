SUBQUERES & TEMPORARY TABLES

-- original subquery goes in FROM statement
-- * is used in the SELECT statement to pull all data from original query
-- MUST use alias for table you nest within outer query
  SELECT *
  FROM (SELECT channel, DATE_TRUNC('day', occurred_at), COUNT(*) events
  FROM web_events w
  GROUP BY 1, 2
  ORDER BY 3 DESC) events_per_channel

-- can be used in place of a table name, column name, or an individual value
-- esp. conditional logic within CASE statement: with WHERE, JOIN, WHEN, SELECT
  -- most conditioal logic only works with subqueries containing 1-cell results
  -- except "IN" function works when inner query contains multiple results
  -- DONT include alias b/c it is treated as an individual value (or set of values in IN case) rather than a table






