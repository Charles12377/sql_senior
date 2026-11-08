#小表驱动大表
#左表大于右表用IN
SELECT *
FROM customers
WHERE cust_id IN (
    SELECT cust_id
    FROM orders
);
#左表小于右表用EXISTS
SELECT *
FROM orders
WHERE EXISTS (
    SELECT 1
    FROM customers
    WHERE orders.cust_id = customers.cust_id 
);


#order by关键字优化

/*

提高order by速度；
使用覆盖索引，不用select *
尝试提高sort_buffer_size
尝试提高max_length_for_sort_data

*/


EXPLAIN
SELECT *
FROM orderitems
WHERE item_price >= 10
ORDER BY item_price;

SHOW INDEX
FROM orderitems;

DROP INDEX fk_orderitems_npq
ON orderitems;

ALTER TABLE orderitems
ADD INDEX fk_orderitems_pq (item_price,quantity);

EXPLAIN
SELECT *
FROM orderitems
WHERE item_price >= 10
ORDER BY item_price;

EXPLAIN
SELECT *
FROM orderitems
WHERE item_price >= 10
ORDER BY item_price,quantity;

#有filesort
EXPLAIN
SELECT *
FROM orderitems
WHERE item_price >= 10
ORDER BY quantity;

EXPLAIN
SELECT *
FROM orderitems
WHERE item_price >= 10
ORDER BY quantity,item_price;

EXPLAIN
SELECT *
FROM orderitems
ORDER BY quantity;

EXPLAIN
SELECT *
FROM orderitems
WHERE quantity >= 10
ORDER BY quantity;

#优化器选择不一致
EXPLAIN
SELECT *
FROM orderitems
WHERE quantity > 10
ORDER BY item_price;
#覆盖索引查找
EXPLAIN
SELECT order_num,item_price
FROM orderitems
WHERE quantity >= 10
ORDER BY item_price;

#MySQL两种排序方式；filesort和index，index效率高
#符合最佳左前缀原则时会使用index，即order by语句使用索引最左前列或where子句与order by子句条件列组合满足索引最前列
#链表本身是单向有序，没法同时满足一个升，一个降，只能获取数据后排序，有filesort
EXPLAIN
SELECT order_num,item_price
FROM orderitems
ORDER BY item_price ASC,quantity DESC;

EXPLAIN
SELECT order_num,item_price
FROM orderitems
WHERE item_price >= 10
ORDER BY quantity;
#where子句与order by子句条件列组合满足最左前缀原则需where使用索引的最左前缀定义为常量
EXPLAIN
SELECT order_num,item_price
FROM orderitems
WHERE item_price = 10
ORDER BY quantity;