AGGREGATION

-- aggregators aggregate vertically (columns), whereas to calculate across rows you use simple arithmetic
  
-- NULL = blank; ex. if a POC was accidently deleted or left the company
  -- syntax: IS NULL or IS NOT NULL; do not use = NULL b/c NULL is not a value

COUNT -- to count # of rows in a table, can be use for non-numerical columns
ex. SELECT COUNT(*)
    FROM accounts;
or SELECT COUNT(accounts.id)
    FROM accounts;
  -- can be used to identify if rows have NULL values (missing data)
ex. WHERE primary_poc IS NULL

SUM -- will treat NULLs as O
ex. 
SELECT SUM (standard_qty) 
       SUM (gloss_sty)
       SUM (poster _qty) 
FROM demo.orders

QUIZ (SUMS)
1.
SELECT SUM(poster_qty)
FROM orders;

3.
SELECT SUM(total_amt_usd)
FROM orders;

4.
(WRONG) SELECT SUM (standard_amt_usd), SUM (gloss_amt_usd) 
        FROM orders
(CORRECT) SELECT standard_amt_usd + gloss_amt_usd AS total_standard_gloss
          FROM orders;
-- because it gives dollar amt for each order in a table

5.
SELECT SUM(standard_amt_usd)/SUM(standard_qty) AS standard_price_per_unit
FROM orders;
-- price varies from one order to the next, use ratio cross all sales made

MIN & MAX -- ignore NULlS (treat as 0s), can be used on non-numerical columns
-- can return lowest number, earliest date, or non-numerical value by alphabet (closest to A)
SELECT MIN (standard_qty), MIN (gloss_qty), MAX (standard_qty), MAX (gloss_qty)
FROM demo. orders

AVG -- what we would see on a regular basis
-- compare max to see if its an outliar
-- ONLY NUMERICAL, ignores NULLs -> no 0s in nominator or denominator
  -- if want to count NULLs as 0s, need to use SUM and COUNT

QUIZ (MIN,MAX,AVG)
1.
SELECT MIN(occurred_at)
FROM orders

2. 
SELECT occurred_at
FROM orders
ORDER BY occurred_at
LIMIT 1

3. 
SELECT MAX(occurred_at)
FROM web_events

4.
SELECT occurred_at
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1

5.
SELECT AVG(standard_qty) standard_qty_avg, AVG(gloss_qty) gloss_qty_avg, AVG(poster_qty) poster_qty_avg,
       AVG(standard_amt_usd) standard_amt_spent, AVG(gloss_amt_usd) gloss_amt_spent, AVG(poster_amt_usd) poster_amt_spent
FROM orders;

GROUP BY
-- aggregate data within subsets of data (like SORT in spreadsheet software)
-- any column in SELECT statement that is not within an affregator must be in GROUP BY clause
  -- ex. group for idff accounts, regions, or sales reps
-- goes in between "WHERE" and "ORDER"

QUIZ (GROUP BY)
  
1. Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.
SELECT a.name, o.occurred_at
FROM accounts a
JOIN orders o
ON a.id = o.account_id
ORDER BY occurred_at
LIMIT 1;

2. Find the total sales in usd for each account. You should include two columns - the total sales for each companys orders in usd and the company name.
SELECT a.name, SUM (o.total_amt_usd) total_sales
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name;
  
3. Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event? Your query should return only three values - the date, channel, and account name.
SELECT a.name, w.occurred_at, w.channel
FROM accounts a
JOIN web_events w
ON w.account_id = a.id
ORDER BY w.occurred at DESC
LIMIT 1;
    
4. Find the total number of times each type of channel from the web_events was used. Your final table should have two columns - the channel and the number of times the channel was used.
SELECT w.channel, COUNT(w.channel)
FROM web_events w
GROUP BY w. channel
  *OR*
  SELECT w.channel, COUNT(*)
  FROM web_events w
  GROUP BY w.channel
  
5. Who was the primary contact associated with the earliest web_event?
SELECT a.primary_poc
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
ORDER BY w.occurred_at
LIMIT 1;
  
6. What was the smallest order placed by each account in terms of total usd. Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.
SELECT a.name, MIN(o.total_amt_usd) smallest_order
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY a.name, o.total_amt_usd
ORDER BY o.total_amt_usd
  *OR*
  SELECT a.name, MIN(total_amt_usd) smallest_order
  FROM accounts a
  JOIN orders o
  ON a.id = o.account_id
  GROUP BY a.name
  ORDER BY smallest_order;

