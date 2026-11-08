#全值匹配易导致索引失效（对索引字段做函数，运算，(自动/手动）类型转换）
EXPLAIN
SELECT *
FROM orderitems
WHERE order_num = 20005
    AND upper(prod_id) = 'ANV01'
    AND item_price + 1 = 10.99;

EXPLAIN
SELECT *
FROM orderitems
WHERE quantity >= 5
    AND item_price > 9;

CREATE INDEX fk_orderitems_npq 
ON orderitems(order_num,item_price,quantity);

SHOW INDEX 
FROM orderitems;

#违背最佳左前缀法则（联合索引要求从最左边开始连续匹配）
EXPLAIN
SELECT *
FROM orderitems
WHERE quantity >= 5
    AND item_price > 9;

DROP INDEX fk_orderitems_npq
ON orderitems;

CREATE INDEX fk_orderitems_pq 
ON orderitems(item_price,quantity);

EXPLAIN
SELECT *
FROM orderitems
WHERE quantity >= 5
    AND item_price > 9;

DROP INDEX fk_orderitems_pq
ON orderitems;

CREATE INDEX fk_orderitems_npq 
ON orderitems(order_num,item_price,quantity);

#跳过索引中的列导致索引失效
EXPLAIN
SELECT *
FROM orderitems
WHERE order_num = 20005
    AND quantity >= 5;

EXPLAIN
SELECT *
FROM orderitems
WHERE order_num = 20005
    AND item_price = 5.99
    AND quantity = 10;

#使用范围之后，在其后的检索无法使用索引
EXPLAIN
SELECT *
FROM orderitems
WHERE order_num = 20005
    AND item_price > 5
    AND quantity = 10;

EXPLAIN
SELECT *
FROM orderitems
WHERE order_num = 20005
    AND item_price = 5.99
    AND quantity = 10;

#尽量使用覆盖索引，减少select *
EXPLAIN
SELECT order_num,item_price,quantity
FROM orderitems
WHERE order_num = 20005
    AND item_price = 5.99
    AND quantity = 10;

#在使用!=,>,<时无法使用索引会导致全表扫描
EXPLAIN
SELECT order_num,item_price,quantity
FROM orderitems
WHERE order_num = 20005
    AND item_price > 5
    AND quantity = 10;

EXPLAIN
SELECT order_num
FROM orderitems
WHERE order_num = 20005
    AND item_price = 5.99;

#IS NULL,IS NOT NULL无法使用索引
EXPLAIN
SELECT *
FROM customers
WHERE cust_address IS NULL;

#like句子以通配符开头会全表扫描
EXPLAIN
SELECT *
FROM orderitems
WHERE item_price LIKE '%9';

EXPLAIN
SELECT *
FROM orderitems
WHERE item_price LIKE '9%';

#可以使用覆盖索引避免全表扫描
EXPLAIN
SELECT order_num
FROM orderitems
WHERE item_price LIKE '%9';

#字符串不加单引号索引失效
ALTER TABLE customers
ADD INDEX CZ (cust_zip);
EXPLAIN
SELECT *
FROM customers
WHERE cust_zip = '44444';

EXPLAIN
SELECT *
FROM customers
WHERE cust_zip = 44444;

#少用or，用它连接会导致索引失效
EXPLAIN
SELECT cust_name,cust_zip
FROM customers
WHERE cust_zip = '44444';

EXPLAIN
SELECT cust_name,cust_zip
FROM customers
WHERE cust_zip = '44444' OR cust_name = 'Wascals';