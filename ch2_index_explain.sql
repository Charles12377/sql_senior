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
        sysetem:表只有一行记录（相当于系统表）
        const：表示使用索引一次就找到了
        eq_ref:唯一性索引扫描，对于每个索引键，表中只有一条记录与之匹配。
        ref:非唯一性索引扫描，返回匹配某个单独值得所有行
        range：只检索给定范围的行，使用一个索引来选择行
        index：遍历索引树（全索引扫描）
        all:全表扫描
    possible_keys:可能应用于这张表中的索引，一个或多个，不一定被实际使用
    key：实际使用的索引（若查询中使用了覆盖索引，则该索引仅出现在key列表中
    key_len:索引字段的最大可能长度，并非实际使用长度，在不损失精确性的前提下，长度越短越好
    ref：显示索引那一列被使用了，如果可能的话，是一个常数，哪些列或常量被用于查找索引列上的值
    rows；根据表统计信息及索引选用情况，大致估算出找到所需的纪录所需要读取的行数
    extra：包含不适合在其他列中显示但十分重要的信息
        using filesort：说明MySQL对数据使用一个外部的索引排序，而不是按照表内的索引顺序进行读取
        using temporary:使用临时表存储中间结果，MySQL在对查询结果排序时使用临时表
        using index：表示相应的select操作使用了覆盖索引，避免访问了表的数据行，效率不错
        


*/
SELECT @@optimizer_switch\G

#关闭优化器
SET SESSION optimizer_switch = 'derived_merge=off,semijoin=off,materialization=off';
SET SESSION optimizer_prune_level = 0;
SET SESSION optimizer_search_depth = 62;

#select_type （IN 子查询）
EXPLAIN SELECT cust_name
FROM customers
WHERE cust_id IN(
    SELECT cust_id
    FROM orders
    WHERE order_num IN(
        SELECT order_num
        FROM orderitems
        WHERE prod_id = 'TNT2'
    )
)

#全表扫描 ALL（没有索引命中）
EXPLAIN SELECT * 
FROM customers 
WHERE cust_city = 'Detroit';

#const 单次索引查询
EXPLAIN SELECT * 
FROM customers 
WHERE cust_id = 10001;

# eq_ref 等值主键查询
#内联结
EXPLAIN SELECT *
FROM customers
JOIN orders ON customers.cust_id = orders.cust_id;
#三表关联
EXPLAIN SELECT *
FROM customers
JOIN orders ON customers.cust_id = orders.cust_id
JOIN orderitems ON orders.order_num = orderitems.order_num;
#强制按书写顺序驱动
EXPLAIN SELECT *
FROM customers
STRAIGHT_JOIN orders ON customers.cust_id = orders.cust_id
STRAIGHT_JOIN orderitems ON orders.order_num = orderitems.order_num;

#ref 普通索引查询
EXPLAIN SELECT *
FROM products
WHERE vend_id = 1001;

#range 范围查询（主键范围）
EXPLAIN SELECT * 
FROM orders 
WHERE order_num 
BETWEEN 20005 AND 20008;

#index 遍历索引树查询
EXPLAIN SELECT cust_id
FROM customers;

#key,possible_key
#没用索引
EXPLAIN SELECT *
FROM customers;
#主键索引
EXPLAIN SELECT *
FROM customers
WHERE cust_id = 10001;
#可能用到索引但实际不使用
EXPLAIN SELECT *
FROM orders
WHERE order_num > 20009;
#可能使用多个索引但实际只使用一个
EXPLAIN SELECT orders.*
FROM customers,orders,orderitems
WHERE customers.cust_id = orders.cust_id
    AND orders.order_num = orderitems.order_num;
#可能不使用索引但实际使用了
EXPLAIN SELECT vend_id FROM products;


#练习filesort，Extra出现 Using filesort
EXPLAIN SELECT * FROM products 
ORDER BY prod_name;
EXPLAIN SELECT * FROM products 
ORDER BY prod_id;

# temporary
EXPLAIN SELECT cust_id,SUM(cust_id)
FROM customers
GROUP BY cust_id;
EXPLAIN SELECT cust_state,SUM(cust_state)
FROM customers
GROUP BY cust_state;