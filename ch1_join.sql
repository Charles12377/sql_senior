-- Active: 1793507254360@@127.0.0.1@3307@crashcourse
SHOW ENGINES;

#内联结
SELECT cust_name
FROM customers
INNER JOIN orders ON customers.cust_id = orders.cust_id
    AND order_num = 20005;

#左联结(左表全部保留)
SELECT cust_name,cust_email,order_num
FROM customers
LEFT JOIN orders ON customers.cust_id = orders.cust_id
    AND order_date <= '2005-09-30';

#右联结(右表全部保留)
SELECT cust_name,cust_email,order_num
FROM customers
RIGHT JOIN orders ON customers.cust_id = orders.cust_id
    AND order_date <= '2005-09-30';

#左联结(右表全部舍去)
SELECT cust_name,cust_email,order_num
FROM customers
LEFT JOIN orders ON customers.cust_id = orders.cust_id
    AND order_date <= '2005-09-30'
WHERE orders.cust_id IS NULL;

#右联结(左表全部舍去)
SELECT cust_name,cust_email,order_num
FROM customers
RIGHT JOIN orders ON customers.cust_id = orders.cust_id
    AND order_date <= '2005-09-30'
WHERE customers.cust_id IS NULL;

#全外联结(保留所有)
SELECT cust_name,cust_email,order_num
FROM customers
LEFT JOIN orders ON customers.cust_id = orders.cust_id
    AND order_date <= '2005-09-30'
UNION
SELECT cust_name,cust_email,order_num
FROM customers
RIGHT JOIN orders ON customers.cust_id = orders.cust_id
    AND order_date <= '2005-09-30';

#全外联结(保留不符合要求的)
SELECT * FROM(
    SELECT cust_name,cust_email,order_num
    FROM customers
    LEFT JOIN orders ON customers.cust_id = orders.cust_id
        AND order_date <= '2005-09-30'
    UNION
    SELECT cust_name,cust_email,order_num
    FROM customers
    RIGHT JOIN orders ON customers.cust_id = orders.cust_id
        AND order_date <= '2005-09-30'
    WHERE customers.cust_id IS NULL OR orders.cust_id IS NULL
) AS cust_order
WHERE cust_order.cust_name IS NULL OR cust_order.order_num IS NULL;