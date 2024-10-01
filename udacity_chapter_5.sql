DATA CLEANING (LEFT/RIGHT, POSITION/STRPOS, CONCAT, CAST, COALESCE)

-- used as a field under SELECT to filter out what you want in a new column
1. LEFT (e.g. LEFT(phone_number, 3)
2. RIGHT (e.g. RIGHT(phone_number, 8)
3. LENGTH (phone_number)
  -- provides# of characters for each row of a column
  e.g. RIGHT(phone_number, LENGTH(phone_number)-4) AS phone_number_alt

1. In the accounts table, there is a column holding the website for each company. The last three digits specify what type of web address they are using. A list of extensions (and pricing) is provided here(opens in a new tab). Pull these extensions and provide how many of each website type exist in the accounts table.
SELECT 
  RIGHT(website, 3) AS domain,
  COUNT(*)
FROM accounts
GROUP BY 1

2. There is much debate about how much the name (or even the first letter of a company name)(opens in a new tab) matters. Use the accounts table to pull the first letter of each company name to see the distribution of company names that begin with each letter (or number).
SELECT 
  LEFT(name, 1),
  COUNT(*)
FROM accounts
GROUP BY 1
ORDER BY 1

3. Use the accounts table and a CASE statement to create two groups: one group of company names that start with a number and a second group of those company names that start with a letter. What proportion of company names start with a letter?
SELECT 
  COUNT(num) AS nums, 
  COUNT(letter) AS letters
FROM (SELECT name,
CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') THEN 1 ELSE 0 END AS num,
CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') THEN 0 ELSE 1 END AS letter
FROM accounts
GROUP BY 1)

4. Consider vowels as a, e, i, o, and u. What proportion of company names start with a vowel, and what percent start with anything else?
SELECT name,
CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U') THEN 1 ELSE 0 END AS vowel,
CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U') THEN 0 ELSE 1 END AS constanant
FROM accounts

POSITION
  -- provides position of a string counting from left
  -- (e.g. ',' IN city_state) AS comma_position
STRPOS (String Position)
  --provides position of a string couning from the left
  -- (city_state, ',') AS substr_comma_position

  -- EX. LEFT (city_state, POSITION(',' IN city_state)-1) AS city

LOWER and UPPER -- lowercase or capitalize all characters of a string

1. Use the accounts table to create first and last name columns that hold the first and last names for the primary_poc.
SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') -1 ) first_name, 
   RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name
FROM accounts;

CONCAT
-- combine columns together across rows
-- (e.g. CONCAT(firs_name, ' ', last_name)

1. Each company in the accounts table wants to create an email address for each primary_poc. The email address should be the first name of the primary_poc . last name primary_poc @ company name .com.
WITH table1 AS (SELECT
LEFT(primary_poc, STRPOS(primary_poc, ' ') -1) AS first_name,
RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) AS last_name
FROM accounts)
      
SELECT CONCAT(first_name, '.', last_name, '@company.com')
FROM table1

TO_DATE
  -- DATE_PART(month,'month')) -> changes month name into# associated with that particular month
CAST
  -- turns strings into #s or dates
  -- CAST (date_column AS DATE)

1. Write query to change date (e.g. 01-31-2014) into correct format and cast as a date
WITH table1 AS (SELECT 
date,
LEFT(date, STRPOS(date, ' ')) AS old_date
FROM sf_crime_data 
LIMIT 10),
     
table2 AS (SELECT old_date,
LEFT(old_date, 5) AS day_month,
RIGHT(old_date, LENGTH(old_date) - 6) AS year_space
FROM table1),

table3 AS (SELECT 
LEFT(year_space, 4) AS year
FROM table2),
     
table4 AS (SELECT CONCAT(LEFT(year_space, 4), '/', day_month) AS date_formatted
FROM table2)

SELECT CAST(date_formatted AS DATE)
FROM table4

OR (from date as 01/31/2014)
  
SELECT date orig_date, (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2)) new_date
FROM sf_crime_data;

COALESCE 
-- returns the first non-null value passed for each row
-- COALESCE(primary–poc, 'no POC') AS primary_poc_modified
-- if you COUNT, it will include the new values added in using COALESCE

1. Fill in each of the qty and usd columns with 0 for the table
SELECT COALESCE(o.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) account_id, o.occurred_at, COALESCE(o.standard_qty, 0) standard_qty, COALESCE(o.gloss_qty,0) gloss_qty, COALESCE(o.poster_qty,0) poster_qty, COALESCE(o.total,0) total, COALESCE(o.standard_amt_usd,0) standard_amt_usd, COALESCE(o.gloss_amt_usd,0) gloss_amt_usd, COALESCE(o.poster_amt_usd,0) poster_amt_usd, COALESCE(o.total_amt_usd,0) total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;


