-- CUSTOMER ANALYSIS

-- Top 10 Customers by Total Spending
SELECT
    c.customer_id,
    c.full_name,
    ROUND(SUM((od.quantity * od.unit_price) - od.discount), 2) AS total_spent
FROM customers c
JOIN orders o 
    ON o.customer_id = c.customer_id
JOIN order_details od 
    ON o.order_id = od.order_id
WHERE o.order_status = 'Delivered'
GROUP BY c.customer_id, c.full_name
ORDER BY total_spent DESC
LIMIT 10;


-- Repeat vs One-Time Customers
WITH table_1 AS (
    SELECT
        customer_id,
        COUNT(*) AS total_orders
    FROM orders
    WHERE order_status = 'Delivered'
    GROUP BY customer_id
)

SELECT
    SUM(CASE WHEN total_orders = 1 THEN 1 ELSE 0 END) AS one_time_customers,
    SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END) AS repeat_customers
FROM table_1;

-- Average Orders Per Customer
WITH table_1 AS (
    SELECT
        customer_id,
        COUNT(order_id) AS order_count
    FROM orders
    WHERE order_status = 'Delivered'
    GROUP BY customer_id
)

SELECT 
    ROUND(AVG(order_count), 2) AS avg_orders_per_customer
FROM table_1;

-- Revenue by City
SELECT
    c.city,
    ROUND(SUM((od.quantity * od.unit_price) - od.discount), 2) AS total_amount
FROM customers c
JOIN orders o 
    ON o.customer_id = c.customer_id
JOIN order_details od 
    ON od.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY c.city
ORDER BY total_amount DESC
LIMIT 1;

-- cancellation rate
SELECT
    customer_id,
    COUNT(*) AS cancelled_orders
FROM orders 
WHERE order_status = 'Cancelled'
GROUP BY customer_id
HAVING COUNT(*) > 2
ORDER BY cancelled_orders DESC;

