USE returns_discount_impact;

-- Row counts
SELECT 'dim_customer' AS table_name, COUNT(*) AS rows_cnt FROM dim_customer
UNION ALL SELECT 'dim_product', COUNT(*) FROM dim_product
UNION ALL SELECT 'dim_date', COUNT(*) FROM dim_date
UNION ALL SELECT 'dim_channel', COUNT(*) FROM dim_channel
UNION ALL SELECT 'dim_promo', COUNT(*) FROM dim_promo
UNION ALL SELECT 'fact_sales', COUNT(*) FROM fact_sales
UNION ALL SELECT 'fact_returns', COUNT(*) FROM fact_returns;

-- Primary key duplicates check (should return 0 rows)
SELECT CustomerID, COUNT(*) c FROM dim_customer GROUP BY CustomerID HAVING c > 1;
SELECT ProductID, COUNT(*) c FROM dim_product GROUP BY ProductID HAVING c > 1;
SELECT DateKey, COUNT(*) c FROM dim_date GROUP BY DateKey HAVING c > 1;
SELECT ChannelID, COUNT(*) c FROM dim_channel GROUP BY ChannelID HAVING c > 1;
SELECT PromoID, COUNT(*) c FROM dim_promo GROUP BY PromoID HAVING c > 1;
SELECT SalesID, COUNT(*) c FROM fact_sales GROUP BY SalesID HAVING c > 1;
SELECT ReturnID, COUNT(*) c FROM fact_returns GROUP BY ReturnID HAVING c > 1;

-- Foreign key "orphan" checks (should all be 0)
SELECT COUNT(*) AS missing_customers
FROM fact_sales fs
LEFT JOIN dim_customer dc ON dc.CustomerID = fs.CustomerID
WHERE dc.CustomerID IS NULL;

SELECT COUNT(*) AS missing_products
FROM fact_sales fs
LEFT JOIN dim_product dp ON dp.ProductID = fs.ProductID
WHERE dp.ProductID IS NULL;

SELECT COUNT(*) AS missing_dates
FROM fact_sales fs
LEFT JOIN dim_date dd ON dd.DateKey = fs.DateKey
WHERE dd.DateKey IS NULL;

SELECT COUNT(*) AS missing_channels
FROM fact_sales fs
LEFT JOIN dim_channel ch ON ch.ChannelID = fs.ChannelID
WHERE ch.ChannelID IS NULL;

SELECT COUNT(*) AS missing_promos
FROM fact_sales fs
LEFT JOIN dim_promo pr ON pr.PromoID = fs.PromoID
WHERE pr.PromoID IS NULL;

-- Returns must match to a SalesID (should be 0)
SELECT COUNT(*) AS missing_sales_for_returns
FROM fact_returns fr
LEFT JOIN fact_sales fs ON fs.SalesID = fr.SalesID
WHERE fs.SalesID IS NULL;

-- Basic numeric sanity checks (should be 0)
SELECT COUNT(*) AS bad_math_rows
FROM fact_sales
WHERE ABS((GrossRevenue - DiscountAmount) - NetRevenue) > 0.02;

SELECT COUNT(*) AS negative_money_rows
FROM fact_sales
WHERE GrossRevenue < 0 OR DiscountAmount < 0 OR NetRevenue < 0;

-- Check return flags vs returns table (both numbers should match)
SELECT SUM(IsReturned) AS returned_flag_rows FROM fact_sales;
SELECT COUNT(*) AS returns_rows FROM fact_returns;
