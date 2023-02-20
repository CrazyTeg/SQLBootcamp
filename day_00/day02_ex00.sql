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




