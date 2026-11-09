#测试用，永远不要在生产环境开启该功能

SET GLOBAL GENERAL_log = 1;

SET GLOBAL log_output='table';

SELECT *
FROM customers;

SELECT *
FROM mysql.general_log;

SET GLOBAL GENERAL_log = 0;

SHOW VARIABLES LIKE '%general_log%';