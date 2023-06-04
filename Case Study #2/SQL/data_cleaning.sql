-- ****Data Cleaning****

SET search_path = pizza_runner;

select * from runner_orders;

-- Updating and altering runner_orders table
update runner_orders
set cancellation = case when cancellation = 'null' then replace(cancellation, 'null', NULL)
else replace(cancellation, '', NULL)
end 
where cancellation = '' or cancellation = 'null';

update runner_orders
set pickup_time = NULL
where pickup_time = 'null';

update runner_orders
set distance = NULL
where distance = 'null';

update runner_orders
set duration = NULL
where duration = 'null';

UPDATE runner_orders
set distance = TRIM(SUBSTRING(distance,1,POSITION('k' in distance)-1))
where POSITION('k' in distance) != 0;

UPDATE runner_orders
set duration = TRIM(SUBSTRING(duration,1,POSITION('m' in duration)-1))
where POSITION('m' in duration) != 0;

ALTER TABLE runner_orders
ALTER COLUMN distance TYPE float
USING distance::float;

ALTER TABLE runner_orders
ALTER COLUMN duration TYPE float
USING duration::float;

ALTER TABLE runner_orders
ALTER COLUMN pickup_time TYPE timestamp
USING pickup_time::timestamp;

---------------------------------------------------------
select * from customer_orders;
-- Updating and altering customer_orders

ALTER TABLE customer_orders
ALTER COLUMN order_time TYPE timestamp
USING order_time::timestamp;

update pizza_runner.customer_orders
set exclusions = case when exclusions = 'null' then replace(exclusions, 'null', NULL)
else replace(exclusions, '', NULL)
end 
where exclusions = '' or exclusions = 'null';

update pizza_runner.customer_orders
set extras = case when extras = 'null' then replace(extras, 'null', NULL)
else replace(extras, '', NULL)
end 
where extras = '' or extras = 'null'

DROP TABLE IF EXISTS customer_orders_temp
create temp table customer_orders_temp
(
  "order_id" INTEGER,
  "customer_id" INTEGER,
  "pizza_id" INTEGER,
  "exclusions" VARCHAR(4),
  "extras" VARCHAR(4),
  "order_time" TIMESTAMP,
"sno" INTEGER
);

insert into customer_orders_temp
with cte as
(select *, row_number() over() as sno from customer_orders
 )
select order_id,customer_id,pizza_id,t1.exclusions,t2.extras,order_time, sno
from cte
   cross join lateral unnest(coalesce(nullif(string_to_array(exclusions,', '),'{}'),array[null::VARCHAR(4)])) as t1(exclusions)
   cross join lateral unnest(coalesce(nullif(string_to_array(extras,', '),'{}'),array[null::VARCHAR(4)])) as t2(extras);
   
ALTER table customer_orders_temp
ALTER COLUMN extras TYPE INTEGER
USING extras::INTEGER

ALTER table customer_orders_temp
ALTER COLUMN exclusions TYPE INTEGER
USING exclusions::INTEGER

ALTER TABLE customer_orders_temp
ALTER COLUMN order_time TYPE timestamp
USING order_time::timestamp;

select * from customer_orders_temp;

-----------------------------------------------------
select * from pizza_recipes;

-- Updating and altering pizza_recipes table

DROP TABLE IF EXISTS pizza_recipes_temp
create temp table pizza_recipes_temp
(
  "pizza_id" INTEGER,
  "toppings" TEXT
)

insert into pizza_recipes_temp
select pizza_id,t.toppings
from pizza_recipes
cross join lateral unnest(coalesce(nullif(string_to_array(toppings,', '),'{}'),array[null::TEXT])) as t(toppings);

select * from pizza_recipes_temp;

ALTER table pizza_recipes_temp
ALTER COLUMN toppings TYPE INTEGER
USING toppings::INTEGER;


ALTER table pizza_recipes
ALTER COLUMN toppings TYPE INTEGER
USING toppings::INTEGER;

TRUNCATE TABLE pizza_recipes;

insert into pizza_recipes
select * from pizza_recipes_temp;

select * from pizza_recipes;

