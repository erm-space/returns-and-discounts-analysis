USE returns_discount_impact;

-- Monthly net revenue trend
SELECT
  dd.Year,
  dd.Month,
  dd.MonthName,
  ROUND(SUM(fs.NetRevenue), 2) AS net_revenue
FROM fact_sales fs
JOIN dim_date dd ON dd.DateKey = fs.DateKey
GROUP BY dd.Year, dd.Month, dd.MonthName
ORDER BY dd.Year, dd.Month;

-- Monthly orders trend
SELECT
  dd.Year,
  dd.Month,
  dd.MonthName,
  COUNT(DISTINCT fs.OrderID) AS orders
FROM fact_sales fs
JOIN dim_date dd ON dd.DateKey = fs.DateKey
GROUP BY dd.Year, dd.Month, dd.MonthName
ORDER BY dd.Year, dd.Month;

-- Day of week performance
SELECT
  dd.DayOfWeek,
  ROUND(SUM(fs.NetRevenue), 2) AS net_revenue,
  COUNT(DISTINCT fs.OrderID) AS orders,
  ROUND(SUM(fs.NetRevenue)/NULLIF(COUNT(DISTINCT fs.OrderID),0),2) AS aov_net
FROM fact_sales fs
JOIN dim_date dd ON dd.DateKey = fs.DateKey
GROUP BY dd.DayOfWeek
ORDER BY dd.DayOfWeek;

-- Revenue by channel over time (monthly)
SELECT
  dd.Year,
  dd.Month,
  ch.SalesChannel,
  ROUND(SUM(fs.NetRevenue), 2) AS net_revenue
FROM fact_sales fs
JOIN dim_date dd ON dd.DateKey = fs.DateKey
JOIN dim_channel ch ON ch.ChannelID = fs.ChannelID
GROUP BY dd.Year, dd.Month, ch.SalesChannel
ORDER BY dd.Year, dd.Month, net_revenue DESC;
