-- Please write a SQL statement which returns a list of pizzerias names with corresponding rating value which have not been visited by persons.

SELECT pizz.name, pizz.rating FROM pizzeria AS pizz
 LEFT JOIN person_visits AS pviz ON pizz.id = pviz.pizzeria_id WHERE pviz.person_id IS NULL;

-- Please write a SQL statement which returns the missing days from 1st to 10th of January 2022 (including all days) for visits  of persons with identifiers 1 or 2.
-- Please order by visiting days in ascending mode. 

SELECT res.date AS check_date FROM generate_series('2022-01-01'::timestamp, '2022-01-10', '1 day') AS res
    LEFT JOIN (SELECT visit_date FROM person_visits
	WHERE person_id = 1 OR person_id = 2) AS person_v
    ON res.date = person_v.visit_date
WHERE person_v.visit_date IS NULL;

-- Please write a SQL statement that returns a whole list of person names visited (or not visited) pizzerias
-- during the period from 1st to 3rd of January 2022 from one side and the whole list of pizzeria names which
--have been visited (or not visited) from the other side.
-- The data sample with needed column names is presented below. Please pay attention to the substitution value
-- ‘-’ for NULL values in person_name and pizzeria_name columns.

SELECT COALESCE(pers.name, '-') AS person_name, person_v.visit_date, COALESCE(pizz.name, '-') AS pizzeria_name
FROM person AS pers
FULL JOIN (SELECT * FROM person_visits
            WHERE visit_date BETWEEN '2022-01-01' AND '2022-01-03') AS person_v
            ON pers.id = person_v.person_id
FULL JOIN (SELECT id, name FROM pizzeria) AS pizz
            ON person_v.pizzeria_id = pizz.id
ORDER BY person_name, person_v.visit_date, pizzeria_name;

-- Let’s return back to Exercise #01, please rewrite your SQL by using the CTE (Common Table Expression)
-- pattern. Please move into the CTE part of your "day generator". The result should be similar like in Exercise #01

WITH value_date AS (SELECT CAST(person_v AS date) AS check_date
    FROM generate_series('2022-01-01'::timestamp, '2022-01-10', '1 day') person_v
), dates AS (SELECT visit_date FROM person_visits WHERE person_id = 1 OR person_id = 2)
SELECT check_date FROM value_date LEFT JOIN dates ON visit_date = check_date
WHERE visit_date IS NULL ORDER BY visit_date;

-- Find full information about all possible pizzeria names and prices to get mushroom or pepperoni
-- pizzas. Please sort the result by pizza name and pizzeria name then. The result of sample data is
-- below (please use the same column names in your SQL statement).

SELECT m_pizz.pizza_name, pizz.name AS pizzeria_name, m_pizz.price FROM menu AS m_pizz
JOIN pizzeria AS pizz ON m_pizz.pizzeria_id = pizz.id
WHERE m_pizz.pizza_name = 'mushroom pizza' OR m_pizz.pizza_name = 'pepperoni pizza'
ORDER BY m_pizz.pizza_name, pizzeria_name;


-- Find names of all female persons older than 25 and order the result by name. The sample of output is presented below.

SELECT name FROM person as old_p WHERE old_p.gender = 'female' AND old_p.age > 25
ORDER BY name;


-- Please find all pizza names (and corresponding pizzeria names using menu table) that Denis or Anna ordered.
-- Sort a result by both columns. The sample of output is presented below.

SELECT menu_p_.pizza_name, pizzer_.name AS pizzeria_name FROM person AS pers_
    JOIN person_order AS pviz_ ON pers_.id = pviz_.person_id
    JOIN menu AS menu_p_ ON pviz_.menu_id = menu_p_.id
    JOIN pizzeria AS pizzer_ ON pizzer_.id = menu_p_.pizzeria_id
WHERE pers_.name = 'Denis' OR pers_.name = 'Anna'
ORDER BY menu_p_.pizza_name, pizzer_.name;

-- Please find the name of pizzeria Dmitriy visited on January 8,
-- 2022 and could eat pizza for less than 800 rubles.

SELECT pizzer_.name AS pizzeria_name FROM person AS pers_
    JOIN person_visits AS pviz_ ON pers_.id = pviz_.person_id
    JOIN pizzeria AS pizzer_ ON pizzer_.id = pviz_.pizzeria_id
    JOIN menu AS m ON m.pizzeria_id = pviz_.pizzeria_id
WHERE pers_.name = 'Dmitriy' AND pviz_.visit_date = '2022-01-08' AND m.price < 800
ORDER BY pizzer_.name;















