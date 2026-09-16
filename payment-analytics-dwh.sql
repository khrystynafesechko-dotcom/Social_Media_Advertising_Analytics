---This query retrieves the column names and data types for the ad_events_stg table, ordered by their position in the table.
SELECT column_name, data_type
FROM `payment-analytics-dwh.payment_dwh.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'ad_events_stg'
ORDER BY ordinal_position;

---Checks the minimum and maximum event dates and counts the number of distinct months in ad_events_stg.
SELECT
  MIN(DATE(timestamp)) AS min_date,
  MAX(DATE(timestamp)) AS max_date,
  COUNT(DISTINCT EXTRACT(MONTH FROM timestamp)) AS distinct_months
FROM `payment-analytics-dwh.payment_dwh.ad_events_stg`;
