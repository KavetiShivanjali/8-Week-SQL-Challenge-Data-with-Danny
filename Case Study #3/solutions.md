# A. Customer Journey
<b>Based off the 8 sample customers provided in the sample from the subscriptions table,(1,2,11,13,15,16,18,19) 
write a brief description about each customer’s onboarding journey.
Try to keep it as short as possible - you may also want to run some sort of join to make your explanations a bit easier!</b>
  
  <b> Solution:</b>
        
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
  <b> Explanation: </b>
  
As per my knowledge the journey of a customer starts with taking the first plan followed by many plans as per his convinience and number of days in each plan he/she has opted for.
So, for this question I have gathered all the information such as plan_name, start and end date of each plan, number of days he/she were in that plan ordered by the date at which they have chosen that plan for each customer mentioned in the question using common table expressions to gather information from both the source tables subscriptions and plans.
  
  <b> Result: </b>
  <div align="center">
    <img src="https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/6efb7981-3940-4124-aabe-543d08279cc2">
 </div>
  
  
  

# B. Data Analysis Questions
<b> 1. How many customers has Foodie-Fi ever had?</b>
  
  <b> Solution:</b>
        
        select count(distinct customer_id) as tot_customers 
        from subscriptions

  <b> Explanation: </b>
  
The total number of customers can be found by using count distinct on customer_id in subscriptions table as subscriptions table contains information about all the plans each customer has taken in his/her journey. So, it is indeed required to use distinct before count as it eliminates duplicates.
  
  <b> Result: </b>
  <div align="center">
    <img src="https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/3a0eae3a-8bd5-404d-b7cd-1f3f7aaf6724">
 </div>
  

<b> 2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value</b>
  
  <b> Solution:</b>
        
        select to_char(s.start_date,'MM') as "Month", to_char(s.start_date,'MON') as "Month_name", count(*) as tot_cust
        from subscriptions s
        join plans p
        on s.plan_id = p.plan_id
        where p.plan_name = 'trial'
        group by 1,2
        order by 1;


  <b> Explanation: </b>
  To find the monthly distribution of trial plan first we need to filter only those rows which belong to trial plan using where clause and joining the subscriptions
  and plans tables to extract plan names from plan ids. We need to extract the month from start_date using to_char function. Based on the month extracted we need to group them and count the customers for each month group using groupby clause and count function.
  
  <b> Result: </b>
  <div align="center">
    <img src="https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/3d2bbb65-a623-4df4-a115-50c1421bb479">
 </div>
  


<b> 3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name</b>
  
  <b> Solution:</b>
        
        select sum(case when plan_id = 1 then 1 else 0 end) as "Basic_Monthly",
        sum(case when plan_id = 2 then 1 else 0 end) as "Pro_Monthly",
        sum(case when plan_id = 3 then 1 else 0 end) as "Pro_Annualy",
        sum(case when plan_id = 4 then 1 else 0 end) as "Churned"
        from subscriptions s
        where DATE_PART('YEAR',start_date) > 2020;


  <b> Explanation: </b>
  
  To find all the plans start date after the year 2020 we need to filter the year from start_date to be above 2020 using where clause and DATE_PART function.
  After filtering necessary rows from substription table we need to count the plans per plan basis using sum and case statements.
  
  <b> Result: </b>
  <div align="center">
    <img src="https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/a3b2d8f5-e032-460a-b357-c7773475805d">
 </div>
  
  
<b> 4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?</b>
  
  <b> Solution:</b>
        
        with cte as
        (
        select count(distinct s.customer_id) as total_count, sum(case when p.plan_name = 'churn' then 1 else 0 end) as total_churn
        from subscriptions s
        join plans p
        on s.plan_id = p.plan_id
        )
        
        select total_count, round(((total_churn*1.0)*100/(total_count*1.0))::Decimal,1) from cte


  <b> Explanation: </b>
  
  To find the percentage of customers who have churned we need to extract the total number customers who have churned using sum and case statements along with 
  the total number of customers using count distinct as explained above from subscriptions table and plans table to map plan id with its corresponding plan name.
  After extracting total churned customers and total customers a simple mathematical formula to find percentage of churned customers can be applied to get the result. round function is used to round the calculated percentage to 1 decimal.
  
  <b> Result: </b>
  <div align="center">
    <img src="https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/ecff99cf-75c1-4a20-8222-f37044a79cce">
 </div>
  
  
