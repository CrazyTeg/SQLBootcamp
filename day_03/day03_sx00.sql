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














