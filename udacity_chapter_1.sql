-- entity relationship diagrams (ERD) help viz diff spreadsheets/tables & join then together
-- statement - tells database what you want to do w the data, allows to manipulate data
  -- create table - how you make new table / drop table - remove table
  -- select statement - allows to read and display data (AKA query)
      -- think: filling out form to get set of results
SELECT -- indicates which columns you want
    (ex. SELECT id, occurred_at)
    (ex. SELECT *) * = all columns
FROM -- specifies which tables you want to select columns
    (ex. demo.orders)
formatting:
  -- spaces = bad, if no underscores in column names, use parenthesis or brackets "Table Name"/[Table Name]
LIMIT -- see first few rows of a table (faster loading time)
ORDER BY -- allow to sort by date (must go between FROM & LIMIT)
  -- add "DESC" at the end to flip order
WHERE -- displays subsets of data aka filters (goes between FROM & ORDER BY)
  -- ex. WHERE account_id = 
  -- used with comparson operators -- >, <, >=, <=, =, != (not equal to)
    -- can be used with non-numeric data -- must put single quotes (ex. WHERE name = 'United Technologies')
-- Derived Column -- new column that manipulates existing columns (ex. gloss_qty + poster_qty)
  -- AS keyword - alias for the derived column (ex. gloss_qty + poster_qty AS nonstandard_qty)
  -- used with *, +, -, /
LIKE -- allows you to perform operations similar to WHERE and =, but for when you might not know exactly what you are looking for
    -- can used with % % which notate characters (ex. WHERE referrer_url LIKE '%google%')
IN -- allows you to perform operations similar to using WHERE and =, but for more than one condition
    -- used for numeric & text  (ex. WHERE account_id IN (1001, 1002) OR WHERE account_id IN ('Walmart', 'Target')
NOT -- used with IN and LIKE to select all of the rows NOT LIKE or NOT IN a certain condition
    (ex. WHERE sales_rep_d NOT IN (321500, 321570) *dont forget commas*
AND & BETWEEN -- allow you to combine operations where all combined conditions must be true
    -- must specify column you're referring to
    -- ex. must be: WHERE occured_at <='2016-04-01' AND occurred_at <= '2016-10-01' 
        NOT WHERE occured_at <= '2016-04-01' AND <= '2016-10-01'
    -- BETWEEN: can also be written as WHERE occured_at BETWEEN '2016-04-01' AND '2016-10-01'
OR -- allows you to combine operations where at least one of the combined conditions must be true
  ex. standard_qty = 0 OR gloss_qty = 0 OR poster_qty = 0
