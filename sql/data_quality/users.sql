---Validation and cleaning of the users_stg.
---Duplicate check for user_id

SELECT user_id, COUNT(*) AS cnt
FROM `payment-analytics-dwh.payment_dwh.users_stg`
GROUP BY user_id
HAVING COUNT(*) > 1
ORDER BY cnt DESC;

---Full duplicate check
SELECT user_id, user_gender, user_age, age_group, country, location, interests,
COUNT(*) AS cnt
FROM  `payment-analytics-dwh.payment_dwh.users_stg`
GROUP BY 1, 2, 3, 4, 5, 6, 7
HAVING COUNT(*) > 1;

---Checking for missing values (NULLs / empty strings).
SELECT
COUNTIF(user_id     IS NULL OR TRIM(user_id)     = '') AS null_user_id,
COUNTIF(user_gender IS NULL OR TRIM(user_gender) = '') AS null_user_gender,
COUNTIF(user_age    IS NULL OR TRIM(CAST(user_age AS STRING)) = '') AS null_user_age,
COUNTIF(age_group   IS NULL OR TRIM(age_group)   = '') AS null_age_group,
COUNTIF(country     IS NULL OR TRIM(country)     = '') AS null_country,
COUNTIF(location    IS NULL OR TRIM(location)    = '') AS null_location,
COUNTIF(interests   IS NULL OR TRIM(interests)   = '') AS null_interests
FROM `payment-analytics-dwh.payment_dwh.users_stg`;

---Checking the number of values that do not match the format [0-9a-zA-Z]
SELECT user_id
FROM `payment-analytics-dwh.payment_dwh.users_stg`
WHERE user_id IS NOT NULL
AND NOT REGEXP_CONTAINS(user_id, r'^[0-9a-zA-Z]+$');

---Checking user_id, user_age limits of valid values ​​from 0-120
SELECT user_id, user_age
FROM `payment-analytics-dwh.payment_dwh.users_stg`
WHERE user_age IS NOT NULL
AND NOT REGEXP_CONTAINS(TRIM(CAST(user_age AS STRING)), r'^[0-9]+$');

---Сhecking for unique country values
SELECT country, COUNT(*) AS cnt
FROM `payment-analytics-dwh.payment_dwh.users_stg`
GROUP BY country
ORDER BY cnt DESC;

CREATE TABLE `payment-analytics-dwh.payment_dwh.cln_users` AS
SELECT *
FROM `payment-analytics-dwh.payment_dwh.users_stg`
WHERE REGEXP_CONTAINS(user_id, r'^[0-9a-zA-Z]+$')
AND REGEXP_CONTAINS(TRIM(CAST(user_age AS STRING)), r'^[0-9]+$')
AND SAFE_CAST(user_age AS INT64) BETWEEN 0 AND 120
AND REGEXP_CONTAINS(TRIM(country), r"^[A-Za-z][A-Za-z\s\.\-']*$");

---Post check cln_users table
SELECT
  COUNT(*) AS total_rows,
  COUNT(*) - COUNT(DISTINCT user_id)                                          AS duplicate_user_ids,
  COUNTIF(user_id IS NULL OR TRIM(user_id) = '')                              AS null_user_id,
  COUNTIF(NOT REGEXP_CONTAINS(user_id, r'^[0-9a-zA-Z]+$'))                    AS invalid_user_id,
  COUNTIF(NOT REGEXP_CONTAINS(TRIM(CAST(user_age AS STRING)), r'^[0-9]+$'))   AS non_numeric_age,
  COUNTIF(SAFE_CAST(user_age AS INT64) NOT BETWEEN 0 AND 120)                 AS age_out_of_range,
  COUNTIF(NOT REGEXP_CONTAINS(TRIM(country), r"^[A-Za-z][A-Za-z\s\.\-']*$"))  AS invalid_country
FROM `payment-analytics-dwh.payment_dwh.cln_users`;

