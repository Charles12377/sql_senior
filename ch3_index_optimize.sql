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

CREATE INDEX fk_orderitem_npq 
ON orderitems(order_num,item_price,quantity);

#范围会导致索引失效，还是有filesort
EXPLAIN SELECT order_num,prod_id
FROM orderitems
WHERE order_num = 20005
    AND item_price > 9  
ORDER BY quantity DESC
LIMIT 1;

DROP INDEX fk_orderitem_npq
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