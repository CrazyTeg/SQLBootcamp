-- 00 Please create a simple BTree index for every foreign key in our database.
-- The name pattern should satisfy the next rule “idx_{table_name}_{column_name}”.
-- For example, the name BTree index for the pizzeria_id column in the menu table is idx_menu_pizzeria_id.

create index idx_menu_pizzeria_id on menu(pizzeria_id);
create index idx_person_order_person_id on person_order(person_id);
create INDEX idx_person_order_menu_id on person_order(menu_id);
create index idx_person_visits_person_id on person_visits(person_id);
create index idx_person_visits_pizzeria_id on person_visits(pizzeria_id);