<b> 5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?</b>
  
  <b> Solution:</b>
        
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


  <b> Explanation: </b>

To find the percentage of customers who have churned straight after their initial free trail, we need to count the plans taken by a customer who have taken initial plan as trial plan of which is taken care by writing a simple cte. Next we count only the cases where the customers have churned and the total plans he/she have taken is 2 using inner join with the cte along with the case statements and sum aggregate function. After gathering the total customers who have churned after initial plan we need calculate percentage by dividing it with total number of customers and by using round function we can round the percentage value to nearest whole number.  
  
  <b> Result: </b>
  <div align="center">
    <img src="https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/2950f41c-8781-487e-9ffe-2b0333d21afc">
 </div>
  
  

<b> 6. What is the number and percentage of customer plans after their initial free trial?</b>
  
  <b> Solution:</b>
        
        with cte as
        (
        	select *,  lead(plan_id,1,plan_id) over(partition by customer_id order by start_date)
        	as next_plan
        	from subscriptions
        )
        select sum(case when next_plan = 1 then 1 else 0 end) as "Basic_Monthly",
        round(sum(case when next_plan = 1 then 1 else 0 end)*100.0/count(distinct customer_id)*1.0,1) as "Basic_Monthly_pct",
        sum(case when next_plan = 2 then 1 else 0 end) as "Pro_Monthly",
        round(sum(case when next_plan = 2 then 1 else 0 end)*100.0/count(distinct customer_id)*1.0,1) as "Pro_Monthly_pct",
        sum(case when next_plan = 3 then 1 else 0 end) as "Pro_Annualy",
        round(sum(case when next_plan = 3 then 1 else 0 end)*100.0/count(distinct customer_id)*1.0,1) as "Pro_Annualy_pct",
        sum(case when next_plan = 4 then 1 else 0 end) as "Churned",
        round(sum(case when next_plan = 4 then 1 else 0 end)*100.0/count(distinct customer_id)*1.0,1) as "Churned_pct"
        from cte c
        where c.plan_id = 0



  <b> Explanation: </b>

To find the number and percentage of customer plans after their initial free trail, we need to extract next plan for all the current plans using lead function on plan_id column in subscriptions table. After extracting the next plans we can filter only those plans which are initial plans using where clause. By using simple case statements and sum aggregate function we can find the total numbers and percentages for 4 different plans categories.
  
  <b> Result: </b>
  <div align="center">
    <img src="https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/8050ea06-823d-41c1-8957-1f94589a368d">
 </div>
  
  

<b> 7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31</b>
  
  <b> Solution:</b>
        
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



  <b> Explanation: </b>

To find the customer count and percentage breakdown of all 5 plans at 2020-12-31, we need to find for each customer what plan he is enrolled during that particular date. This can be extracted by getting the next plan of the customer using lead function by writing a cte. After getting the next plans date, we need to check if 2020-12-31 lies in between current plan date and next plan date which implies that the customer is enrolled in the current plan if the date lies in between by using a where clause filter and counting the customer plans category wise using sum aggregate function and case statements.
  
  <b> Result: </b>
  <div align="center">
    <img src="https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/11df1969-f41e-4dd8-a1c4-a6fcb94d964b">
 </div>
  
  

<b> 8. How many customers have upgraded to an annual plan in 2020?</b>
  
  <b> Solution:</b>
        
    select count(distinct customer_id) as annual_plan 
    from subscriptions
    where plan_id = 3 and to_char(start_date,'YYYY') = '2020'



  <b> Explanation: </b>

