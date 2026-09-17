---Cheking the column names and data types for the ad_events_stg table, ordered by their position in the table.
SELECT column_name, data_type
FROM `payment-analytics-dwh.payment_dwh.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'ad_events_stg'
ORDER BY ordinal_position;

---Checks total rows and unique event_id values to identify potential duplicates.
SELECT
  COUNT(*) AS total_rows,
  COUNT(DISTINCT event_id) AS unique_event_ids
FROM `payment-analytics-dwh.payment_dwh.ad_events_stg`;

---Checks for NULL values across key columns in the staging table.
SELECT
  COUNTIF(event_id IS NULL) AS null_event_id,
  COUNTIF(ad_id IS NULL) AS null_ad_id,
  COUNTIF(user_id IS NULL) AS null_user_id,
  COUNTIF(timestamp IS NULL) AS null_timestamp,
  COUNTIF(day_of_week IS NULL) AS null_day_of_week,
  COUNTIF(time_of_day IS NULL) AS null_time_of_day,
  COUNTIF(event_type IS NULL) AS null_event_type,
  COUNT(*) AS total_rows
FROM `payment-analytics-dwh.payment_dwh.ad_events_stg`;

---Examines the number and types of events.
SELECT event_type, COUNT(*) AS cnt
FROM `payment-analytics-dwh.payment_dwh.ad_events_stg`
GROUP BY event_type
ORDER BY cnt DESC;

---Validates stored day_of_week values against the calculated day from timestamp
SELECT
  day_of_week AS stored_day,
  FORMAT_DATE('%A', DATE(timestamp)) AS calculated_day,
  COUNT(*) AS cnt
FROM `payment-analytics-dwh.payment_dwh.ad_events_stg`
WHERE day_of_week != FORMAT_DATE('%A', DATE(timestamp))
GROUP BY stored_day, calculated_day
ORDER BY cnt DESC;

---Checks for unusually high event volumes per user to identify potential bot activity or abnormal behavior.
SELECT user_id, COUNT(*) AS event_count
FROM `payment-analytics-dwh.payment_dwh.ad_events_stg`
GROUP BY user_id
ORDER BY event_count DESC
LIMIT 20;

---Validates user_id format and calculates the count and percentage of valid and invalid values in the staging table.
SELECT
  CASE
    WHEN REGEXP_CONTAINS(user_id, r'^[0-9a-fA-F]+$') THEN 'valid_format'
    ELSE 'invalid_format'
  END AS format_status,
  COUNT(*) AS cnt,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS pct
FROM `payment-analytics-dwh.payment_dwh.ad_events_stg`
GROUP BY format_status;


---Checks the minimum and maximum event dates and counts the number of distinct months in ad_events_stg.
SELECT
  MIN(DATE(timestamp)) AS min_date,
  MAX(DATE(timestamp)) AS max_date,
  COUNT(DISTINCT EXTRACT(MONTH FROM timestamp)) AS distinct_months
FROM `payment-analytics-dwh.payment_dwh.ad_events_stg`;

---Creates a clean analytical table with validated user_id values and transformed event date fields.
CREATE TABLE `payment-analytics-dwh.payment_dwh.cln_ad_events` AS
SELECT
  event_id, ad_id, user_id,
  timestamp AS event_timestamp,
  DATE(timestamp) AS event_date,
  day_of_week, time_of_day, event_type
FROM `payment-analytics-dwh.payment_dwh.ad_events_stg`
WHERE REGEXP_CONTAINS(user_id, r'^[0-9a-fA-F]+$');

---Checking the table for zero values after cleaning.
SELECT
  COUNTIF(event_id IS NULL) AS null_event_id,
  COUNTIF(ad_id IS NULL) AS null_ad_id,
  COUNTIF(user_id IS NULL) AS null_user_id,
  COUNTIF(event_timestamp IS NULL) AS null_timestamp,
  COUNTIF(event_date IS NULL) AS null_event_date,
  COUNTIF(event_type IS NULL) AS null_event_type
FROM `payment-analytics-dwh.payment_dwh.cln_ad_events`;

---Checking for duplicates in the cleaned table.
SELECT event_id, COUNT(*) AS cnt
FROM `payment-analytics-dwh.payment_dwh.cln_ad_events`
GROUP BY event_id
HAVING cnt > 1
ORDER BY cnt DESC;

---Checking the user_id format.
SELECT COUNT(*) AS invalid_user_id
FROM `payment-analytics-dwh.payment_dwh.cln_ad_events`
WHERE NOT REGEXP_CONTAINS(user_id, r'^[0-9a-fA-F]+$');

---Examines the number and types of events in the cleaned table.
SELECT event_type, COUNT(*) AS cnt
FROM `payment-analytics-dwh.payment_dwh.cln_ad_events`
GROUP BY event_type
ORDER BY cnt DESC;
