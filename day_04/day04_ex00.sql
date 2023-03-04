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







