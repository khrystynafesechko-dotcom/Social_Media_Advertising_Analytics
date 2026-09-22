-- Generate a synthetic revenue table for Purchase events only.
-- Revenue amount is simulated per ad_type (Video/Carousel/Image/Stories get
-- different price ranges) since no real transaction/revenue table exists.
-- NOTE: revenue_amount is synthetic data for demo purposes, not real revenue.
CREATE OR REPLACE TABLE `payment-analytics-dwh.payment_dwh.cln_revenue` AS
SELECT
  e.event_id,
  e.ad_id,
  e.user_id,
  e.event_date,
  ROUND(
    CASE a.ad_type
      WHEN 'Video'     THEN 30 + RAND() * 170
      WHEN 'Carousel'  THEN 20 + RAND() * 130
      WHEN 'Image'     THEN 15 + RAND() * 100
      WHEN 'Stories'   THEN 10 + RAND() * 80
      ELSE 10 + RAND() * 100
    END, 2
  ) AS revenue_amount
FROM `payment-analytics-dwh.payment_dwh.cln_ad_events` e
JOIN `payment-analytics-dwh.payment_dwh.cln_ads` a USING (ad_id)
WHERE e.event_type = 'Purchase';
