WINDOW FUNCTIONS
-- compare rows without joins
-- performs calculation across a set of table rows that are related to the current row
-- comparable to aggregate function, but does not group row i a singe output row
  -- instead, the rows retain their seprte identities
1. e.g. Calculate running total of how much standard paper we have sold up to date.
SELECT
  standard_qty,
  SUM(standard_qty) OVER (ORDER BY occurred_at) AS running_total
FROM demo.order

  -- can be read as "take the sum of standard quantity, across all rows leading up to a given row, in order by occurred at.

PARTITION
2. e.g. Start running total over at beginning of each month
SELECT 
  standard_qty,
  DATE_TRUNC('month', occurred_at) AS month,
  SUM(standard_qty) OVER (PARTITION BY DATE_TRUNC('month', occurred_at) ORDER BY occurred_at) AS running_total
FROM demo.orders
    
-- note: cannot use window functions and standard aggregations in the same query. cannut include window functions in a GROUP BY clause

ROW_NUMBER
-- displays nuber of given  rows within the window you define
-- does not require to specify a vairable within the parentheses
SELECT
  id,
  account_id,
  occurred_at,
  ROW_number() OVER (ORDER BY id) AS ro_num
FROM demo.orders
RANK
-- similar, but with give same rank if 2 lines have the same value

1. Select the id, account_id, and total variable from the orders table, then create a column called total_rank that ranks this total amount of paper ordered (from highest to lowest) for each account using a partition. Your final table should have these four columns.
  
WITH table1 AS (SELECT 
  o.id,
  account_id,
  total,
  SUM(total) OVER (PARTITION BY (a.id)) AS total_orders_by_account,
  ROW_NUMBER() OVER (PARTITION BY account_id) AS row_num
FROM orders o
JOIN accounts a
ON a.id = o.account_id
ORDER BY total_orders_by_account DESC),
                                 
table2 AS (SELECT *
FROM table1
WHERE row_num = 1)

SELECT
id,
account_id,
total,
total_orders_by_account
FROM table2

WREONG LOL

CORRECT:
SELECT id,
       account_id,
       total,
       RANK() OVER (PARTITION BY account_id ORDER BY total DESC) AS total_rank
FROM orders

AGGREGATES WITH WINDOW FUNCTIONS
  
e.g.
SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS count_std_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS max_std_qty
FROM orders

PARTITION & ORDER clauses refers the the "window" -- the ordered subset of data over which calulations are made
-- using "PARTITION BY account_id" AND "ORDER BY month", the aggregation is calculated grouped by account_id AND by month
-- ommitting ORDER BY here makes all the rows in each "account_id" partition "equal" to each other

SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER main_window AS dense_rank,
       SUM(standard_qty) OVER main_window AS sum_std_qty,
       COUNT(standard_qty) OVER main_window AS count_std_qty,
       AVG(standard_qty) OVER main_window AS avg_std_qty,
       MIN(standard_qty) OVER main_window AS min_std_qty,
       MAX(standard_qty) OVER main_window AS max_std_qty
FROM orders
WINDOW account_month_window AS (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at))

LAG & LEAD
LAG: returns the value from a previous row to the current row in the table
LEAD: return the value from the row following the current row in the table
   -- use case: to cmopare values in adjacent rows or rows that ae offset by a certain number
   -- e.g. comparing profits earned by each market segment
   -- e.g. comparing number of days elapsed between each subsequent order placed for Item A

SELECT 
  account_id,
  standard_sum,
  LAG(standard_sum)over (ORDER BY standard_sum) AS lag,
  LEAD(standard_sum) OVER (ORDER BY standard_sum) AS lead,
  standard_sum - LAG(standard_sum) OVER (ORDER BY standard_sum) AS lag_difference,
  LEAD(standard_sum) OVER (ORDER BY standard_sum) - standard_sum AS lead_difference
FROM (
  SELECT 
  account_ud,
  SUM(standard_qty) AS standard_sum
  FROM demo.orders
  GROUP BY 1
  ) sub

QUIZ 
  
1. Determine how the current order's total revenue ("total" meaning from sales of all types of paper) compares to the next order's total revenue.
SELECT occurred_at,
       total_rev_per_order,
       LEAD(total_rev_per_order) OVER (ORDER BY occurred_at) AS lead,
       LEAD(total_rev_per_order) OVER (ORDER BY occurred_at) - total_rev_per_order AS lead_difference
FROM (SELECT occurred_at,
       SUM(total_amt_usd) AS total_rev_per_order
  FROM orders 
 GROUP BY 1) sub

