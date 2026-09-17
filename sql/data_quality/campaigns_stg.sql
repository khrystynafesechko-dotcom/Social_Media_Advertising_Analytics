
---Checking for missing values (NULLs / empty strings).
SELECT
  COUNTIF(campaign_id IS NULL) AS null_campaign_id,
  COUNTIF(name IS NULL) AS null_name,
  COUNTIF(start_date IS NULL) AS null_start_date,
  COUNTIF(end_date IS NULL) AS null_end_date,
  COUNTIF(duration_days IS NULL) AS null_duration,
  COUNTIF(total_budget IS NULL) AS null_budget
FROM `payment_dwh.campaigns_stg`;
