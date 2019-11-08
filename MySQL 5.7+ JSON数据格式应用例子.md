```sql
-- http://www.mamicode.com/info-detail-1414862.html
-- https://dev.mysql.com/doc/refman/5.7/en/json-search-functions.html
-- select version();  -- 5.7.23-log
-- JSON_TYPE 函数：显示当前JSON字符串的类型
select json_type('"hello"'); -- STRING 
select json_type('["Java","PHP"]'); -- ARRAY 
select json_type('{"name": "yadong.zhang"}'); -- OBJECT 
-- JSON_ARRAY 函数： 将数组对象转换为json数组
select json_array(1,"yadong.zhang"); -- [1, "yadong.zhang"]
-- JSON_OBJECT 函数：将对象转换为json格式数据
select json_object("key","value"); -- {"key": "value"}
-- JSON_QUOTE 函数：将字符串转为json
select json_quote('{"name": "yadong.zhang"}'); -- "{\"name\": \"yadong.zhang\"}"
-- JSON_UNQUOTE  函数：转换为json字符串
select JSON_UNQUOTE('{\"name\": \"yadong.zhang\"}'); -- {"name": "yadong.zhang"}
-- JSON_MERGE 函数：合并JSON字符串
select JSON_MERGE('{"name": "yadong.zhang"}', '{"age": "18"}'); -- {"age": "18", "name": "yadong.zhang"}
-- JSON_VALID 函数：判断JSON格式是否有效
select JSON_VALID('{"name": "yadong.zhang"}'); -- 1
select JSON_VALID('{"name": "yadong.zhang"');  -- 0
select JSON_VALID(null);  -- NULL 
-- JSON_EXTRACT 函数：提取JSON属性
SELECT JSON_EXTRACT('{"name":"yadong.zhang","age": "18"}' ,'$.name'); -- "yadong.zhang"
-- JSON_SET 函数：插入或更新JSON属性。有则改之无则加勉
SELECT JSON_SET('{"name":"yadong.zhang","age": "18"}', '$.age', 28, '$.gender', '男'); -- {"age": 28, "name": "yadong.zhang", "gender": "男"}
-- JSON_INSERT 函数：添加JSON属性
SELECT JSON_INSERT('{"name":"yadong.zhang","age": "18"}' ,"$.email","yadong.zhang0415@gmail.com"); -- {"age": "18", "name": "yadong.zhang", "email": "yadong.zhang0415@gmail.com"}
-- JSON_REPLACE 函数：修改JSON属性
SELECT JSON_REPLACE('{"name":"yadong.zhang","age": "18"}' ,"$.age","28","$.name","码一码"); -- {"age": "28", "name": "码一码"}
-- JSON_REMOVE 函数：删除JSON属性
SELECT JSON_REMOVE('{"name":"yadong.zhang","age": "18"}' ,"$.age"); -- {"name": "yadong.zhang"}
-- JSON_APPEND 函数：向列表中追加JSON属性
-- This function was renamed to JSON_ARRAY_APPEND() in MySQL 5.7.9; the alias JSON_APPEND() is now deprecated in MySQL 5.7, and is removed in MySQL 8.0.
-- JSON_ARRAY_APPEND：同JSON_APPEND
SELECT JSON_ARRAY_APPEND('["Java","PHP"]' , "$[1]","Python"); -- ["Java", ["PHP", "Python"]]
-- JSON_ARRAY_INSERT：往数组指定位置插入参数
SELECT JSON_ARRAY_INSERT('["Java","PHP"]' , "$[1]","Python"); -- ["Java", "Python", "PHP"]
-- JSON_CONTAINS：json中指定属性是否包含内容
SELECT JSON_CONTAINS('{"name":"yadong.zhang","age": 18}', "18", "$.age"); -- 1
-- 该语句返回0，原因参考：
-- https://dev.mysql.com/doc/refman/5.7/en/json-search-functions.html#function_json-contains
-- A candidate scalar is contained in a target scalar if and only if they are comparable and are equal. Two scalar values are comparable if they have the same JSON_TYPE() types, with the exception that values of types INTEGER and DECIMAL are also comparable to each other.
SELECT JSON_CONTAINS('{"name":"yadong.zhang","age": "18"}', "18", "$.age"); -- 0
-- JSON_KEYS：返回key列表
SELECT JSON_KEYS('{"name":"yadong.zhang","age": 18}'); -- ["age", "name"]
-- JSON_LENGTH：返回key个数
SELECT JSON_LENGTH('{"name":"yadong.zhang","age": 18}'); -- 2


-- 列名->"$.key" 获取json字段的某个属性
select config->'$.name' from ilive_project; -- "yadong.zhang"
-- 列名->>"$.key" 获取json字段的某个属性转移后的内容
select config->>'$.name' from ilive_project; -- yadong.zhang
-- ->> 等同于JSON_UNQUOTE(JSON_EXTRACT()).
select JSON_UNQUOTE(JSON_EXTRACT(config, '$.name')) from ilive_project; -- yadong.zhang

```