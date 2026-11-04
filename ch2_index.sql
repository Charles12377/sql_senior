/*

是什么：
    索引是MySQL高效获取数据的数据结构，目的在于提高效率
    可以理解为‘排好序的快速查找数据结构’
    会影响到where（过滤/查找）和order by（排序）
    数据库系统还维护着满足特定查找算法的数据结构，这些数据结构以某种方式指向数据，
    这样就可以在这种数据结构的基础上实现高级查找算法，这种数据结构就是索引。

优势：
    提高数据检索的效率，降低数据库的IO成本
    通过索引列对数据进行排序，降低了数据排序的成本，降低了CPU的消耗

劣势：
    索引也是一张表，保存了主键和索引字段，并指向实体表的记录，所以索引列也是要占用空间的
    虽然索引提高了查询速度，但也会降低更新表的速度，如insert，update，delete
    索引只是提高效率的一个因素，如果你的MySQL有大数据量的表，就需要花时间研究建立最优秀的索引

分类：

    单值索引：
        一个索引只包含单个列，一个表可以有多个单值索引
    唯一索引：
        索引列的值必须唯一，但允许有空值
    复合索引：
        一个索引包含多个列

结构：
    BTree
    哈希

EXPLAIN:
    id:操作的优先级，数值越大优先级越高
    select_type：该查询块的类型
    table：显示这一行的数据属于哪一张表的
    type：单表的读取方式（system>const>eq_ref>ref>range>index>ALL）

*/
EXPLAIN SELECT *
FROM customers,orderitems,orders;

EXPLAIN SELECT customers.*
FROM customers
WHERE cust_id IN (
    SELECT cust_id
    FROM orders
    WHERE order_num IN (
        SELECT order_num
        FROM orderitems
    )
);

#MySQL优化器会自动优化查询逻辑
EXPLAIN SELECT customers.*
FROM customers
WHERE cust_id NOT IN (
    SELECT cust_id
    FROM orders
    WHERE order_num NOT IN (
        SELECT order_num
        FROM orderitems
    )
);

EXPLAIN SELECT *
FROM (
    SELECT order_num
    FROM orderitems
) AS t_1,orders,customers
WHERE t_1.order_num = orders.order_num
    AND orders.cust_id = customers.cust_id;

EXPLAIN SELECT * FROM(
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