7. Find the number of sales reps in each region. Your final table should have two columns - the region and the number of sales_reps. Order from fewest reps to most reps.
SELECT COUNT(s.region_id), r.name
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
GROUP BY s.region_id, r.name
ORDER BY COUNT(s.region_id)
  *OR*
  SELECT r.name, COUNT(*) num_reps
  FROM region r
  JOIN sales_reps s
  ON r.id = s.region_id
  GROUP BY r.name
  ORDER BY num_reps;

takeaways: 
-- only need GROUP BY for fields that are not in an aggregate
-- don't forget to name using ALIASes
-- you can use ALIASes with ORDER BY -- so instead of 'ORDER BY COUNT(region_id)' use 'ORDER BY num_reps'

GROUP BY PART II (GROUPING BY MULTIPLE COLLUMNS)
-- with ORDER BY, substitute numbers for column names in GROUP BY clause. only when grouping a lot of columns or if text is excessively long
-- all coluns not in aggregation must be in GROUP BY statement

QUIZ (GROUP BY OT II)

1. For each account, determine the average amount of each type of paper they purchased across their orders. Your result should have four columns - one for the account name and one for the average quantity purchased for each of the paper types for each account.
SELECT a.name, AVG(standard_qty) mean_standard, AVG(gloss_qty) _mean_gloss, AVG(poster_qty) mean_poster
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY a.name;

2. For each account, determine the average amount spent per order on each paper type. Your result should have four columns - one for the account name and one for the average amount spent on each paper type.
SELECT a.name, AVG(standard_amt_usd) mean_standard, AVG(gloss_amt_usd) _mean_gloss, AVG(poster_amt_usd) mean_poster
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY a.name;

3. Determine the number of times a particular channel was used in the web_events table for each sales rep. Your final table should have three columns - the name of the sales rep, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.
SELECT s.name, w.channel, COUNT(channel) count_channel
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN web_events w
ON w.account_id = a.id
GROUP BY s.name, w.channel
ORDER BY count_channel DESC;

4. Determine the number of times a particular channel was used in the web_events table for each region. Your final table should have three columns - the region name, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.
SELECT w.channel, r.name, COUNT(channel) channel_count
FROM accounts a
JOIN web_events w
ON w.account_id = a.id
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON s.region_id = r.id
GROUP BY w.channel, r.name;
ORDER BY channel_count DESC;

DISTINCT 
-- used to retreive unique values from a specified/set of columns

1. Use DISTINCT to test if there are any accounts associated with more than one region.
SELECT a.id as "account id", r.id as "region id"
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id;

SELECT DISTINCT id, name
FROM accounts
  YIELDS 351 ROWS
  
  ANSWER: NO
  
2. Have any sales reps worked on more than one account?
SELECT s.id sales_id, a.id accounts_id
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
  YIELDS 351 ROWS

SELECT DISTINCT id
FROM sales_reps
  YIELDS 50 ROWS

  ANSWER: YES

HAVING 
-- used to filter a query that has been aggregated (like WHERE clause)
-- WHERE is used before GROUP BY/ORDER BY
-- HAVING is used after GROUP BY and before ORDER BY

1. How many of the sales reps have more than 5 accounts that they manage?
SELECT s.id, s.name, COUNT(a.id) num_accounts
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
HAVING COUNT(a.id) > 5

2. How many accounts have more than 20 orders?
SELECT a.name, COUNT(o.total) num_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
HAVING COUNT(o.total) > 20
ORDER BY num_orders

3. Which account has the most orders?
SELECT a.name, COUNT(o.total) num_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY num_orders DESC
LIMIT 1

4. Which accounts spent more than 30,000 usd total across all orders?
SELECT a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
HAVING SUM(total_amt_usd) > 30000
ORDER BY total_spent

5. Which accounts spent less than 1,000 usd total across all orders?
SELECT a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
HAVING SUM(total_amt_usd) <1000
ORDER BY total_spent

6. Which account has spent the most with us?
SELECT a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY total_spent DESC
LIMIT 1

7. Which account has spent the least with us?
SELECT a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY total_spent
LIMIT 1

8. Which accounts used facebook as a channel to contact customers more than 6 times?


9. Which account used facebook most as a channel?


10. Which channel was most frequently used by most accounts?


