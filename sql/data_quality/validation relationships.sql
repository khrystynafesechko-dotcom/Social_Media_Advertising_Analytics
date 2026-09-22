---Checking whether all keys that will be used to create relationships in Power BI actually match across the tables.
SELECT COUNT(*) AS orphan_ad_id
FROM `payment-analytics-dwh.payment_dwh.cln_ad_events` e
LEFT JOIN `payment-analytics-dwh.payment_dwh.cln_ads` a USING (ad_id)
WHERE a.ad_id IS NULL;

---ads -> campaigns
SELECT COUNT(*) AS orphan_campaign_id
FROM `payment-analytics-dwh.payment_dwh.cln_ads`a
LEFT JOIN `payment-analytics-dwh.payment_dwh.cln_campaigns` c USING (campaign_id)
WHERE c.campaign_id IS NULL;

---
SELECT COUNT(*) AS orphan_event_date
FROM `payment-analytics-dwh.payment_dwh.cln_ad_events` e
LEFT JOIN `payment-analytics-dwh.payment_dwh.cln_calendar_table` cal ON e.event_date = cal.Date
WHERE cal.Date IS NULL;

---ad_events -> calendar
SELECT COUNT(*) AS orphan_user_id
FROM `payment-analytics-dwh.payment_dwh.cln_ad_events` e
LEFT JOIN `payment-analytics-dwh.payment_dwh.cln_users` u USING (user_id)
WHERE u.user_id IS NULL;

--- Referential integrity check: ad_events -> users
--- Confirms every user_id referenced in ad_events exists in the users dimension
--- before loading into Power BI. Returns 0 if all keys match.
SELECT COUNT(DISTINCT e.user_id) AS orphan_users
FROM `payment-analytics-dwh.payment_dwh.cln_ad_events` e
LEFT JOIN `payment-analytics-dwh.payment_dwh.cln_users` u
  USING (user_id)
WHERE u.user_id IS NULL;

--- Add a single 'unknown' placeholder row to cln_users to catch orphan user_id values
SELECT * FROM `payment-analytics-dwh.payment_dwh.cln_users`
UNION ALL
SELECT
  'unknown' AS user_id,
  'Unknown' AS user_gender,
  NULL AS user_age,
  'Unknown' AS age_group,
  'Unknown' AS country,
  'Unknown' AS location,
  'Unknown' AS interests;

--- Rebuild cln_ad_events, mapping any user_id missing from cln_users to 'unknown'
CREATE OR REPLACE TABLE `payment-analytics-dwh.payment_dwh.cln_ad_events` AS
SELECT
  e.event_id,
  e.ad_id,
  CASE WHEN u.user_id IS NULL THEN 'unknown' ELSE e.user_id END AS user_id,
  e.event_timestamp,
  e.event_date,
  e.day_of_week,
  e.event_type
FROM `payment-analytics-dwh.payment_dwh.cln_ad_events` e
LEFT JOIN `payment-analytics-dwh.payment_dwh.cln_users` u
  USING (user_id);

--- Referential integrity check: confirm no orphan user_id remain in ad_events
SELECT COUNT(DISTINCT e.user_id) AS orphan_users
FROM `payment-analytics-dwh.payment_dwh.cln_ad_events` e
LEFT JOIN `payment-analytics-dwh.payment_dwh.cln_users` u
  USING (user_id)
WHERE u.user_id IS NULL;

--- Confirm the 'unknown' placeholder row exists in cln_users (should return exactly 1 row)
SELECT *
FROM `payment-analytics-dwh.payment_dwh.cln_users`
WHERE user_id = 'unknown';

--- Count how many ad_events rows were remapped to the 'unknown' user
SELECT COUNT(*) AS unknown_events_count
FROM `payment-analytics-dwh.payment_dwh.cln_ad_events`
WHERE user_id = 'unknown';

--- Sanity check: total row count in ad_events after rebuild
SELECT COUNT(*) AS total_events FROM `payment-analytics-dwh.payment_dwh.cln_ad_events`;

--- Sanity check: total row count in users after adding the placeholder
SELECT COUNT(*) AS total_users FROM `payment-analytics-dwh.payment_dwh.cln_users`;

--- Confirm the 'unknown' placeholder was not duplicated in cln_users
SELECT COUNT(*) AS unknown_count
FROM `payment-analytics-dwh.payment_dwh.cln_users`
WHERE user_id = 'unknown';

--- Re-check total row count in ad_events (verify no unexpected duplication)
SELECT COUNT(*) AS total_events
FROM `payment-analytics-dwh.payment_dwh.cln_ad_events`;

--- Final confirmation: referential integrity check re-run, expect 0 orphan_users
SELECT COUNT(DISTINCT e.user_id) AS orphan_users
FROM `payment-analytics-dwh.payment_dwh.cln_ad_events` e
LEFT JOIN `payment-analytics-dwh.payment_dwh.cln_users` u
  USING (user_id)
WHERE u.user_id IS NULL;

