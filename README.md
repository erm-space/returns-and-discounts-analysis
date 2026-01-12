## Returns & Discount Impact – MySQL & Power BI Implementation

This project analyzes the **impact of returns and discounts on revenue and customer behavior** using **MySQL** for analysis and **Power BI** for modeling and visualization.

In MySQL, multiple analysis scripts were created to explore different aspects of the data. These include overall KPIs and revenue overview (`kpis_overview.sql`), return behavior across channels and customer attributes (`returns_analysis.sql`), discount performance and discount bands (`discounts_analysis.sql`), and the relationship between discounts and returns (`discount_vs_returns.sql`). Additional queries were used to analyze product, channel, and country performance (`product_channel_country.sql`), customer segments (`customer_segments.sql`), revenue trends over time (`revenue_trends.sql`), and to perform data quality and consistency checks (`data_quality.sql`).

The MySQL results were then loaded into Power BI, where a star-style data model was created using sales and returns fact tables with supporting dimensions (date, product, customer, channel, promotion). In Power BI, key **DAX measures** were created, including **Total Orders, Returned Orders, Return Rate, Net Revenue, Revenue Lost from Returns, Average Order Value (AOV), and discount-related metrics**. These measures were reused consistently across the report.

A 3-page Power BI dashboard was built:
- **Sales Performance Overview** – high-level KPIs and overall performance context  
- **Returns Impact Analysis** – operational and financial impact of returns, including return risk by sales channel  
- **Customer Behavior & Demographics** – customer behavior by country and gender, including order volume, returns, and AOV  

The focus of the project was on understanding **where value is created and where it is lost due to returns and discounts**, using clear metrics and readable, business-focused visuals.
