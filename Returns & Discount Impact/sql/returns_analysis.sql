USE returns_discount_impact;

-- Return rate by channel
SELECT
  ch.SalesChannel,
  ROUND(SUM(fs.IsReturned)/NULLIF(COUNT(*),0), 4) AS return_rate,
  ROUND(SUM(fs.NetRevenue), 2) AS net_revenue
FROM fact_sales fs
JOIN dim_channel ch ON ch.ChannelID = fs.ChannelID
GROUP BY ch.SalesChannel
ORDER BY return_rate DESC;

-- Return rate by category
SELECT
  dp.Category,
  ROUND(SUM(fs.IsReturned)/NULLIF(COUNT(*),0), 4) AS return_rate,
  COUNT(*) AS lines
FROM fact_sales fs
JOIN dim_product dp ON dp.ProductID = fs.ProductID
GROUP BY dp.Category
ORDER BY return_rate DESC
LIMIT 15;

-- Return reasons (from returns table)
SELECT
  fr.ReturnReason,
  COUNT(*) AS returns_cnt,
  ROUND(SUM(fr.RefundAmount), 2) AS refund_amount
FROM fact_returns fr
GROUP BY fr.ReturnReason
ORDER BY returns_cnt DESC;

-- Return rate by age group
SELECT
  dc.AgeGroup,
  ROUND(SUM(fs.IsReturned)/NULLIF(COUNT(*),0), 4) AS return_rate,
  ROUND(SUM(fs.NetRevenue), 2) AS net_revenue
FROM fact_sales fs
JOIN dim_customer dc ON dc.CustomerID = fs.CustomerID
GROUP BY dc.AgeGroup
ORDER BY return_rate DESC;

-- Return rate by gender
SELECT
  dc.Gender,
  ROUND(SUM(fs.IsReturned)/NULLIF(COUNT(*),0), 4) AS return_rate,
  ROUND(SUM(fs.NetRevenue), 2) AS net_revenue
FROM fact_sales fs
JOIN dim_customer dc ON dc.CustomerID = fs.CustomerID
GROUP BY dc.Gender
ORDER BY return_rate DESC;