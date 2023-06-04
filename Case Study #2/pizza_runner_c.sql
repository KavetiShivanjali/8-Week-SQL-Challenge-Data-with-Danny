SET search_path = pizza_runner;
-- C.Ingredient Optimization
--1. What are the standard ingredients for each pizza?
select pn.pizza_name, string_agg(pt.topping_name, ', ') as standard_ingredients
from pizza_recipes pr
join pizza_names pn
on pr.pizza_id = pn.pizza_id
join pizza_toppings pt
on pr.toppings = pt.topping_id
group by 1;

--2. What was the most commonly added extra?
DROP TABLE customer_orders_temp;
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
select order_id,customer_id,pizza_id,t1.exclusions, t2.extras, order_time, sno
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

select pt.topping_name as common_extras, count(distinct sno) as tot
from customer_orders_temp c
join pizza_toppings pt
on c.extras = pt.topping_id
where extras is not NULL
group by 1
order by 2 desc
limit 1;

--3. What was the most common exclusion?
select pt.topping_name as common_exclusions, count(distinct sno) as tot
from customer_orders_temp c
join pizza_toppings pt
on c.exclusions = pt.topping_id
where exclusions is not NULL
group by 1
order by 2 desc
limit 1;

--4. Generate an order item for each record in the customers_orders table in the format of one of the following:
-- Meat Lovers
-- Meat Lovers - Exclude Beef
-- Meat Lovers - Extra Bacon
-- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
select *, case 
when POSITION('3' in exclusions) != 0 then 'Meat Lovers - Exclude Beef'
when POSITION('1' in extras) != 0  then 'Meat Lovers - Extra Bacon'
when POSITION('1' in exclusions) != 0 and POSITION('4' in exclusions) != 0 and POSITION('6' in extras) != 0
and POSITION('9' in extras) != 0 then 'Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers'
else 'Meat Lovers'
end as order_item
from customer_orders
where pizza_id = 1;

--5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table 
-- and add a 2x in front of any relevant ingredients
-- For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
with cte as
(
	select distinct c.order_id, c.customer_id, c.pizza_id,c.sno,pr.toppings
	from customer_orders_temp c 
	join pizza_recipes pr
	on c.pizza_id = pr.pizza_id
	order by 4,1,2
)
, cte2 as
(
	(select sno, customer_id, order_id, pizza_id, toppings
	from cte
	union all
	select distinct sno, customer_id, order_id, pizza_id, extras as toppings
	from customer_orders_temp
	where extras is not NULL)
	except all
	(select distinct sno, customer_id, order_id, pizza_id, exclusions as toppings
	from customer_orders_temp
	where exclusions is not NULL)
)
,cte3 as (
select sno,order_id,customer_id,pizza_id,toppings,count(*) as count_top
from cte2
group by 1,2,3,4,5
order by 1,2,3,5
)
, cte4 as (
select c.sno, c.order_id,c.customer_id, c.pizza_id,
case when count_top = 2 then CONCAT('2x',pt.topping_name)
else pt.topping_name
end
as ingredient_name
from cte3 as c
join pizza_toppings as pt
on c.toppings = pt.topping_id
)

select sno, order_id, customer_id, case when pizza_id = 1 then CONCAT('Meat Lovers: ', string_agg(ingredient_name,', '))
else CONCAT('Vegetarian: ', string_agg(ingredient_name,', '))
end as ingredients
from cte4
group by 1,2,3,cte4.pizza_id
order by 1,2,3;

--6.  What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
with cte as
(
	select distinct c.order_id, c.customer_id, c.pizza_id,c.sno,pr.toppings
	from customer_orders_temp c 
	join pizza_recipes pr
	on c.pizza_id = pr.pizza_id
	join runner_orders r
	on r.order_id = c.order_id
	where r.cancellation is NULL
	order by 4,1,2
)
, cte2 as
(
	(select sno, customer_id, order_id, pizza_id, toppings
	from cte
	union all
	select distinct sno, customer_id, c.order_id, c.pizza_id, extras as toppings
	from customer_orders_temp c
	join runner_orders r
	on r.order_id = c.order_id
	where r.cancellation is NULL
	 and extras is not NULL)
	except all
	(select distinct sno, customer_id, c.order_id, c.pizza_id, exclusions as toppings
	from customer_orders_temp c
	join runner_orders r
	on r.order_id = c.order_id
	where r.cancellation is NULL and 
	exclusions is not NULL)
)

select pt.topping_name, count(*) as tot_qty
from cte2 c
join pizza_toppings as pt
on c.toppings = pt.topping_id
group by 1
order by 2 desc;
