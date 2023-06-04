-- D.  Pricing and Ratings
SET search_path = pizza_runner;
--1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes 
-- how much money has Pizza Runner made so far if there are no delivery fees?
select sum(case when pizza_id = 1 then 12
else 10
end) as tot_rev
from customer_orders;

--2. What if there was an additional $1 charge for any pizza extras?
--   Add cheese is $1 extra
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

with cte as 
(
	select sno, count(distinct extras) as tot_cost_extra
	from customer_orders_temp
	where extras is NOT NULL
	group by sno
)
, cte2 as
(
	select sum(tot_cost_extra) as rev
	from cte
)
, cte3 as
(
	select sum(case when pizza_id = 1 then 12
else 10
end) as rev
from customer_orders
)
select cte3.rev + cte2.rev as tot_rev_with_extras
from cte2
cross join cte3
--3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, 
-- how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
CREATE TABLE runner_orders_temp (
  "order_id" INTEGER,
  "runner_id" INTEGER,
  "pickup_time" timestamp,
  "distance" float,
  "duration" float,
  "cancellation" VARCHAR(23),
"rating" float
);

insert into runner_orders_temp
select *,case when cancellation is NULL then ROUND((random()*5)::Decimal,2) 
else NULL
end as rating 
from runner_orders 

truncate table runner_orders_temp;

select * from runner_orders_temp
--4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
-- customer_id
-- order_id
-- runner_id
-- rating
-- order_time
-- pickup_time
-- Time between order and pickup
-- Delivery duration
-- Average speed
-- Total number of pizzas

select min(c.customer_id) as customer_id, r.order_id as order_id, min(r.runner_id) as runner_id,
min(r.rating) as rating, min(c.order_time) as order_time, min(r.pickup_time) as pickup_time, 
DATE_PART('minutes', min(r.pickup_time) - min(c.order_time)) as "Time between order and pickup",
min(r.duration) as "Delivery duration", round((min(r.distance)/min(r.duration))::decimal ,2) as "Average speed",
count(c.order_id) as "Total number of pizzas"
from runner_orders_temp r
join customer_orders c
on r.order_id = c.order_id
group by r.order_id
order by 2

--5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and 
-- each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?
with cte as
(
	select c.pizza_id, r.*
	from runner_orders r
	join customer_orders c
	on r.order_id = c.order_id
)
select order_id, min(runner_id) as runner_id,sum(case when cancellation is NULL and pizza_id = 1 then round((12 - 0.30*distance)::decimal,2)
when cancellation is NULL and pizza_id = 2 then round((10 - 0.30*distance)::decimal,2) 
end) as left_over
from cte
group by 1
order by 1;