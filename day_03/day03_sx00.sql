-- 00 Please write a SQL statement which returns a list of pizza names, pizza prices, pizzerias
-- names and dates of visit for Kate and for prices in range from 800 to 1000 rubles.
-- Please sort by pizza, price and pizzeria names.

select menu_.pizza_name, menu_.price, pizzeria_.name as pizzeria_name, person_v.visit_date from person as person_
    join person_visits as person_v on person_.id = person_v.person_id
    join pizzeria as pizzeria_ on pizzeria_.id = person_v.pizzeria_id
    join menu as menu_ on menu_.pizzeria_id = pizzeria_.id
where person_.name = 'Kate' and menu_.price between 800 and 1000
order by menu_.pizza_name, menu_.price, pizzeria_.name;

-- 01 Please find all menu identifiers which are not ordered by anyone. The result should be sorted by identifiers.

select menu_.id as menu_id from menu as menu_ 
left join person_order as person_o on menu_.id = person_o.menu_id
where person_o.person_id is null
order by menu_id;

-- 02 Please use SQL statement from Exercise #01 and show pizza names from pizzeria which are not ordered by anyone,
-- including corresponding prices also. The result should be sorted by pizza name and price.

select menu_.pizza_name, menu_.price, pizzeria_.name as pizzeria_name from menu as menu_
    left join person_order as person_o on menu_.id = person_o.menu_id
    left join pizzeria as pizzeria_ on menu_.pizzeria_id = pizzeria_.id
where person_o.person_id is null
order by menu_.pizza_name, menu_.price;

-- 03 Please find a union of pizzerias that have been visited either women or men.
-- Other words, you should find a set of pizzerias names have been visited by females only and make "UNION"
-- operation with set of pizzerias names have been visited by males only. Please be aware with word “only” for
-- both genders. For any SQL operators with sets save duplicates (UNION ALL, EXCEPT ALL, INTERSECT ALL constructions).
-- Please sort a result by the pizzeria name.

with pizz_famele as (select pizz_.name from pizzeria pizz_
    join person_visits pv on pizz_.id = pv.pizzeria_id
    join person p on pv.person_id = p.id
    where p.gender = 'female'),
pizz_male as (select pizz_.name from pizzeria pizz_
    join person_visits pv on pizz_.id = pv.pizzeria_id
    join person p on pv.person_id = p.id
    where p.gender = 'male'),
pizzeria_1 as (select * from pizz_famele except all select * from pizz_male),
pizzeria_2 as (select * from pizz_male except all select * from pizz_famele)
select * from pizzeria_1 union all select * from pizzeria_2
order by 1;

-- 04 Please find a union of pizzerias that have orders either from women or  from men. Other words, you should
-- find a set of pizzerias names have been ordered by females only and make "UNION" operation with set of pizzerias
--names have been ordered by males only. Please be aware with word “only” for both genders. For any SQL operators
--with sets don’t save duplicates (UNION, EXCEPT, INTERSECT).  Please sort a result by the pizzeria name.

with pizz_famele as (select pizz_.name from person as person_
    left join person_order as person_o on person_.id = person_o.person_id
    left join menu as menu_ on menu_.id = person_o.menu_id		
    left join pizzeria as pizz_ on pizz_.id = menu_.pizzeria_id 
    where person_.gender = 'female'),
pizz_male as (select pizz_.name from person as person_
    left join person_order as person_o on person_.id = person_o.person_id
    left join menu as menu_ on menu_.id = person_o.menu_id		
    left join pizzeria as pizz_ on pizz_.id = menu_.pizzeria_id
    where person_.gender = 'male'),
pizzeria_1 as (select * from pizz_famele except select * from pizz_male),
pizzeria_2 as (select * from pizz_male except select * from pizz_famele)
select * from pizzeria_1 union select * from pizzeria_2
order by 1;

-- 05 Please write a SQL statement which returns a list of pizzerias which Andrey visited but did not make any orders.
-- Please order by the pizzeria name.

with vizit_andrey as(select pizz_.name from person as p
    left join person_visits as person_v on p.id = person_v.person_id
    left join pizzeria as pizz_ on pizz_.id = person_v.pizzeria_id
where p.name = 'Andrey'),

order_andrey as (select pizz_.name from person as p
    left join person_order as person_o on p.id = person_o.person_id
    left join menu as m on m.id = person_o.menu_id
    left join pizzeria as pizz_ on pizz_.id = m.pizzeria_id
where p.name = 'Andrey'),

selection_pv as(select * from vizit_andrey except
        select * from order_andrey),
selection_po as(select * from order_andrey except
        select * from vizit_andrey)
select name as pizzeria_name from selection_pv
union
select name as pizzeria_name from selection_po
order by pizzeria_name;

-- 06 Please find the same pizza names who have the same price, but from different pizzerias.
-- Make sure that the result is ordered by pizza name.

with selection_pizza as (select menu_.pizza_name, pizz_.name, menu_.price, pizz_.id, menu_.pizzeria_id from menu as menu_
	left join pizzeria as pizz_ on menu_.pizzeria_id = pizz_.id)
select selpz_1.pizza_name, selpz_1.name, selpz_2.name, selpz_1.price from selection_pizza as selpz_1
left join selection_pizza as selpz_2 on
selpz_1.pizza_name = selpz_2.pizza_name and
selpz_1.price = selpz_2.price

where selpz_1.pizza_name = selpz_2.pizza_name and
selpz_1.price = selpz_2.price and
selpz_1.id > selpz_2.id
order by 1;

-- 07 Please register a new pizza with name “greek pizza” (use id = 19) with price 800 rubles in “Dominos” restaurant (pizzeria_id = 2).
-- Warning: this exercise will probably be the cause  of changing data in the wrong way. Actually, you can restore
-- the initial database model with data from the link in the “Rules of the day” section.

insert into menu (id, pizzeria_id, pizza_name, price)
values (19, 2, 'greek pizza', 800);

-- 08 Please register a new pizza with name “sicilian pizza” (whose id should be calculated by formula is
-- “maximum id value + 1”) with a price of 900 rubles in “Dominos” restaurant (please use internal query to get
--identifier of pizzeria).
-- Warning: this exercise will probably be the cause  of changing data in the wrong way. Actually, you can restore
--the initial database model with data from the link in the “Rules of the day” section and replay script from Exercise 07.

insert into menu (id, pizzeria_id, pizza_name, price)
values ((select max(id)+1 from menu), (select id from pizzeria where name = 'Dominos' ), 'sicilian pizza', 900);

-- 09 Please register new visits into Dominos restaurant from Denis and Irina on 24th of February 2022.
-- Warning: this exercise will probably be the cause  of changing data in the wrong way. Actually, you can restore
--the initial database model with data from the link in the “Rules of the day” section and replay script from Exercises 07 and 08..

insert into person_visits (id, person_id, pizzeria_id, visit_date)
values ((select max(id) + 1 from person_visits), (select id from person where name = 'Denis'),
	(select id from pizzeria where name = 'Dominos' ), '2022-02-24'),
	((select max(id) + 2 from person_visits), (select id from person where name = 'Irina'),
	(select id from pizzeria where name = 'Dominos' ), '2022-02-24');







