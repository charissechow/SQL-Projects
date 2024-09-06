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










