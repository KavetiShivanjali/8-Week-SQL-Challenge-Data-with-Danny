SET search_path = foodie_fi;

-- A. Customer Journey
-- Based off the 8 sample customers provided in the sample from the subscriptions table,(1,2,11,13,15,16,18,19) 
-- write a brief description about each customer’s onboarding journey.
-- Try to keep it as short as possible - you may also want to run some sort of join to make your explanations a bit easier!

with cte as
(
	select customer_id, plan_id, start_date, lead(start_date,1) over(partition by customer_id order by start_date) as next_date
	from subscriptions
	where customer_id in (1,2,11,13,15,16,18,19)
)

select c.customer_id,p.plan_name, c.start_date, c.next_date as end_date, case when c.next_date is not NULL then (c.next_date - c.start_date) 
else NULL end as days_in_plan, row_number() over(partition by customer_id order by start_date) as plan_order
from cte c
join plans p
on c.plan_id = p.plan_id


-- B. Data Analysis Questions
-- 1. How many customers has Foodie-Fi ever had?

select count(distinct customer_id) as tot_customers 
from subscriptions

-- 2. What is the monthly distribution of trial plan start_date values for our dataset 
-- - use the start of the month as the group by value

select to_char(s.start_date,'MM') as "Month", to_char(s.start_date,'MON') as "Month_name", count(*) as tot_cust
from subscriptions s
join plans p
on s.plan_id = p.plan_id
where p.plan_name = 'trial'
group by 1,2
order by 1;


-- 3. What plan start_date values occur after the year 2020 for our dataset?  
-- Show the breakdown by count of events for each plan_name
select sum(case when plan_id = 1 then 1 else 0 end) as "Basic_Monthly",
sum(case when plan_id = 2 then 1 else 0 end) as "Pro_Monthly",
sum(case when plan_id = 3 then 1 else 0 end) as "Pro_Annualy",
sum(case when plan_id = 4 then 1 else 0 end) as "Churned"
from subscriptions s
where DATE_PART('YEAR',start_date) > 2020;


-- 4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?

with cte as
(
	select count(distinct s.customer_id) as total_count, sum(case when p.plan_name = 'churn' then 1 else 0 end) as total_churn
	from subscriptions s
	join plans p
	on s.plan_id = p.plan_id
)

select total_count, round(((total_churn*1.0)*100/(total_count*1.0))::Decimal,1) from cte

-- 5. How many customers have churned straight after their initial free trial - 
-- what percentage is this rounded to the nearest whole number?
with cte as
(select customer_id, count(*) as tot
 from subscriptions s
 group by 1
 having min(plan_id) = 0
)
select sum(case when p.plan_name = 'churn' and c.tot = 2 then 1 else 0 end) as churned, 
round(((sum(case when p.plan_name = 'churn' and c.tot = 2 then 1 else 0 end)*1.0)*100)/count(distinct s.customer_id)*1.0::Decimal,1) as churn_percentage
from subscriptions s
join plans p
on s.plan_id = p.plan_id
join cte c
on s.customer_id = c.customer_id

-- 6. What is the number and percentage of customer plans after their initial free trial?
with cte as
(
	select *,  lead(plan_id,1,plan_id) over(partition by customer_id order by start_date)
	as next_plan
	from subscriptions
)
select sum(case when next_plan = 1 then 1 else 0 end) as "Basic_Monthly",
sum(case when next_plan = 2 then 1 else 0 end) as "Pro_Monthly",
sum(case when next_plan = 3 then 1 else 0 end) as "Pro_Annualy",
sum(case when next_plan = 4 then 1 else 0 end) as "Churned"
from cte c
where c.plan_id = 0

-- 7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?

with cte as
(
	select customer_id, plan_id, start_date, lead(start_date,1,start_date) over(partition by customer_id order by start_date) as next_date
	from subscriptions
)

