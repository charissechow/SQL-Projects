Advanced JOINs & Performance Tuning

INNER JOIN:
 --produced results where join is matched in both tables (inner portion of a venn diagram)

LEFT/RIGHT JOIN:
 -- includes matched rows from inner portion of venn diagram + unmatches rows from left (or right) table

FULL OUTER JOIN:
 -- includes unmatched rows from BOTH tables
 -- use case: joining 2 tables on a timestamp
 -- e.g. if 1/1/18 exists in left table but not the right, and 1/2/18 exists in right table but not the left, a left join would drop 1/2/18 and a right join would drop 1/1/18. a full outer join would return unmatched records with null values.

* to return unmatched rows only * (outer portions of a venn diagram only)
 -- isolate by adding folliwng line to end of query:
FULL OUTER JOIN
WHERE Table_A.column_name IS NULL OR Table_B.column_name IS NULL

