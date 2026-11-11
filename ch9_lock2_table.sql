#1会话给该表加读锁锁，2会话可以读取
SELECT *
FROM customers;

#1会话给该表加读锁锁，2会话不能插入，更新该表数据
UPDATE customers SET cust_name = 'Fudd'
WHERE cust_id = 10005;

#1会话给该表加写锁，2会话不可以查询该表（由于MySQL运用行锁机制，会出现锁的隔离效果失效）
SELECT *
FROM customers;

#不可以更新，插入该表数据
UPDATE customers SET cust_name = 'Fudd'
WHERE cust_id = 10005;

SELECT *
FROM customers
WHERE cust_state = 'MI';