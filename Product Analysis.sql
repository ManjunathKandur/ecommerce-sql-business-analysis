-- Product Analysis

-- Top 10 Best-Selling Products
SELECT
    p.product_id,
    p.product_name,
    SUM(od.quantity) AS quantity_sold
FROM order_details od
JOIN orders o 
    ON o.order_id = od.order_id
JOIN products p 
    ON p.product_id = od.product_id
WHERE o.order_status = 'Delivered'
GROUP BY p.product_id, p.product_name
ORDER BY quantity_sold DESC
LIMIT 10;

-- products generate the highest revenue
SELECT
    p.product_id,
    p.product_name,
    ROUND(SUM((od.quantity * od.unit_price) - od.discount), 2) AS revenue
FROM order_details od
JOIN orders o 
    ON o.order_id = od.order_id
JOIN products p 
    ON p.product_id = od.product_id
WHERE o.order_status = 'Delivered'
GROUP BY p.product_id, p.product_name
ORDER BY revenue DESC
LIMIT 10;

-- products that are selling in high quantity but generating low revenue.
SELECT
    p.product_id,
    p.product_name,
    SUM(od.quantity) AS total_sold,
    ROUND(SUM((od.quantity * od.unit_price) - od.discount), 2) AS total_revenue
FROM order_details od
JOIN orders o 
    ON o.order_id = od.order_id
JOIN products p 
    ON p.product_id = od.product_id
WHERE o.order_status = 'Delivered'
GROUP BY p.product_id, p.product_name
ORDER BY total_sold DESC, total_revenue ASC;

-- products where the average discount given is higher than 20% of unit price.
SELECT
    p.product_id,
    p.product_name,
    ROUND(AVG(od.discount / od.unit_price), 2) AS average_discount_ratio
FROM order_details od 
JOIN orders o 
    ON o.order_id = od.order_id
JOIN products p 
    ON p.product_id = od.product_id
WHERE o.order_status = 'Delivered'
GROUP BY p.product_id, p.product_name
HAVING AVG(od.discount / od.unit_price) > 0.20;

-- Find products that were never sold (no order_details records).
SELECT 
    p.product_id,
    p.product_name
FROM products p
LEFT JOIN order_details od 
    ON p.product_id = od.product_id
WHERE od.product_id IS NULL;
