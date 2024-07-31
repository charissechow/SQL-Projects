JOINS
-- orders and accounts are diff types objects
-- normalization -- think about how data is stored & organized
  -- are the tables storing logical groupings of data?
  -- can I  make changes in a single location, rather than in many ables for the same info?
  -- can I access and manipulate data quickly and efficiently?
INNER JOIN
-- needs a JOIN clause (like a second FROM clause)
- ex. SELECT orders*,
             accounts.*
      FROM demo.orders
      JOIN demo.accounts
      ON orders.account_id = acounts.id
      -- ON clause to specify a JOIN condition to combine the table in FROM & JOIN statements
      -- specifies the column on which you'd like to merge the 2 tables together
