/*=========================================================
    OLIST E-COMMERCE ANALYSIS
    Author: Anguie Antolinez
    Database: Olist

Description:
Business analysis of the Olist e-commerce dataset using
PostgreSQL to answer sales, customer, product, seller,
and operational business questions.
=========================================================*/

/*=========================================================
1. SALES OVERVIEW
=========================================================*/

-- 1.1 Total Revenue
SELECT
    SUM(payment_value) AS total_revenue
FROM order_payments;

-- 1.2 Total Orders
SELECT
    COUNT(order_id) AS total_orders
FROM orders;

-- 1.3 Average Ticket per Order 
WITH order_totals AS (
    SELECT
        order_id,
        SUM(payment_value) AS total_order
    FROM order_payments
    GROUP BY order_id
)
SELECT
    AVG(total_order) AS average_ticket
FROM order_totals;

/*=========================================================
2. REGIONAL ANALYSIS
=========================================================*/

-- 2.1 Orders by State
SELECT customer_state, COUNT (order_id) AS count_states
FROM customers
INNER JOIN  orders
ON customers.customer_id= orders.customer_id
GROUP BY customer_state
ORDER BY count_states DESC;

-- 2.2 Revenue by States
SELECT
    c.customer_state,
    COUNT(o.order_id) AS total_orders,
    SUM(op.payment_value) AS total_revenue
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
INNER JOIN order_payments op
    ON o.order_id = op.order_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC;

-- 2.3 Monthly Sales Trend
SELECT 
	EXTRACT ( YEAR FROM order_purchase_timestamp) AS year,
	EXTRACT ( MONTH FROM order_purchase_timestamp) AS month,
	SUM( op. payment_value) AS revenue
FROM orders o
INNER JOIN order_payments op
ON op.order_id= o.order_id
GROUP BY year, month
ORDER BY year, month;

/*=========================================================
3. PRODUCT ANALYSIS
=========================================================*/

-- 3.1 Top 10 Categories by Revenue
SELECT p. product_category_name, SUM(oi.price) AS category_revenue
FROM order_items oi
INNER JOIN products p
ON oi.product_id= p.product_id
GROUP BY p. product_category_name
ORDER BY category_revenue DESC
LIMIT 10;

-- 3.2 Top 10 Categories by Quantity Sold
SELECT p. product_category_name, COUNT (oi.product_id) AS category_count
FROM order_items oi
INNER JOIN products p
ON oi.product_id= p.product_id
GROUP BY p.product_category_name
ORDER BY category_count DESC
LIMIT 10;

-- 3.3 Average Product Price by Category
SELECT p. product_category_name, AVG(oi.price) AS average_price_category
FROM order_items oi
INNER JOIN products p
ON oi.product_id= p.product_id
GROUP BY p. product_category_name
ORDER BY average_price_category DESC
LIMIT 10;

-- 3.4 Average Review Score by Category
SELECT
    p.product_category_name,
    AVG(r.review_score) AS average_review,
	COUNT(r.review_score) AS total_reviews
FROM order_items oi
INNER JOIN products p
    ON oi.product_id = p.product_id
INNER JOIN order_reviews r
    ON oi.order_id = r.order_id
GROUP BY p.product_category_name
ORDER BY average_review DESC;

/*=========================================================
4. SELLER ANALYSIS
=========================================================*/

--4.1 Top Seller by Revenue (RANKING)
WITH seller_revenue AS (
    SELECT
        seller_id,
        SUM(price) AS total_revenue
    FROM order_items
    GROUP BY seller_id
)

SELECT
    RANK() OVER (ORDER BY total_revenue DESC) AS seller_rank,
    seller_id,
    total_revenue
FROM seller_revenue
ORDER BY seller_rank;

/*=========================================================
5. CUSTOMER BEHAVIOR
=========================================================*/

--5.1 Most Used Payment Methods
SELECT payment_type, COUNT (payment_type) AS Count_Payment_Type
FROM order_payments
GROUP BY payment_type
ORDER BY Count_Payment_Type DESC;

--5.2 Delivery DELAY vs Review Score
SELECT
    CASE
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 'Late'
        ELSE 'On Time'
    END AS delivery_status,
    AVG(r.review_score) AS average_review
FROM orders o
INNER JOIN order_reviews r
    ON o.order_id = r.order_id
GROUP BY delivery_status
ORDER BY average_review DESC;







