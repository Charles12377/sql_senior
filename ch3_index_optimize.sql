#单表
SELECT order_num,prod_id
FROM orderitems
WHERE order_num = 20005
    AND item_price > 9
ORDER BY quantity DESC
LIMIT 1;

EXPLAIN SELECT order_num,prod_id
FROM orderitems
WHERE order_num = 20005
    AND item_price > 9
ORDER BY quantity DESC
LIMIT 1;

SHOW INDEX FROM orderitems;

CREATE INDEX fk_orderitems_npq 
ON orderitems(order_num,item_price,quantity);

#范围会导致索引失效，还是有filesort
EXPLAIN SELECT order_num,prod_id
FROM orderitems
WHERE order_num = 20005
    AND item_price > 9  
ORDER BY quantity DESC
LIMIT 1;

DROP INDEX fk_orderitems_npq
ON orderitems;

SHOW INDEX
FROM orderitems;

CREATE INDEX fk_orderitems_nq
ON orderitems(order_num,quantity);

EXPLAIN SELECT order_num,prod_id
FROM orderitems
WHERE order_num = 20005
    AND item_price > 9  
ORDER BY quantity DESC
LIMIT 1;

DROP INDEX fk_orderitems_nq
ON orderitems;


#双表(一般左联结给右表加索引，右联结给左表加索引)
#type为all
EXPLAIN
SELECT *
FROM customers
LEFT JOIN orders ON customers.cust_id = orders.cust_id;

ALTER TABLE orders ADD INDEX O (cust_id);

EXPLAIN
SELECT *
FROM customers
LEFT JOIN orders ON customers.cust_id = orders.cust_id;
  
#删除外键约束
SHOW CREATE TABLE orders;
ALTER TABLE orders DROP FOREIGN KEY fk_orders_customers;

DROP INDEX O 
ON orders;

ALTER TABLE customers
ADD INDEX C (cust_id);

EXPLAIN
SELECT *
FROM customers
LEFT JOIN orders ON customers.cust_id = orders.cust_id;

DROP INDEX C
ON customers;

EXPLAIN
SELECT *
FROM customers
RIGHT JOIN orders ON customers.cust_id = orders.cust_id;

ALTER TABLE customers
ADD INDEX C (cust_id);

EXPLAIN
SELECT *
FROM customers
RIGHT JOIN orders ON customers.cust_id = orders.cust_id;


#三表
EXPLAIN
SELECT *
FROM customers
LEFT JOIN orders ON customers.cust_id = orders.cust_id
LEFT JOIN orderitems ON orders.order_num = orderitems.order_num;

ALTER TABLE orders
ADD INDEX O (cust_id);

EXPLAIN
SELECT *
FROM customers
LEFT JOIN orders ON customers.cust_id = orders.cust_id
LEFT JOIN orderitems ON orders.order_num = orderitems.order_num;

#左联结加索引在左表无作用
ALTER TABLE customers
ADD INDEX C (cust_id);

EXPLAIN
SELECT *
FROM customers
LEFT JOIN orders ON customers.cust_id = orders.cust_id
LEFT JOIN orderitems ON orders.order_num = orderitems.order_num;

DROP INDEX C 
ON customers;

