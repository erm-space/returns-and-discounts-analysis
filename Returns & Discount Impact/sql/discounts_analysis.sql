USE returns_discount_impact;

-- Discount band performance (volume + revenue)
SELECT
  pr.DiscountBand,
  ROUND(SUM(fs.NetRevenue), 2) AS net_revenue,
  ROUND(SUM(fs.DiscountAmount), 2) AS total_discount_amount,
  ROUND(AVG(fs.DiscountRate), 4) AS avg_discount_rate,
  COUNT(*) AS lines
FROM fact_sales fs
JOIN dim_promo pr ON pr.PromoID = fs.PromoID
WHERE fs.IsDiscounted = 1
GROUP BY pr.DiscountBand
ORDER BY net_revenue DESC;

-- Discounted vs not discounted KPIs
SELECT
  fs.IsDiscounted,
  ROUND(SUM(fs.NetRevenue), 2) AS net_revenue,
  COUNT(DISTINCT fs.OrderID) AS orders,
  ROUND(SUM(fs.NetRevenue)/NULLIF(COUNT(DISTINCT fs.OrderID),0),2) AS aov_net
FROM fact_sales fs
GROUP BY fs.IsDiscounted;

-- Where discounts are used most (channel)
SELECT
  ch.SalesChannel,
  ROUND(SUM(fs.IsDiscounted)/NULLIF(COUNT(*),0), 4) AS discounted_share,
  ROUND(SUM(fs.NetRevenue), 2) AS net_revenue
FROM fact_sales fs
JOIN dim_channel ch ON ch.ChannelID = fs.ChannelID
GROUP BY ch.SalesChannel
ORDER BY discounted_share DESC;

-- Which categories are most discounted
SELECT
  dp.Category,
  ROUND(SUM(fs.IsDiscounted)/NULLIF(COUNT(*),0), 4) AS discounted_share,
  ROUND(SUM(fs.DiscountAmount), 2) AS total_discount_amount,
  ROUND(SUM(fs.NetRevenue), 2) AS net_revenue
FROM fact_sales fs
JOIN dim_product dp ON dp.ProductID = fs.ProductID
GROUP BY dp.Category
ORDER BY total_discount_amount DESC
LIMIT 15;
