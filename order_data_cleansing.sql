-- Project: Order Data Integration and Cleansing
CREATE TABLE raw_orders (
  order_id INT,
  customer_id INT,
  product_name STRING,
  amount STRING,
  order_date STRING,
  status STRING
);

INSERT INTO raw_orders VALUES
(101, 1, '  laptop ', '1200.50', '2024-05-10', 'COMPLETED'),
(102, 2, 'mOuSe', '45.50', '12/05/2024', 'pending '),
(103, 3, 'KEYBOARD', NULL, '2024-05-12', 'FAILED'),
(104, 4, 'MONITOR', 'unknown', '22-05-2024', 'Completed'),
(105, 1, '  laptop ', '1200.50', '2024-05-10', 'COMPLETED'); 
SELECT product_name,
CONCAT(UPPER(LEFT(TRIM(product_name), 1)), LOWER(SUBSTRING(TRIM(product_name), 2))) as new_name
FROM raw_orders
ORDER BY customer_id;
SELECT amount,
TRY_CAST(amount AS FLOAT) as new_amount
FROM raw_orders
ORDER BY customer_id;
SELECT status,
CASE
    WHEN UPPER(TRIM(status)) == 'COMPLETED' THEN 'COMPLETED'

    ELSE CONCAT(UPPER(LEFT(TRIM(status), 1)), LOWER(SUBSTRING(TRIM(status), 2))) 
    END as new_status
FROM raw_orders
ORDER BY customer_id;
SELECT order_date,
COALESCE(TRY_TO_DATE(order_date, 'yyyy-MM-dd'), TRY_TO_DATE(order_date, 'dd/MM/yyyy' ), TRY_TO_DATE(order_date, 'dd-MM-yyyy')) as new_date
FROM raw_orders
ORDER BY customer_id;
CREATE TABLE clean_orders AS
SELECT DISTINCT
customer_id,
order_id,
CONCAT(UPPER(LEFT(TRIM(product_name), 1)), LOWER(SUBSTRING(TRIM(product_name), 2))) as new_name,
TRY_CAST(amount AS FLOAT) as new_amount,
CASE
    WHEN UPPER(TRIM(status)) == 'COMPLETED' THEN 'COMPLETED'

    ELSE CONCAT(UPPER(LEFT(TRIM(status), 1)), LOWER(SUBSTRING(TRIM(status), 2))) 
    END as new_status,
COALESCE(TRY_TO_DATE(order_date, 'yyyy-MM-dd'), TRY_TO_DATE(order_date, 'dd/MM/yyyy' ), TRY_TO_DATE(order_date, 'dd-MM-yyyy')) as new_date
FROM raw_orders
ORDER BY customer_id;
SELECT DISTINCT order_id, customer_id, new_name, new_amount, new_status, new_date 
FROM clean_orders
ORDER BY customer_id;
