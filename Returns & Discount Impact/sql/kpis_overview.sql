USE returns_discount_impact;

-- Overall KPIs
SELECT
  ROUND(SUM(NetRevenue), 2) AS total_net_revenue,
  COUNT(DISTINCT OrderID) AS total_orders,
  COUNT(DISTINCT CustomerID) AS active_customers,
  ROUND(SUM(NetRevenue) / NULLIF(COUNT(DISTINCT OrderID), 0), 2) AS aov_net,
  ROUND(AVG(DiscountRate), 4) AS avg_discount_rate_line,
  ROUND(SUM(ShippingCostAllocated), 2) AS total_shipping_allocated
FROM fact_sales;

-- Return rate and discount share
SELECT
  ROUND(SUM(IsReturned) / NULLIF(COUNT(*), 0), 4) AS return_rate_lines,
  ROUND(SUM(IsDiscounted) / NULLIF(COUNT(*), 0), 4) AS discounted_share_lines
FROM fact_sales;

-- Revenue split: returned vs not returned
SELECT
  IsReturned,
  ROUND(SUM(NetRevenue), 2) AS net_revenue
FROM fact_sales
GROUP BY IsReturned;

-- Revenue split: discounted vs not discounted
SELECT
  IsDiscounted,
  ROUND(SUM(NetRevenue), 2) AS net_revenue
FROM fact_sales
GROUP BY IsDiscounted;

-- Top payment methods by net revenue
SELECT
  PaymentMethod,
  ROUND(SUM(NetRevenue), 2) AS net_revenue,
  COUNT(DISTINCT OrderID) AS orders
FROM fact_sales
GROUP BY PaymentMethod
ORDER BY net_revenue DESC
LIMIT 10;
