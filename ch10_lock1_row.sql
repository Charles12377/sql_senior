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


UPDATE customers 
SET cust_zip = '11111'
WHERE cust_id = 10001;

SELECT *
FROM customers;

COMMIT;

SHOW INDEX FROM customers;

#字符串类型不加引号导致索引失效，索引失效会导致行锁变表锁
UPDATE customers 
SET cust_zip = 11111
WHERE cust_id + 0 = 10001;

SELECT *
FROM customers;

EXPLAIN
UPDATE customers 
SET cust_zip = 55555
WHERE cust_id + 0 = 10001;

COMMIT;

#间隙锁
#当适用范围条件检索数据，innodb会给符合条件的已有记录加锁，对于键值在条件范围内但不存在的记录也会加锁（间隙锁）
UPDATE customers 
SET cust_zip = '99999'
WHERE cust_id > 10004 AND cust_id < 10007;

COMMIT;

SELECT *
FROM customers;

#如何锁定一行
begin;

SELECT *
FROM customers
WHERE cust_id = 10006
FOR UPDATE;

COMMIT;

SELECT *
FROM customers;

#行锁分析
SHOW STATUS LIKE 'innodb_row_lock%';