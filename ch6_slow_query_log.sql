-- Active: 1792671424349@@127.0.0.1@3306@crashcourse
-- Active: 1793507254360@@127.0.0.1@3307@crashcourse7@crashcourse
SHOW VARIABLES LIKE '%slow_query_log%';

SET GLOBAL SLOW_QUERY_LOG = 1;

SHOW VARIABLES LIKE '%slow_query_log%';

SHOW VARIABLES LIKE '%long_query_time%';

SET GLOBAL long_query_time = 3;

#修改的是全局变量，该语句只查询局部变量，要重新连接数据库此可以用该语句查到修改后的结果
SHOW VARIABLES LIKE '%long_query_time%';
#该语句查询全局变量
SHOW GLOBAL VARIABLES LIKE '%long_query_time%';

SELECT SLEEP(4);

#查看慢查询日志在哪个目录
SHOW VARIABLES LIKE 'datadir';

#查看有几条慢SQL
SHOW GLOBAL STATUS LIKE '%Slow_queries%';

