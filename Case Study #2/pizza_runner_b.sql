SET search_path = pizza_runner;
-- B. Runner and Customer Experience
--1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
select to_char(registration_date,'w') as week, count(runner_id) as tot_runners
from runners
group by 1
order by 1;

--2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
with cte as
(
	select runner_id, customer_orders.order_id,
	DATE_PART('minute', pickup_time - order_time) as mins
	from customer_orders
	join runner_orders
	on customer_orders.order_id = runner_orders.order_id
)
select runner_id, avg(mins) as avg_time
from cte 
group by 1
order by 2


--3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
with cte as
(
	select c.order_id, count(*) as num_pizza, min(r.pickup_time) as ptime, min(c.order_time) as otime
	from customer_orders c
	join runner_orders r
	on c.order_id = r.order_id
	where r.cancellation is NULL
	group by 1
)

select order_id, num_pizza, DATE_PART('minute',ptime-otime) as prep_time
from cte
order by 2 desc;

--4. What was the average distance travelled for each customer?
select c.customer_id, avg(r.distance) as average_distance
from customer_orders c
join runner_orders r
on c.order_id = r.order_id
group by 1
order by 2 desc;

--5. What was the difference between the longest and shortest delivery times for all orders?
with cte as
( select max(duration) as long_dur, min(duration) as short_dur
 from runner_orders
)
select long_dur - short_dur as diff
from cte;

--6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
select order_id, runner_id, (distance/duration) as speed
from runner_orders
where cancellation is NULL
order by 2,1;

--7. What is the successful delivery percentage for each runner?
with cte as
(
	select runner_id, sum(case when CANCELLATION is NULL then 1 else 0 end) as success, 
	count(*) as tot
	from runner_orders
	group by 1
)

select runner_id, (success*100)/(tot) as success_percent
from cte
order by 2 desc;