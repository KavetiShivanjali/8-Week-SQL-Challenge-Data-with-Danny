SET search_path = pizza_runner;

-- A. Pizza Metrics
--1. How many pizzas were ordered?
select count(distinct order_id) as tot_orders from customer_orders;

--2. How many unique customer orders were made?
select count(distinct customer_id) as tot_cust from customer_orders;

--3. How many successful orders were delivered by each runner?
select r.runner_id, COALESCE(count(distinct ro.order_id),0) as suc_orders 
from runners r
left join
(select * from runner_orders
where cancellation is  NULL) ro
on r.runner_id = ro.runner_id
group by r.runner_id;



--4. How many of each type of pizza was delivered?
select c.pizza_id, count(r.order_id) as tot_pizza 
from customer_orders c
join runner_orders r
on c.order_id = r.order_id
where r.cancellation is NULL
group by 1;

--5. How many Vegetarian and Meatlovers were ordered by each customer?

select customer_id, sum(case when pizza_id = 1 then 1 else 0 end) as meatlovers_count,
sum(case when pizza_id = 2 then 1 else 0 end) as veg_count
from customer_orders
group by 1
order by 1;

--6. What was the maximum number of pizzas delivered in a single order?

select order_id, count(order_id) as count_pizza
from customer_orders
group by 1
order by 2 desc
limit 1;


--7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
select customer_id, sum(case when extras is NULL and exclusions is NULL then 1 else 0 end) as nochng_sum,
sum(case when extras is not NULL or exclusions is not NULL then 1 else 0 end) as chng_sum
from customer_orders
join runner_orders
on customer_orders.order_id = runner_orders.order_id
where cancellation is NULL
group by 1



--8. How many pizzas were delivered that had both exclusions and extras?
select count(customer_orders.order_id) as tot_pizzas
from customer_orders
join runner_orders
on customer_orders.order_id = runner_orders.order_id
where extras is not NULL and exclusions is not NULL;

--9. What was the total volume of pizzas ordered for each hour of the day?

select EXTRACT(hour from order_time) as "Hour", count(order_id) as tot_vol
from customer_orders
group by 1
order by 2 desc;

--10. What was the volume of orders for each day of the week?
select to_char(order_time,'Day') as "Day", count(order_id) as tot_vol
from customer_orders
group by 1
order by 2 desc;
