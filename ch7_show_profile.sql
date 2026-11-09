SHOW VARIABLES LIKE 'profiling';

SET profiling = ON;

SHOW VARIABLES LIKE 'profiling';

SELECT *
FROM orderitems
WHERE item_price >= 10
ORDER BY quantity;

SELECT *
FROM orderitems
WHERE item_price >= 10
ORDER BY quantity,item_price;

SELECT *
FROM orderitems
ORDER BY quantity;

SELECT *
FROM orderitems
WHERE quantity >= 10
ORDER BY quantity;

SHOW PROFILES;

SHOW PROFILE CPU,BLOCK IO FOR QUERY 1;

SHOW PROFILE CPU,BLOCK IO FOR QUERY 4;