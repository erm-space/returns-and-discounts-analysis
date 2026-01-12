USE returns_discount_impact;

-- Revenue by country
SELECT
  dc.Country,
  ROUND(SUM(fs.NetRevenue), 2) AS net_revenue,
  COUNT(DISTINCT fs.OrderID) AS orders,
  ROUND(SUM(fs.IsReturned)/NULLIF(COUNT(*),0), 4) AS return_rate
FROM fact_sales fs
JOIN dim_customer dc ON dc.CustomerID = fs.CustomerID
GROUP BY dc.Country
ORDER BY net_revenue DESC;

-- Age group by channel (who buys where)
SELECT
  dc.AgeGroup,
  ch.SalesChannel,
  ROUND(SUM(fs.NetRevenue), 2) AS net_revenue,
  COUNT(DISTINCT fs.OrderID) AS orders
FROM fact_sales fs
JOIN dim_customer dc ON dc.CustomerID = fs.CustomerID
JOIN dim_channel ch ON ch.ChannelID = fs.ChannelID
GROUP BY dc.AgeGroup, ch.SalesChannel
ORDER BY net_revenue DESC;

-- Gender and discount usage
SELECT
  dc.Gender,
  ROUND(SUM(fs.IsDiscounted)/NULLIF(COUNT(*),0), 4) AS discounted_share,
  ROUND(SUM(fs.NetRevenue), 2) AS net_revenue
FROM fact_sales fs
JOIN dim_customer dc ON dc.CustomerID = fs.CustomerID
GROUP BY dc.Gender
ORDER BY discounted_share DESC;

-- Top cities (only show big cities by orders)
SELECT
  dc.City,
  COUNT(DISTINCT fs.OrderID) AS orders,
  ROUND(SUM(fs.NetRevenue), 2) AS net_revenue
FROM fact_sales fs
JOIN dim_customer dc ON dc.CustomerID = fs.CustomerID
GROUP BY dc.City
HAVING orders >= 100
ORDER BY net_revenue DESC
LIMIT 20;