-- 00 Please create a simple BTree index for every foreign key in our database.
-- The name pattern should satisfy the next rule Уidx_{table_name}_{column_name}Ф.
-- For example, the name BTree index for the pizzeria_id column in the menu table is idx_menu_pizzeria_id.

create index idx_menu_pizzeria_id on menu(pizzeria_id);
create index idx_person_order_person_id on person_order(person_id);
create INDEX idx_person_order_menu_id on person_order(menu_id);
create index idx_person_visits_person_id on person_visits(person_id);
create index idx_person_visits_pizzeria_id on person_visits(pizzeria_id);

-- 01 Before further steps please write a SQL statement that returns pizzasТ and corresponding pizzeria names.
-- LetТs provide proof that your indexes are working for your SQL.
-- The sample of proof is the output of the EXPLAIN ANALYZE command.
-- Please take a look at the sample output command.
-- ...
--   Index Scan using idx_menu_pizzeria_id on menu m  (...)
-- ...
-- Hint: please think why your indexes are not working in a direct way and what should we do to enable it?

set enable_bitmapscan = off;  -- отключаем использование планов сканировани€ по битовой карте.
set enable_seqscan = off;  -- отключаем использование планировщиком планов последовательного сканировани€.
explain analyse select menu_.pizza_name, pizzeria_.name from menu as menu_
join pizzeria as pizzeria_ on menu_.pizzeria_id = pizzeria_.id;

-- 02 Please create a functional B-Tree index with name idx_person_name for the column name of the person table.
-- Index should contain person names in upper case.
-- Please write and provide any SQL with proof (EXPLAIN ANALYZE) that index idx_person_name is working.

create index idx_person_name on person (upper(name));
explain analyze select name from person where upper(name) is not null;







