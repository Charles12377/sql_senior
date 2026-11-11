-- Active: 1793507254360@@127.0.0.1@3307@crashcourse
SET autocommit = 0;

SELECT CONNECTION_ID();

SELECT *
 FROM customers;

UPDATE customers 
SET cust_name = 'Fudd'
WHERE cust_id = 10005;

SELECT *
FROM customers;

COMMIT;

UPDATE customers 
SET cust_name = 'E Fudd'
WHERE cust_id = 10005;

SELECT *
FROM customers;

UPDATE customers 
SET cust_zip = '33333'
WHERE cust_id = 10001;

SELECT *
FROM customers;

COMMIT;