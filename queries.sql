-- 📊 Revenue Drivers Analysis SQL

-- 1. Revenue and profit overview
SELECT 
    SUM(sales) AS total_revenue,
    SUM(profit) AS total_profit
FROM sales;

-- 2. Revenue by category
SELECT 
    category,
    SUM(sales) AS total_revenue
FROM sales
GROUP BY category
ORDER BY total_revenue DESC;

-- 3. Profit by category
SELECT 
    category,
    SUM(profit) AS total_profit
FROM sales
GROUP BY category
ORDER BY total_profit DESC;

-- 4. Revenue by region
SELECT 
    region,
    SUM(sales) AS total_revenue
FROM sales
GROUP BY region
ORDER BY total_revenue DESC;

-- 5. Profit by region (важно для "эффективности")
SELECT 
    region,
    SUM(profit) AS total_profit
FROM sales
GROUP BY region
ORDER BY total_profit DESC;

-- 6. Profit margin by region
SELECT 
    region,
    SUM(profit) / SUM(sales) AS profit_margin
FROM sales
GROUP BY region
ORDER BY profit_margin DESC;

-- 7. Customer segmentation (VIP / Regular / Low)
WITH customer_spending AS (
    SELECT 
        customer_id,
        SUM(sales) AS total_spent
    FROM sales
    GROUP BY customer_id
)
SELECT 
    customer_id,
    total_spent,
    CASE 
        WHEN total_spent > 100000 THEN 'VIP'
        WHEN total_spent BETWEEN 50000 AND 100000 THEN 'Regular'
        ELSE 'Low'
    END AS segment
FROM customer_spending;

-- 8. Revenue by segment
WITH customer_spending AS (
    SELECT 
        customer_id,
        SUM(sales) AS total_spent
    FROM sales
    GROUP BY customer_id
),
segmented AS (
    SELECT *,
        CASE 
            WHEN total_spent > 100000 THEN 'VIP'
            WHEN total_spent BETWEEN 50000 AND 100000 THEN 'Regular'
            ELSE 'Low'
        END AS segment
    FROM customer_spending
)
SELECT 
    segment,
    SUM(total_spent) AS revenue
FROM segmented
GROUP BY segment
ORDER BY revenue DESC;

-- 9. Discount impact on profit
SELECT 
    discount,
    SUM(profit) AS total_profit
FROM sales
GROUP BY discount
ORDER BY discount;

-- 10. Discount groups (важный бизнес-анализ)
SELECT 
    CASE 
        WHEN discount <= 0.1 THEN '0-10%'
        WHEN discount <= 0.2 THEN '10-20%'
        WHEN discount <= 0.3 THEN '20-30%'
        ELSE '30%+'
    END AS discount_group,
    SUM(profit) AS total_profit
FROM sales
GROUP BY discount_group
ORDER BY discount_group;

-- 11. Yearly revenue and profit trend
SELECT 
    EXTRACT(YEAR FROM order_date) AS year,
    SUM(sales) AS revenue,
    SUM(profit) AS profit
FROM sales
GROUP BY year
ORDER BY year;
