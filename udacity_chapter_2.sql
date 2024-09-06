JOINS
-- orders and accounts are diff types objects
-- normalization -- think about how data is stored & organized
  -- are the tables storing logical groupings of data?
  -- can I  make changes in a single location, rather than in many ables for the same info?
  -- can I access and manipulate data quickly and efficiently?
INNER JOIN (pulls rows that exist across 2 tables)
-- needs a JOIN clause (like a second FROM clause)
- ex. SELECT orders*,
             accounts.*
      FROM demo.orders
      JOIN demo.accounts
      ON orders.account_id = acounts.id
      -- ON clause to specify a JOIN condition to combine the table in FROM & JOIN statements
      -- specifies the column on which you'd like to merge the 2 tables together
-- to choose specific columns, put the table name . column name
- ex. SELECT orders.standard_qty, orders.gloss_qty, 
          orders.poster_qty,  accounts.website, 
          accounts.primary_poc
      FROM orders
      JOIN accounts
      ON orders.account_id = accounts.id
-- PK (primary key): a column where all values are unique (1001, 1002, 1003, etc.)
-- FK (foreign key): linked to a primary key that exists in another table

-- Q: Provide a table for all web_events associated with account name of Walmart. There should be three columns. Be sure to include the primary_poc, time of the event, and the channel for each event. Additionally, you might choose to add a fourth column to assure only Walmart events were chosen.
  - A. SELECT accounts.name, accounts.primary_poc, web_events.channel
      FROM web_events
      JOIN accounts
      ON web_events.account_id = accounts.id 

-- WITH ALIAS:
  - a. SELECT a.primary_poc, w.occurred_at, w.channel, a.name
        FROM web_events w
        JOIN accounts a
        ON w.account_id = a.id
        WHERE a.name = 'Walmart';
  
-- Q. Provide a table that provides the region for each sales_rep along with their associated accounts. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.
  - A. SELECT region.name, sales_reps.name, accounts.name
        FROM sales_reps
        JOIN accounts
        ON sales_reps.id = accounts.sales_rep_id
        JOIN region
        ON sales_reps.region_id = region.id
        ORDER BY accounts.name

-- Q. Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. Your final table should have 3 columns: region name, account name, and unit price. A few accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing by zero.
  - A. SELECT r.name region, a.name account, 
           o.total_amt_usd/(o.total + 0.01) unit_price
        FROM region r
        JOIN sales_reps s
        ON s.region_id = r.id
        JOIN accounts a
        ON a.sales_rep_id = s.id
        JOIN orders o
        ON o.account_id = a.id;

LEFT JOIN / RIGHT JOIN -- pulls rows that might only exist in 1 table -> NULL

QUIZ: LAST CHECK
  
1.
SELECT r.name region, s.name sales_rep, a.name account
FROM accounts a
JOIN sales_reps s 
ON a.sales_rep_id = s.id
JOIN region r
ON s.region_id = r.id
WHERE r.name = 'Midwest'
ORDER BY a.name;

2. 
SELECT r.name region, s.name sales_rep, a.name account
FROM accounts a
JOIN sales_reps s 
ON a.sales_rep_id = s.id
JOIN region r
ON s.region_id = r.id
WHERE r.name = 'Midwest' AND
s.name LIKE 'S%'
ORDER BY a.name;

3.

4. 
SELECT r.name region, a.name account, o.total_amt_usd/(total + 0.01) unit_price
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s 
ON a.sales_rep_id = s.id
JOIN region r
ON s.region_id = r.id
WHERE o.standard_qty > 100

5.

6.
SELECT r.name region, a.name account, o.total_amt_usd/(total + 0.01) unit_price
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s 
ON a.sales_rep_id = s.id
JOIN region r
ON s.region_id = r.id
WHERE standard_qty > 100 AND poster_qty > 50
ORDER BY unit_price DESC

7.
SELECT w.channel, a.name
FROM accounts a
LEFT JOIN web_events w
ON w.account_id = a.id
WHERE a.id = 1001

8.
SELECT a.name, o.occurred_at, o.total, o.total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON o.account_id = a.id
WHERE o.occurred_at BETWEEN '2015-01-01' and '2015-12-31'
ORDER BY o.occurred_at DESC;
