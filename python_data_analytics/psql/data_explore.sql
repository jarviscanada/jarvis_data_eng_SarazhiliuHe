-- Show table schema in psql CLI
\d+ retail;

-- Show first 10 rows
SELECT *
FROM retail
LIMIT 10;

-- Check number of records
SELECT COUNT(*) AS total_records
FROM retail;

-- Number of clients (unique customer_id)
SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM retail;

-- Invoice date range
SELECT
    MIN(invoice_date) AS min_date,
    MAX(invoice_date) AS max_date
FROM retail;

-- Number of SKU/merchant (unique stock_code)
SELECT COUNT(DISTINCT stock_code) as unique_merchants
FROM retail;

-- Calculate average invoice amount excluding invoices with a negative amount or negative price
SELECT AVG(invoice_total) as avg_invoice_amount
FROM (
    SELECT invoice_no, SUM(unit_price * quantity) AS invoice_total
    FROM retail
    WHERE quantity > 0 AND unit_price > 0
    GROUP BY invoice_no
     ) AS sub;

-- Calculate total revenue (sum of unit_price * quantity)
SELECT SUM(unit_price * quantity) AS total_revenue
FROM retail;

-- Calculate total revenue by YYYYMM (Create a new YYYMM column)
-- TO_CHAR(date_or_timestamp, 'format')
SELECT
    TO_CHAR(invoice_date, 'YYYYMM') AS year_month,
    SUM(unit_price * quantity) AS revenue
FROM retail
GROUP BY TO_CHAR(invoice_date, 'YYYYMM')
ORDER BY year_month;

