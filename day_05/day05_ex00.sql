-- 00 Please create a simple BTree index for every foreign key in our database.
-- The name pattern should satisfy the next rule �idx_{table_name}_{column_name}�.
-- For example, the name BTree index for the pizzeria_id column in the menu table is idx_menu_pizzeria_id.

create index idx_menu_pizzeria_id on menu(pizzeria_id);
create index idx_person_order_person_id on person_order(person_id);
create INDEX idx_person_order_menu_id on person_order(menu_id);
create index idx_person_visits_person_id on person_visits(person_id);
create index idx_person_visits_pizzeria_id on person_visits(pizzeria_id);

-- 01 Before further steps please write a SQL statement that returns pizzas� and corresponding pizzeria names.
-- Let�s provide proof that your indexes are working for your SQL.
-- The sample of proof is the output of the EXPLAIN ANALYZE command.
-- Please take a look at the sample output command.
-- ...
--   Index Scan using idx_menu_pizzeria_id on menu m  (...)
-- ...
-- Hint: please think why your indexes are not working in a direct way and what should we do to enable it?

set enable_bitmapscan = off;  -- ��������� ������������� ������ ������������ �� ������� �����.
set enable_seqscan = off;  -- ��������� ������������� ������������� ������ ����������������� ������������.
explain analyse select menu_.pizza_name, pizzeria_.name from menu as menu_
join pizzeria as pizzeria_ on menu_.pizzeria_id = pizzeria_.id;

-- 02 Please create a functional B-Tree index with name idx_person_name for the column name of the person table.
-- Index should contain person names in upper case.
-- Please write and provide any SQL with proof (EXPLAIN ANALYZE) that index idx_person_name is working.

create index idx_person_name on person (upper(name));
explain analyze select name from person where upper(name) is not null;

-- 03 Please create a better multicolumn B-Tree index with the name idx_person_order_multi for the SQL statement below.
--    SELECT person_id, menu_id,order_date
--    FROM person_order
--    WHERE person_id = 8 AND menu_id = 19;
-- The EXPLAIN ANALYZE command should return  the next pattern. Please be attention on "Index Only Scan" scanning!
-- ...  Index Only Scan using idx_person_order_multi on person_order ...  
-- Please provide any SQL with proof (EXPLAIN ANALYZE) that index idx_person_order_multi is working.

create index idx_person_order_multi on person_order (person_id, menu_id, order_date);
EXPLAIN ANALYZE select person_id, menu_id,order_date from person_order
where person_id = 8 and menu_id = 19;

-- 04 Please create a unique BTree index with the name idx_menu_unique on the menu table for  pizzeria_id and pizza_name columns.
-- Please write and provide any SQL with proof (EXPLAIN ANALYZE) that index idx_menu_unique is working.

create unique index idx_menu_unique on menu (pizzeria_id, pizza_name);
explain analyze select pizzeria_id, pizza_name from menu;

-- 05 Please create a partial unique BTree index with the name idx_person_order_order_date on the person_order table for person_id and menu_id attributes with partial uniqueness for order_date column for date �2022-01-01�.
-- The EXPLAIN ANALYZE command should return  the next pattern
-- ... Index Only Scan using idx_person_order_order_date on person_order �

create unique index idx_person_order_order_date on person_order (person_id, menu_id)
where order_date = '2022-01-01';
explain analyze select person_id, menu_id from person_order
where order_date = '2022-01-01';




