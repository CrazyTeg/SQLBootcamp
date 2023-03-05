-- 00 Please create 2 Database Views (with similar attributes like the original table) based on simple filtering
-- of gender of persons. Set the corresponding names for the database views: v_persons_female and v_persons_male.

create view v_persons_female as select * from person where gender = 'female';
create view v_persons_male as select * from person WHERE gender = 'male';

-- 01 Please use 2 Database Views from Exercise #00 and write SQL to get female and male person names in one list. Please set the order by person name.

select name from v_persons_female 
union
select name from v_persons_male
order by name;

-- 02 Please create a Database View (with name v_generated_dates) which should be “store” generated dates from 1st to 31th of January 2022 in DATE type.
-- Don’t forget about order for the generated_date column.

create view v_generated_dates as select 
date (format) generated_date
from generate_series('2022-01-01'::date, '2022-01-31', '1 day') as format
order by 1;

-- 03 Please write a SQL statement which returns missing days for persons’ visits in January of 2022.
-- Use v_generated_dates view for that task and sort the result by missing_date column.

select v_gen_.generated_date as missing_date from v_generated_dates as v_gen_
left join person_visits as person_v on v_gen_.generated_date = person_v.visit_date
where person_v.person_id is null
order by missing_date;

-- 04 Please write a SQL statement which satisfies a formula (R - S)U(S - R) .
-- Where R is the person_visits table with filter by 2nd of January 2022, S is also person_visits table but with a different
-- filter by 6th of January 2022. Please make your calculations with sets under the person_id column and this column will be alone in a result.
-- The result please sort by person_id column and your final SQL please present in v_symmetric_union (*) database view.
-- (*) to be honest, the definition “symmetric union” doesn’t exist in Set Theory. This is the author's interpretation,
-- the main idea is based on the existing rule of symmetric difference.

create view v_symmetric_union as 
with R as (select * from person_visits where visit_date = '2022-01-02'),
S as (select * from person_visits where visit_date = '2022-01-06')
select person_id from (select person_id from R except select person_id from S) as sel_r
union
select person_id from (select person_id from S except select person_id from R) as sel_s
order by 1

-- 05 Please create a Database View v_price_with_discount that returns a person's orders with person names,
-- pizza names, real price and calculated column discount_price (with applied 10% discount and satisfies
-- formula price - price*0.1). The result please sort by person name and pizza name and make a round for discount_price column to integer type.

create view v_price_with_discount as
	(select pers_.name, menu_.pizza_name, menu_.price, round(menu_.price - menu_.price * 0.1) 
	from person as pers_ left join person_order as person_o on pers_.id = person_id
	left join menu as menu_ on menu_.id = person_o.menu_id)
order by pers_.name, menu_.pizza_name;

-- 06 Please create a Materialized View mv_dmitriy_visits_and_eats (with data included) based on SQL statement that finds
-- the name of pizzeria Dmitriy visited on January 8, 2022 and could eat pizzas for less than 800 rubles (this SQL you can find out at Day #02 Exercise #07).
-- To check yourself you can write SQL to Materialized View mv_dmitriy_visits_and_eats and compare results with your previous query.

create MATERIALIZED view mv_dmitriy_visits_and_eats as(
    select pizz_.name as pizzeria_name from person as pers_
	join person_visits as person_v on pers_.id = person_v.person_id
	join pizzeria as pizz_ on pizz_.id = person_v.pizzeria_id
	join menu as menu_ on menu_.pizzeria_id = person_v.pizzeria_id
	where pers_.name = 'Dmitriy' and person_v.visit_date = '2022-01-08' and menu_.price < 800);

-- 07 Let's refresh data in our Materialized View mv_dmitriy_visits_and_eats from exercise #06. Before this action,
-- please generate one more Dmitriy visit that satisfies the SQL clause of Materialized View except pizzeria that we can see in a result from exercise #06.
-- After adding a new visit please refresh a state of data for mv_dmitriy_visits_and_eats.

insert into person_visits (id, person_id, pizzeria_id, visit_date)
values ((select max(id) from person_visits)+1, (select id from person where name = 'Dmitriy'),
	(select pers_.id from menu as menu_ left join pizzeria as pers_ on menu_.pizzeria_id = pers_.id
	left join mv_dmitriy_visits_and_eats as eat on true
	where eat.pizzeria_name != pers_.name and menu_.price < 800 limit 1), '2022-01-08');
refresh MATERIALIZED view mv_dmitriy_visits_and_eats;

-- 08 After all our exercises were born a few Virtual Tables and one Materialized View. Let’s drop them!

drop MATERIALIZED view mv_dmitriy_visits_and_eats;
drop view v_persons_female,
    v_persons_male, v_generated_dates,
    v_symmetric_union,
    v_price_with_discount;



