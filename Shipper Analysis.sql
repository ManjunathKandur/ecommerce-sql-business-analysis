-- SHIPPER ANALYSIS

-- Orders Delivered by Shipper
SELECT
    s.shipper_id,
    s.shipper_name,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN shippers s 
    ON s.shipper_id = o.shipper_id
WHERE o.order_status = 'Delivered'
GROUP BY s.shipper_id, s.shipper_name
ORDER BY total_orders DESC;

-- Average Delivery Time
SELECT
    s.shipper_id,
    s.company_name,
    ROUND(AVG(DATEDIFF(o.delivered_date, o.order_date)), 2) AS avg_delivery_days
FROM orders o
JOIN shippers s 
    ON s.shipper_id = o.shipper_id
WHERE o.order_status = 'Delivered'
GROUP BY s.shipper_id, s.company_name
ORDER BY avg_delivery_days ASC;

-- Fastest Shipper
SELECT
    s.shipper_id,
    s.company_name,
    ROUND(AVG(DATEDIFF(o.delivered_date, o.order_date)), 2) AS average_time
FROM orders o
JOIN shippers s 
    ON s.shipper_id = o.shipper_id
WHERE o.order_status = 'Delivered'
GROUP BY s.shipper_id, s.company_name
ORDER BY average_time ASC
LIMIT 1;

-- Cancellation by Shipper
SELECT
    s.shipper_id,
    s.company_name,
    COUNT(DISTINCT o.order_id) AS cancelled_orders
FROM orders o
JOIN shippers s  
    ON s.shipper_id = o.shipper_id
WHERE o.order_status = 'Cancelled'
GROUP BY s.shipper_id, s.company_name
ORDER BY cancelled_orders DESC;

-- Shipper Performance Ranking
WITH avg_time AS (
    SELECT
        s.shipper_id,
        s.company_name,
        ROUND(AVG(DATEDIFF(o.delivered_date, o.order_date)), 2) AS average_time
    FROM orders o
    JOIN shippers s 
        ON s.shipper_id = o.shipper_id
    WHERE o.order_status = 'Delivered'
    GROUP BY s.shipper_id, s.company_name
)

SELECT 
    shipper_id,
    company_name,
    average_time,
    RANK() OVER (ORDER BY average_time ASC) AS rank_position
FROM avg_time
ORDER BY rank_position;