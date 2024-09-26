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

1. Here is the necessary quiz to pull the first month/year combo from the orders table.
SELECT DATE_TRUNC('month', MIN(occurred_at)) 
FROM orders;

2.Use result to find only orders that took place in the same month and year as the first order, and pull the average for each type of paper qty in this month
SELECT AVG(standard_qty)stan_qty, AVG(gloss_qty) gloss_qty, AVG(poster_qty) poster_qty
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = (SELECT DATE_TRUNC('month', MIN(occurred_at))
      FROM orders)
  -- don't forget alias after each field (aka stan_qty) because it will all populate the same average for all columns

QUIZ (SUBQUERIES)

1. Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
SELECT s.name sales_rep, r.name region_name, MAX(total_amt_usd)
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
GROUP BY sales_rep, region_name
ORDER BY MAX(total_amt_usd) DESC
LIMIT 1

  Dawna Agnew

2. For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?
SELECT s.name sales_rep, r.name region_name, o.total total_orders, SUM(total_amt_usd)
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
GROUP BY sales_rep, region_name, total_orders
ORDER BY MAX(total_amt_usd) DESC
LIMIT 1

  28799 orders

3. How many accounts had more total purchases than the account name which has bought the most standard_qty paper throughout their lifetime as a customer?


4. For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?


5. What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?


6. What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent more per order, on average, than the average of all orders.



