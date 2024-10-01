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

  
