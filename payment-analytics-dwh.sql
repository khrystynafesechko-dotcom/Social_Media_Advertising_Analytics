------This query retrieves the column names and data types for the ad_events_stg table, ordered by their position in the table.
SELECT column_name, data_type
FROM `payment-analytics-dwh.payment_dwh.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'ad_events_stg'
ORDER BY ordinal_position;

---Checks total rows and unique event_id values to identify potential duplicates.
SELECT
  COUNT(*) AS total_rows,
  COUNT(DISTINCT event_id) AS unique_event_ids
FROM `payment-analytics-dwh.payment_dwh.ad_events_stg`;

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

---Validates the user_id format and calculates the count and percentage of valid and invalid values.
SELECT
  CASE
    WHEN REGEXP_CONTAINS(user_id, r'^[0-9a-fA-F]+$') THEN 'valid_format'
    ELSE 'invalid_format'
  END AS format_status,
  COUNT(*) AS cnt,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS pct
FROM `payment-analytics-dwh.payment_dwh.users_stg`
GROUP BY format_status;
