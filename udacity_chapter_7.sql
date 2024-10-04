Advanced JOINs & Performance Tuning

INNER JOIN:
 --produced results where join is matched in both tables (inner portion of a venn diagram)

LEFT/RIGHT JOIN:
 -- includes matched rows from inner portion of venn diagram + unmatches rows from left (or right) table

FULL OUTER JOIN:
 -- includes unmatched rows from BOTH tables
 -- use case: joining 2 tables on a timestamp
 -- e.g. if 1/1/18 exists in left table but not the right, and 1/2/18 exists in right table but not the left, a left join would drop 1/2/18 and a right join would drop 1/1/18. a full outer join would return unmatched records with null values.

 e.g.
 SELECT *
  FROM accounts a
 FULL JOIN sales_reps s
 ON a.sales_rep_id = s.id
 
* to return unmatched rows only * (outer portions of a venn diagram only)
 -- isolate by adding folliwng line to end of query:
FULL OUTER JOIN
WHERE Table_A.column_name IS NULL OR Table_B.column_name IS NULL

 e.g.
 SELECT *
  FROM accounts a
 FULL JOIN sales_reps s
 ON a.sales_rep_id = s.id
 WHERE a.sales_rep_id IS NULL OR s.id IS NULL

INEQUALITY JOINS - joining without an equals sign
-- join clause is evaluated before the where clause 
-- filtering in the join clause will eliminate rows before they are joined
-- filtering in the WHERE clause will leave those rows in and produce some nulls

e.g. 
1. In the following SQL Explorer, write a query that left joins the accounts table and the sales_reps tables on each sale reps ID number and joins it using the < comparison operator on accounts.primary_poc and sales_reps.name, like so: accounts.primary_poc < sales_reps.name
SELECT a.name AS account_name,
       primary_poc AS poc_name,
       s.name AS sales_rep
FROM accounts a
LEFT JOIN sales_reps s
  ON s.id = a.sales_rep_id
 AND a.primary_poc < s.name

-- meaning: the primary point of contact's full name comes BEFORE the sales representative's name alphabetically


      
 

