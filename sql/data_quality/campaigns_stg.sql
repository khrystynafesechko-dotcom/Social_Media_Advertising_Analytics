---Checking for missing values (NULLs / empty strings).
SELECT
  COUNTIF(campaign_id IS NULL) AS null_campaign_id,
  COUNTIF(name IS NULL) AS null_name,
  COUNTIF(start_date IS NULL) AS null_start_date,
  COUNTIF(end_date IS NULL) AS null_end_date,
  COUNTIF(duration_days IS NULL) AS null_duration,
  COUNTIF(total_budget IS NULL) AS null_budget
FROM `payment_dwh.campaigns_stg`;

---Duplicate check for campaign_id
SELECT campaign_id, COUNT(*) AS cnt
FROM `payment_dwh.campaigns_stg`
GROUP BY campaign_id
HAVING cnt > 1;

---Date Logical Consistency Check
SELECT campaign_id, start_date, end_date
FROM `payment_dwh.campaigns_stg`
WHERE end_date < start_date;

---Checked that duration_days matches the difference between start_date and end_date.
SELECT
  campaign_id,
  start_date,
  end_date,
  duration_days,
  DATE_DIFF(end_date, start_date, DAY) AS calc_duration
FROM `payment_dwh.campaigns_stg`
WHERE duration_days != DATE_DIFF(end_date, start_date, DAY);

---Budget Accuracy Check
SELECT campaign_id, total_budget
FROM `payment_dwh.campaigns_stg`
WHERE total_budget <= 0;

---Creates a clean analytical table cln_campaigns
CREATE TABLE `payment-analytics-dwh.payment_dwh.cln_campaigns` AS
SELECT *
FROM `payment-analytics-dwh.payment_dwh.campaigns_stg`;
