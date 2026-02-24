-- Cancellation & Operations

-- Overall Cancellation Rate
SELECT
ROUND(
    COUNT(CASE WHEN order_status = 'Cancelled' THEN 1 END) 
    * 100.0
    / COUNT(DISTINCT order_id),
2) AS cancellation_rate
FROM orders;

-- Monthly Cancellation Trend
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    ROUND(
        COUNT(CASE WHEN order_status = 'Cancelled' THEN 1 END)
        * 100.0
        / COUNT(order_id),
    2) AS cancellation_rate
FROM orders
GROUP BY month
ORDER BY month;

-- Most Cancelled Products
SELECT
    p.product_id,
    p.product_name,
    SUM(od.quantity) AS cancelled_quantity
FROM order_details od
JOIN orders o 
    ON o.order_id = od.order_id
JOIN products p 
    ON p.product_id = od.product_id
WHERE o.order_status = 'Cancelled'
GROUP BY p.product_id, p.product_name
ORDER BY cancelled_quantity DESC
LIMIT 5;

-- Overall Average Delivery Time (All Delivered Orders)
SELECT
ROUND(AVG(DATEDIFF(delivered_date, order_date)), 2) AS avg_delivery_time
FROM orders
WHERE order_status = 'Delivered';

-- Late Delivery Analysis
SELECT
    order_id,
    order_date,
    delivered_date,
    DATEDIFF(delivered_date, order_date) AS delivery_days
FROM orders
WHERE order_status = 'Delivered'
AND DATEDIFF(delivered_date, order_date) > 5
ORDER BY delivery_days DESC;