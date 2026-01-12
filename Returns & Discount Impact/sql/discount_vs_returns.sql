USE returns_discount_impact;

-- Main story: are discounted lines returned more?
SELECT
  fs.IsDiscounted,
  ROUND(SUM(fs.IsReturned)/NULLIF(COUNT(*),0), 4) AS return_rate,
  ROUND(SUM(fs.NetRevenue), 2) AS net_revenue,
  COUNT(*) AS line_count
FROM fact_sales fs
GROUP BY fs.IsDiscounted;

-- Return rate by discount band
SELECT
  pr.DiscountBand,
  ROUND(SUM(fs.IsReturned)/NULLIF(COUNT(*),0), 4) AS return_rate,
  ROUND(SUM(fs.NetRevenue), 2) AS net_revenue,
  COUNT(*) AS line_count
FROM fact_sales fs
JOIN dim_promo pr ON pr.PromoID = fs.PromoID
WHERE fs.IsDiscounted = 1
GROUP BY pr.DiscountBand
ORDER BY return_rate DESC;

-- Discount rate buckets directly from fact_sales (extra view of same story)
SELECT
  CASE
    WHEN DiscountRate = 0 THEN '0%'
    WHEN DiscountRate > 0 AND DiscountRate <= 0.05 THEN '0-5%'
    WHEN DiscountRate > 0.05 AND DiscountRate <= 0.10 THEN '5-10%'
    WHEN DiscountRate > 0.10 AND DiscountRate <= 0.20 THEN '10-20%'
    ELSE '20%+'
  END AS discount_bucket,
  ROUND(SUM(IsReturned)/NULLIF(COUNT(*),0), 4) AS return_rate,
  ROUND(SUM(NetRevenue), 2) AS net_revenue,
  COUNT(*) AS lines
FROM fact_sales
GROUP BY discount_bucket
ORDER BY lines DESC;

-- Discount vs returns by channel (very good dashboard visual)
SELECT
  ch.SalesChannel,
  ROUND(SUM(fs.IsDiscounted)/NULLIF(COUNT(*),0), 4) AS discounted_share,
  ROUND(SUM(fs.IsReturned)/NULLIF(COUNT(*),0), 4) AS return_rate,
  ROUND(SUM(fs.NetRevenue), 2) AS net_revenue
FROM fact_sales fs
JOIN dim_channel ch ON ch.ChannelID = fs.ChannelID
GROUP BY ch.SalesChannel
ORDER BY return_rate DESC;