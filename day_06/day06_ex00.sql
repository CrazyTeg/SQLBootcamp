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

select * from person_discounts