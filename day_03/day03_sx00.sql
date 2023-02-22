-- 00 Please write a SQL statement which returns a list of pizza names, pizza prices, pizzerias
-- names and dates of visit for Kate and for prices in range from 800 to 1000 rubles.
-- Please sort by pizza, price and pizzeria names.

select menu_.pizza_name, menu_.price, pizzeria_.name as pizzeria_name, person_v.visit_date from person as person_
    join person_visits as person_v on person_.id = person_v.person_id
    join pizzeria as pizzeria_ on pizzeria_.id = person_v.pizzeria_id
    join menu as menu_ on menu_.pizzeria_id = pizzeria_.id
where person_.name = 'Kate' and menu_.price between 800 and 1000
order by menu_.pizza_name, menu_.price, pizzeria_.name;
