-- Active: 1793507254360@@127.0.0.1@3307@crashcourse
/*

锁
    分类：
        按对数据的操作分：
            读锁（共享锁）：对同一份数据，多个读操作同时进行而不会互相影响
            写锁（排他锁）：当前写操作没有完成前，会阻断其他写锁和读锁
        俺对数据操作的颗粒度分：
            表锁（偏读）
            行锁（偏写）

    三锁：
        表锁
        行锁
        页锁

*/

SHOW open TABLES;

LOCK TABLE customers READ,orders WRITE;

SHOW open TABLES;

UNLOCK TABLES;

SHOW open TABLES;

LOCK TABLE customers READ;

#当前会话只能读取上锁的表，不能写该上锁的表
SELECT *
FROM customers;

#当前会话不能读取未上锁的表
SELECT *
FROM orderitems;

UPDATE customers SET cust_name = 'Fudd'
WHERE cust_id = 10005;

SELECT *
FROM customers;

UNLOCK TABLES;

UPDATE customers SET cust_name = 'Fudd'
WHERE cust_id = 10005;

#加写锁
LOCK TABLE customers WRITE;

#自己可查询该表
SELECT *
FROM customers;

#自己可插入，更新该表
UPDATE customers SET cust_name = 'Fudd'
WHERE cust_id = 10005;

#不能查询未上锁的表
SELECT *
FROM orderitems;

UNLOCK TABLES;

SHOW STATUS LIKE 'table_locks%';

