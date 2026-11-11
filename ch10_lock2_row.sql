-- Active: 1794391448033@@127.0.0.1@3307@crashcourse
SELECT CONNECTION_ID();

SELECT *
FROM customers;

COMMIT;

SELECT *
FROM customers;

UPDATE customers 
SET cust_zip = '55555'
WHERE cust_id = 10003;

SELECT *
FROM customers;