To find the customer count who have upgraded to an annual plan in 2020, we can use where clause to filter the year to 2020 and choose only those plan_id with 3 as it indicates annual plan. After filtering necessary rows, we can apply count function on the customer_id to get the result.
  
  <b> Result: </b>
  <div align="center">
    <img src="https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/76060d81-8bdc-4eb8-be10-9016b0c02bcc">
 </div>
  
  
<b> 9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?</b>
  
  <b> Solution:</b>
        
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



  <b> Explanation: </b>

To find the average number of days a customer takes to opt for annual plan, we need to gather all the customers who have opted for annual plan through a cte. 
For these customers we also need to find their join date for foodie-fi which can be done using min function on start dates after joining the subscriptions table with the cte table. After gathering the necessary information we can apply avg function on the difference between the annual plan start date and join date which will lead us to the result.
  
  <b> Result: </b>
  <div align="center">
    <img src="https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/f9657a1c-07b4-42a7-82a9-45a27697b4e5">
 </div>
  
  

<b> 10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc) </b>
  
  <b> Solution:</b>
        
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
      select (case when day_bucket = 1 then (day_bucket-1)*30 else ((day_bucket-1)*30)+1 end || ' - ' || (day_bucket)*30 || ' days') as days_bucket, 
      count(customer_id) as tot_customers
      from cte1
      group by day_bucket
      order by day_bucket
      )
      select * from cte2



  <b> Explanation: </b>

To find the average number of days a customer takes to opt for annual plan in 30 days period, we need to gather all the customers who have opted for annual plan through a cte. 
For these customers we need to bucket the difference between the  join date for foodie-fi and the annual plan start date using width_bucket function after joining the subscriptions table with the cte table. After gathering the necessary information we can use case statements to segregate the 30-days interval categories and count the customers for each category using group by and count function. At the end we can order them based on the buckets.
  
  <b> Result: </b>
  <div align="center">
    <img src="https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/d46b6665-3399-4ed0-8d0a-8b536ee924d1">
 </div>
  
  

<b> 11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?</b>
  
  <b> Solution:</b>
        
    with cte as
    (
    	select customer_id, plan_id as current_plan, lag(plan_id,1,plan_id) over(partition by customer_id order by start_date) as prev_plan
    	from subscriptions
    )
    
    select count(distinct customer_id)
    from cte
    where current_plan = 1 and prev_plan = 2


  <b> Explanation: </b>

To find the customer count who have downgraded from a pro monthly plan to a basic monthly plan in 2020, we need to extract previous plan of each customer by using lag function. We can then count the disticnt customer whos current plan is basic monthly and previous plan was pro monthly by using a where clause and count function.
  
  <b> Result: </b>
  <div align="center">
    <img src="https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/29fd1aa4-a428-4163-9621-0fd16e8f0c70">
 </div>
  
  
# C. Challenge Payment Question
<b> The Foodie-Fi team wants you to create a new payments table for the year 2020 that includes 
amounts paid by each customer in the subscriptions table with the following requirements:

* monthly payments always occur on the same day of month as the original start_date of any monthly paid plan
* upgrades from basic to monthly or pro plans are reduced by the current paid amount in that month and start immediately
* upgrades from pro monthly to pro annual are paid at the end of the current billing period and also starts at the end of the month period
* once a customer churns they will no longer make payments</b>
  
  <b> Solution:</b>
        
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
      ), 
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
      where customer_id in (1,2,13,15,16,18,19)
      order by 1,5


  <b> Explanation: </b>

To find the payment details for each customer for each of his plan in 2020 for every month, we need to generate plan information for each customer i.e., what plan he is in for every month in 2020 which can be done using recursive cte by adding 1 month interval to the start_date until it hits a plan change or last day of the year 2020. After gathering this information we need to extract the previous plan to identify any plan changes and to apply the given payment rules accordingly. After gathering previous plan, current plan for each customer for each month we can then apply the defined payment rules using case statements. We can order the final result by the customer_id and the payment order.
  
  <b> Result: </b>
  <div align="center">
    <img src="https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/a46b73dc-fc3e-4318-aa6b-5e27cfaff391">
 </div>
  
  











  













