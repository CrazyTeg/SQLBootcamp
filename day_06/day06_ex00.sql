-- 00 Let’s expand our data model to involve a new business feature.
-- Every person wants to see a personal discount and every business wants to be closer for clients.
-- Please think about personal discounts for people from one side and pizzeria restaurants from other.
-- Need to create a new relational table (please set a name person_discounts) with the next rules.

-- set id attribute like a Primary Key (please take a look on id column in existing tables and choose the same data type)
-- set for attributes person_id and pizzeria_id foreign keys for corresponding tables (data types should be the same like for id columns in corresponding parent tables)
-- please set explicit names for foreign keys constraints by pattern fk_{table_name}_{column_name},  for example fk_person_discounts_person_id

-- add a discount attribute to store a value of discount in percent. Remember, discount value can be a number with floats
-- (please just use numeric data type). So, please choose the corresponding data type to cover this possibility.

create table person_discounts(id bigint primary key,
							 person_id bigint not null,
							 pizzeria_id bigint not null,
							 discount numeric not null,
							 constraint fk_person_visits_person_id foreign key (person_id) references person(id),
							 constraint fk_person_visits_pizzeria_id foreign key (pizzeria_id) references pizzeria(id)
							 );

							 
---- 01 Actually, we created a structure to store our discounts and we are ready to go further and fill our
-- person_discounts table with new records.
--So, there is a table person_order that stores the history of a person's orders. Please write a DML statement
-- (INSERT INTO ... SELECT ...) that makes  inserts new records into person_discounts table based on the next rules.

--take aggregated state by person_id and pizzeria_id columns

-- calculate personal discount value by the next pseudo code:
-- if “amount of orders” = 1 then “discount” = 10.5  else if “amount of orders” = 2 then 
-- “discount” = 22 else  “discount” = 30

-- to generate a primary key for the person_discounts table please use  SQL construction below (this construction is from
-- the WINDOW FUNCTION  SQL area).
--   ... ROW_NUMBER( ) OVER ( ) AS id ...

insert into person_discounts
select row_number() over(), person_o.person_id, menu_.pizzeria_id,
(case when count(menu_.pizzeria_id) = 1 then 10.5
      when count(menu_.pizzeria_id) = 2 then 22
      else 30 end)
from person_order as person_o
left join menu as menu_ on menu_.id = person_o.menu_id
group by person_o.person_id, menu_.pizzeria_id;

select * from person_discounts;

-- 02 Please write a SQL statement that returns orders with actual price and price with applied discount
-- for each person in the corresponding pizzeria restaurant and sort by person name, and pizza name.

select p.name, menu_.pizza_name, menu_.price, round(menu_.price - (menu_.price * (pd.discount/100)), 0) as discount_price, pz.name
from person_discounts as pd join person as p on pd.person_id = p.id
join menu as menu_ on menu_.pizzeria_id = pd.pizzeria_id
join pizzeria as pz on menu_.pizzeria_id = pz.id
order by p.name, menu_.pizza_name

-- 03 Actually, we have to make improvements to data consistency from one side and performance tuning from the other side.
-- Please create a multicolumn unique index (with name idx_person_discounts_unique) that prevents duplicates of pair values person and pizzeria identifiers.
-- After creation of a new index, please provide any simple SQL statement that shows proof of index usage (by using EXPLAIN ANALYZE).
-- The example of “proof” is below
-- ...
--   Index Scan using idx_person_discounts_unique on person_discounts
-- ...

set enable_bitmapscan  = off;
set enable_seqscan = off;
create unique index idx_person_discounts_unique on person_discounts (person_id, pizzeria_id);
explain analyze select person_id, pizzeria_id from person_discounts




