DATA CLEANING

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


4. Consider vowels as a, e, i, o, and u. What proportion of company names start with a vowel, and what percent start with anything else?

