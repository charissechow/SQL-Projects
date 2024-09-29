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
SELECT T3.region_name as region_name, max_total_by_region, sales_rep
FROM (SELECT region_name, MAX(total_amt_usd) max_total_by_region
FROM (SELECT s.name sales_rep, r.name region_name, SUM(total_amt_usd) total_amt_usd
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
GROUP BY sales_rep, region_name
ORDER BY SUM(total_amt_usd) DESC) T1
GROUP BY region_name) T2
LEFT JOIN (SELECT s.name sales_rep, r.name region_name, SUM(total_amt_usd) total_amt_usd
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
GROUP BY sales_rep, region_name
ORDER BY SUM(total_amt_usd) DESC) T3
ON T3.region_name = T2.region_name
AND T3.total_amt_usd = T2.max_total_by_region

2. For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?
SELECT r.name, SUM(total_amt_usd) total_sales_by_region, COUNT(o.id) total_orders_by_region
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
GROUP BY r.name
ORDER BY 2 DESC
LIMIT 1

  2357 orders

3. How many accounts had more total purchases than the account name which has bought the most standard_qty paper throughout their lifetime as a customer?
  -- 1 find the account name with the highest amount of standard_qty papers
      once u aggregate that, you also have to aggregate the total purchases for that account. this is the first counter = 56
      
  -- 2 aggregate at an account name level by sum total purchases.
      
  -- 3 use having function and subtract sum total purchases against the 56 number
      
  -- 4 then put this as a sub query and then count the number of account_names

SELECT COUNT(*)
FROM (SELECT a.name account_name, COUNT(a.name)
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY 1
HAVING COUNT(a.name)>(SELECT total_purchases_per_account as min_requirement_of_purchases
FROM (SELECT a.name account_name, SUM(standard_qty) standard_orders, COUNT(o.total) total_purchases_per_account
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY account_name
ORDER BY 2 DESC
LIMIT 1) min_sales)) final_table

  35

4. For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?
SELECT account_name, COUNT(id), channel
FROM (SELECT a.name account_name, channel, w.id
FROM accounts a
JOIN web_events w
ON w.account_id = a.id
WHERE a.name LIKE (SELECT account_name
FROM (
SELECT a.name account_name, SUM(total_amt_usd)total_spent_per_account
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN web_events w
ON w.account_id = a.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1) T1))
GROUP BY 1, 3

5. What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?
SELECT AVG(total_spent_per_account)
FROM (SELECT a.name account_name, SUM(total_amt_usd) total_spent_per_account
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10)

  304,846.969

6. What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent more per order, on average, than the average of all orders.
SELECT AVG(avg_spent_per_account)
FROM(SELECT a.name account_name, AVG(total_amt_usd) avg_spent_per_account
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY 1
HAVING AVG(total_amt_usd)>(SELECT AVG(total_amt_usd) avg_spent_all_orders
FROM orders))

4,721.1397

COMMON TABLE EXPRESSIONS (CTE)
-- when creating mulptiple tables using WITH, add comma after ecery table except last table leading to finall query
-- new table aliased using table_name AS, which is followed by query between parentheses
Example:
WITH table1 AS (
          SELECT *
          FROM web_events),

     table2 AS (
          SELECT *
          FROM accounts)

  *do not need*
SELECT *
FROM table1
JOIN table2
ON table1.account_id = table2.id;

QUIZ (CTEs)

1. Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
WITH table1 AS (
SELECT 
  s.name sales_rep, 
  r.name region_name, 
  SUM(total_amt_usd) AS total_sales
FROM region r
JOIN sales_reps s
  ON s.region_id = r.id
JOIN accounts a
  ON s.id = a.sales_rep_id
JOIN orders o
  ON a.id = o.account_id
GROUP BY 1, 2
),

table2 AS (
SELECT 
  region_name,
  MAX(total_sales) AS max_sales
FROM table1
GROUP BY 1
)

SELECT sales_rep, t1.region_name, max_sales
FROM table1 t1
JOIN table2 t2?
ON t1.region_name = t2.region_name
AND t1.total_sales = t2.max_sales

2. For the region with the largest sales total_amt_usd, how many total orders were placed?
SELECT r.name region_name, SUM(o.total_amt_usd) total_sales_by_region, COUNT(o.total) total_orders_by_region
FROM region r
JOIN sales_reps s
  ON s.region_id = r.id
JOIN accounts a
  ON s.id = a.sales_rep_id
JOIN orders o
  ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC

  2357

3. How many accounts had more total purchases than the account name which has bought the most standard_qty paper throughout their lifetime as a customer?
WITH table1 AS (SELECT a.name account_name, SUM(standard_qty) total_standard_qty, SUM(o.total) total_purchases
FROM accounts a
JOIN orders o
  ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1
),

table2 AS (SELECT total_purchases
FROM table1),

table3 AS (SELECT a.name account_name, SUM(standard_qty) total_standard_qty, SUM(o.total) total_purchases
FROM accounts a
JOIN orders o
  ON a.id = o.account_id
GROUP BY 1),

table4 AS (SELECT *
FROM table3
WHERE total_purchases > (SELECT total_purchases
FROM table1)
)
          
SELECT COUNT(account_name)
FROM table4

  3

4. For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?
/*WITH table1 AS (SELECT a.name account_name, SUM(total_amt_usd) total_sales, channel, COUNT(w.id) web_events
FROM web_events w
JOIN accounts a
  ON w.account_id = a.id
JOIN orders o
  ON a.id = o.account_id
GROUP BY 1, 3
ORDER BY total_sales DESC),

table2 AS (SELECT a.name account_name, SUM(total_amt_usd) total_sales, channel, COUNT(w.id)
FROM web_events w
JOIN accounts a
  ON w.account_id = a.id
JOIN orders o
  ON a.id = o.account_id
GROUP BY 1, 3
ORDER BY total_sales DESC
LIMIT 1
)

SELECT *
FROM table1
WHERE account_name = (
SELECT account_name
FROM table2)*/

WITH table1 AS (
SELECT 
  a.name AS account_name, 
  channel, 
  COUNT(w.id)
FROM web_events w
JOIN accounts a
  ON w.account_id = a.id
GROUP BY 1, 2
),

table2 AS (SELECT 
   a.name AS account_name, 
   SUM(total_amt_usd) AS total_sales
FROM web_events w
JOIN accounts a
  ON w.account_id = a.id
JOIN orders o
ON o.account_id = a.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1)

SELECT t1.account_name, channel, count
FROM table1 t1
JOIN table2 t2
 ON t1.account_name = t2.account_name

5. What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?
WITH table1 AS (SELECT 
   a.name AS account_name,
   SUM(total_amt_usd) total_sales
FROM accounts a
JOIN orders o
  ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10)
  
SELECT AVG(total_sales)
FROM table1

6. What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent more per order, on average, than the average of all orders.
WITH table1 AS (SELECT 
   a.name AS account_name,
   AVG(total_amt_usd) total_sales
FROM accounts a
JOIN orders o
  ON a.id = o.account_id
GROUP BY 1),
  
table2 AS (SELECT AVG(total_sales) avg_all_sales
FROM table1),

table3 AS (SELECT 
   a.name AS account_name,
   total_amt_usd
FROM accounts a
JOIN orders o
  ON a.id = o.account_id
GROUP BY 1, 2
HAVING AVG(total_amt_usd) > (SELECT AVG(total_sales) avg_all_sales
FROM table1))
                             
SELECT AVG (total_amt_usd)
FROM table3
