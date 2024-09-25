SUBQUERES & TEMPORARY TABLES

-- original subquery goes in FROM statement
-- * is used in the SELECT statement to pull all data from original query
-- MUST use alias for table you nest within outer query
  SELECT *
  FROM (SELECT channel, DATE_TRUNC('day', occurred_at), COUNT(*) events
  FROM web_events w
  GROUP BY 1, 2
  ORDER BY 3 DESC) events_per_channel

