USE returns_discount_impact;

-- Top categories by net revenue
SELECT
  dp.Category,
  ROUND(SUM(fs.NetRevenue), 2) AS net_revenue,
  ROUND(SUM(fs.IsReturned)/NULLIF(COUNT(*),0), 4) AS return_rate,
  ROUND(SUM(fs.IsDiscounted)/NULLIF(COUNT(*),0), 4) AS discounted_share
FROM fact_sales fs
JOIN dim_product dp ON dp.ProductID = fs.ProductID
GROUP BY dp.Category
ORDER BY net_revenue DESC;

-- Category x channel (good matrix visual)
SELECT
  dp.Category,
  ch.SalesChannel,
  ROUND(SUM(fs.NetRevenue), 2) AS net_revenue
FROM fact_sales fs
JOIN dim_product dp ON dp.ProductID = fs.ProductID
JOIN dim_channel ch ON ch.ChannelID = fs.ChannelID
GROUP BY dp.Category, ch.SalesChannel
ORDER BY dp.Category, net_revenue DESC;

-- Worst return categories (to show risk)
SELECT
  dp.Category,
  ROUND(SUM(fs.IsReturned)/NULLIF(COUNT(*),0), 4) AS return_rate,
  COUNT(*) AS line_count
FROM fact_sales fs
JOIN dim_product dp ON dp.ProductID = fs.ProductID
GROUP BY dp.Category
ORDER BY return_rate DESC
LIMIT 10;

-- Profit proxy: NetRevenue minus allocated shipping cost (by channel)
SELECT
  ch.SalesChannel,
  ROUND(SUM(fs.NetRevenue - fs.ShippingCostAllocated), 2) AS net_after_shipping,
  ROUND(SUM(fs.NetRevenue), 2) AS net_revenue,
  ROUND(SUM(fs.ShippingCostAllocated), 2) AS shipping_allocated
FROM fact_sales fs
JOIN dim_channel ch ON ch.ChannelID = fs.ChannelID
GROUP BY ch.SalesChannel
ORDER BY net_after_shipping DESC;