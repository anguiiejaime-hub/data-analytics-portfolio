/* SALES OVERVIEW */

--Total sales
select sum(sales)as total_sales
from sales;

--Total orders
select count(*) as total_orders
from sales;

--Avarage order value (AOV)
Select AVG(sales) as average_order_value
from sales;

/* REGIONAL ANALYSIS */

-- Sales by Region
Select Region, 
	Sum(sales) as sales_region
from sales
group by region
order by sales_region DESC;

-- Revenue Share by Region
SELECT region,
       SUM(sales) AS sales_region,
       ROUND(
           (SUM(sales) / (SELECT SUM(sales) FROM sales)) * 100,
           2
       ) AS revenue_share_pct
FROM sales
GROUP BY region
ORDER BY revenue_share_pct DESC;

--	Regional performance classification
SELECT region,
       SUM(sales) AS sales_region,
       CASE
           WHEN SUM(sales) > 600000 THEN 'High Revenue'
           WHEN SUM(sales) > 400000 THEN 'Medium Revenue'
           ELSE 'Low Revenue'
       END AS performance_category
FROM sales
GROUP BY region
ORDER BY sales_region DESC;

/* PRODUCT ANALYSIS */

-- Top 10 products by sales
select product_name,
	sum(sales) as product_sales
from sales
group by product_name
order by product_sales DESC
Limit 10;

-- Revenue share by category
SELECT category,
       SUM(sales) AS share_ctg,
       ROUND(
           (SUM(sales) / (SELECT SUM(sales) FROM sales)) * 100,
           2
       ) AS revenue_share_ctg
FROM sales
GROUP BY category
ORDER BY revenue_share_ctg DESC;

-- Sales by category
SELECT category,
       SUM(sales) AS category_sales
FROM sales
GROUP BY category
ORDER BY category_sales DESC;

--Category generation more than $700k in sales
SELECT category,
       SUM(sales) AS category_sales
FROM sales
GROUP BY category
HAVING SUM(sales) > 700000
ORDER BY category_sales DESC;

/* CUSTOMER ANALYSIS */

--Customer ranking by total sales
SELECT
    RANK() OVER (
        ORDER BY SUM(sales) DESC
    ) AS customer_rank,
    customer_name,
    SUM(sales) AS customer_sales
FROM sales
GROUP BY customer_name
ORDER BY customer_sales DESC;

/* TIME ANALYSIS */

--Sales by year
SELECT EXTRACT(YEAR FROM order_date) AS year,
       SUM(sales) AS sales_by_year
FROM sales
GROUP BY EXTRACT(YEAR FROM order_date)
ORDER BY sales_by_year DESC;

--Sales by month
SELECT EXTRACT(MONTH FROM order_date) AS monthly,
       SUM(sales) AS sales_by_month
FROM sales
GROUP BY EXTRACT(month FROM order_date)
ORDER BY sales_by_month DESC;