select sum(case when plan_id = 0 then 1 else 0 end) as "Trial",
sum(case when plan_id = 1 then 1 else 0 end) as "Basic_Monthly",
sum(case when plan_id = 2 then 1 else 0 end) as "Pro_Monthly",
sum(case when plan_id = 3 then 1 else 0 end) as "Pro_Annualy",
sum(case when plan_id = 4 then 1 else 0 end) as "Churned" 
from cte
where ('2020-12-31' >= start_date and '2020-12-31' < next_date) or (start_date = next_date and start_date <= '2020-12-31')

-- 8. How many customers have upgraded to an annual plan in 2020?
select count(distinct customer_id) as annual_plan 
from subscriptions
where plan_id = 3 and to_char(start_date,'YYYY') = '2020'

-- 9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
with cte as
(
	select customer_id,start_date from subscriptions
	where plan_id = 3
)
, cte1 as
(
	select s.customer_id, min(s.start_date) as start_date, min(c.start_date) as annual_date
	from subscriptions s 
	join cte c
	on s.customer_id = c.customer_id
	group by s.customer_id
)
select round(avg(annual_date - start_date)::Decimal,0) as "avg_days"  
from cte1

----------------------------------

-- 10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
with cte as
(
	select customer_id, start_date from subscriptions
	where plan_id = 3
)
, cte1 as
(
	select s.customer_id, WIDTH_BUCKET(min(c.start_date) - min(s.start_date), 0, 365, 12) AS day_bucket
	from subscriptions s 
	join cte c
	on s.customer_id = c.customer_id
	group by s.customer_id
)
, cte2 as (
select (case when day_bucket = 1 then (day_bucket-1)*30 else ((day_bucket-1)*30)+1 end || ' - ' || (day_bucket)*30 || ' days') as days_bucket, count(customer_id) as tot_customers
from cte1
group by day_bucket
order by day_bucket
)
select * from cte2

-- 11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?
with cte as
(
	select customer_id, plan_id as current_plan, lag(plan_id,1,plan_id) over(partition by customer_id order by start_date) as prev_plan
	from subscriptions
)

select count(distinct customer_id)
from cte
where current_plan = 1 and prev_plan = 2

-- C. Challenge Payment Question
-- The Foodie-Fi team wants you to create a new payments table for the year 2020 that includes 
-- amounts paid by each customer in the subscriptions table with the following requirements:

-- monthly payments always occur on the same day of month as the original start_date of any monthly paid plan
-- upgrades from basic to monthly or pro plans are reduced by the current paid amount in that month and start immediately
-- upgrades from pro monthly to pro annual are paid at the end of the current billing period and also starts at the end of the month period
-- once a customer churns they will no longer make payments

with recursive cte (customer_id,plan_id,start_date,next_date) as 
(
	select customer_id, plan_id, start_date::timestamp
    , lead(start_date,1,'2020-12-31') over(partition by customer_id order by start_date) as next_date
	from subscriptions
	where  plan_id != 0 and plan_id != 4 and to_char(start_date,'YYYY') = '2020'
	
	union all
	
	select customer_id, plan_id, start_date + INTERVAL '1 month' as start_date
	,next_date
	from cte
 	where (start_date + INTERVAL '1 month') < next_date and (start_date + INTERVAL '1 month') < '2020-12-31'::timestamp and plan_id != 3 
)
, 
cte1 as
(select *,row_number() over(partition by customer_id order by start_date) as payment_order , 
 lag(plan_id,1,plan_id) over(partition by customer_id order by start_date) as prev_plan
 from cte
)
select c.customer_id, p.plan_name, start_date::date as payment_date,
case when c.plan_id = prev_plan then p.price 
when (c.plan_id = 2 or c.plan_id = 3) and prev_plan = 1 then p.price-x.price
else p.price
end as amount, payment_order 
from cte1 c
join plans p
on c.plan_id = p.plan_id
join plans x
on c.prev_plan = x.plan_id
order by 1,5
---------------------------------

