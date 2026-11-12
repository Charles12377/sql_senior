-- Active: 1794391448033@@127.0.0.1@3307@crashcourse
SELECT CONNECTION_ID();

SET autocommit = 0;

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

COMMIT;

SELECT *
FROM customers;


UPDATE customers 
SET cust_zip = '33333'
WHERE cust_id = 10003;

SELECT *
FROM customers;

COMMIT;

SELECT * 
FROM customers;

#行锁变表锁
UPDATE customers 
SET cust_zip = '33333'
WHERE cust_id = 10003;

SELECT *
FROM customers;

COMMIT;

#间隙锁
INSERT INTO customers (cust_id,cust_name,cust_zip)
VALUES (10006,'ww','66666');

#锁定一行
UPDATE customers
SET cust_state = 'MI'
WHERE cust_id = 10006;

COMMIT