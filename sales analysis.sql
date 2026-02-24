-- SALES ANALYSIS

-- total revenue
SELECT 
    ROUND(SUM(od.quantity * od.unit_price), 2) AS total_revenue
FROM orders o
JOIN order_details od 
    ON o.order_id = od.order_id
WHERE o.order_status = 'Delivered';

-- Monthy Revenue
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    ROUND(
        SUM((od.quantity * od.unit_price) - od.discount),
    2) AS net_revenue
FROM orders o
JOIN order_details od 
    ON o.order_id = od.order_id
WHERE o.order_status = 'Delivered'
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month;

-- average order value
SELECT 
    ROUND(AVG(order_total), 2) AS AOV
FROM (
    SELECT 
        o.order_id,
        SUM((od.quantity * od.unit_price) - od.discount) AS order_total
    FROM orders o
    JOIN order_details od 
        ON o.order_id = od.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY o.order_id
) t;

-- Highest Sales Day
SELECT
    DAYNAME(o.order_date) AS day_name,
    ROUND(SUM((od.quantity * od.unit_price) - od.discount), 2) AS total_revenue
FROM orders o
JOIN order_details od 
    ON o.order_id = od.order_id
WHERE o.order_status = 'Delivered'
GROUP BY day_name
ORDER BY total_revenue DESC
LIMIT 1;

-- Top 10% Revenue Contribution
WITH order_revenue AS (
    SELECT 
        o.order_id,
        SUM((od.quantity * od.unit_price) - od.discount) AS revenue
    FROM orders o
    JOIN order_details od 
        ON o.order_id = od.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY o.order_id
),

ranked_orders AS (
    SELECT 
        order_id,
        revenue,
        ROW_NUMBER() OVER (ORDER BY revenue DESC) AS rn,
        COUNT(*) OVER () AS total_orders
    FROM order_revenue
)

SELECT 
    ROUND(
        SUM(CASE 
                WHEN rn <= CEIL(total_orders * 0.10) 
                THEN revenue 
            END)
        /
        SUM(revenue) * 100,
    2) AS top_10_percent_revenue_contribution
FROM ranked_orders;
