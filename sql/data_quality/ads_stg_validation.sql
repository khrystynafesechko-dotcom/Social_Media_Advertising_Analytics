---Check for NULL values and invalid ID formats in the ads_stg table.
SELECT
  COUNTIF(ad_id IS NULL) AS null_ad_id,
  COUNTIF(campaign_id IS NULL) AS null_campaign_id,
  COUNTIF(SAFE_CAST(ad_id AS INT64) IS NULL) AS bad_ad_id_format,
  COUNTIF(SAFE_CAST(campaign_id AS INT64) IS NULL) AS bad_campaign_id_format
FROM `payment-analytics-dwh.payment_dwh.ads_stg`;

---Checking the table for duplicates.
SELECT ad_id, COUNT(*) AS cnt
FROM `payment-analytics-dwh.payment_dwh.ads_stg`
GROUP BY ad_id
HAVING cnt > 1;

---Checking for missing values (NULLs / empty strings).
SELECT
  COUNTIF(ad_id IS NULL) AS null_ad_id,
  COUNTIF(campaign_id IS NULL) AS null_campaign_id,
  COUNTIF(TRIM(ad_platform) = '' OR ad_platform IS NULL) AS null_platform,
  COUNTIF(TRIM(ad_type) = '' OR ad_type IS NULL) AS null_type,
  COUNTIF(TRIM(target_gender) = '' OR target_gender IS NULL) AS null_gender,
  COUNTIF(TRIM(target_age_group) = '' OR target_age_group IS NULL) AS null_age_group,
  COUNTIF(TRIM(target_interests) = '' OR target_interests IS NULL) AS null_interests
FROM `payment-analytics-dwh.payment_dwh.ads_stg`;

---Validation of allowed values (domain validation).
SELECT DISTINCT ad_platform FROM `payment-analytics-dwh.payment_dwh.ads_stg`;
SELECT DISTINCT ad_type FROM `payment-analytics-dwh.payment_dwh.ads_stg`;
SELECT DISTINCT target_gender FROM `payment-analytics-dwh.payment_dwh.ads_stg`;
SELECT DISTINCT target_age_group FROM `payment-analytics-dwh.payment_dwh.ads_stg`;

---Text format and cleanliness check.
SELECT ad_id, target_interests
FROM `payment-analytics-dwh.payment_dwh.ads_stg`
WHERE target_interests LIKE '%,,%'     
   OR target_interests LIKE ', %'       
   OR REGEXP_CONTAINS(target_interests, r'\s{2,}'); 

---Creates a clean analytical table cln_ads
CREATE TABLE `payment-analytics-dwh.payment_dwh.cln_ads` AS
SELECT *
FROM `payment-analytics-dwh.payment_dwh.ads_stg`;
