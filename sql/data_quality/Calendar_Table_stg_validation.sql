---Checking for missing values (NULLs / empty strings).
SELECT
  COUNTIF(Date IS NULL) AS null_date,
  COUNTIF('Day Name' IS NULL) AS null_day_name,
  COUNTIF('Day Number' IS NULL) AS null_day_number,
  COUNTIF('Month' IS NULL) AS null_month,
  COUNTIF('Month Number' IS NULL) AS null_month_number,
  COUNTIF('Week Day' IS NULL) AS null_week_day,
  COUNTIF('Year' IS NULL) AS null_year,
  COUNTIF('Quarter' IS NULL) AS null_quarter
FROM `payment-analytics-dwh.payment_dwh.Calendar_Table_stg`;

---Duplicate check for Date
SELECT Date, COUNT(*) AS cnt
FROM `payment-analytics-dwh.payment_dwh.Calendar_Table_stg`
GROUP BY Date
HAVING cnt > 1;

