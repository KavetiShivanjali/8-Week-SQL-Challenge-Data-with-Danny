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
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/6efb7981-3940-4124-aabe-543d08279cc2)

#B. Data Analysis Questions
<b> 1. How many customers has Foodie-Fi ever had?</b>
  
  <b> Solution:</b>
        
        select count(distinct customer_id) as tot_customers 
        from subscriptions

  <b> Explanation: </b>
  
The total number of customers can be found by using count distinct on customer_id in subscriptions table as subscriptions table contains information about all the plans each customer has taken in his/her journey. So, it is indeed required to use distinct before count as it eliminates duplicates.
  
  <b> Result: </b>
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/3a0eae3a-8bd5-404d-b7cd-1f3f7aaf6724)

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
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/3d2bbb65-a623-4df4-a115-50c1421bb479)


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
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/a3b2d8f5-e032-460a-b357-c7773475805d)

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
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/ecff99cf-75c1-4a20-8222-f37044a79cce)

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
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/2950f41c-8781-487e-9ffe-2b0333d21afc)

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
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/8050ea06-823d-41c1-8957-1f94589a368d)

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
  To find the number and percentage of customer plans after their initial free trail, we need to extract next plan for all the current plans using lead function on plan_id column in subscriptions table. After extracting the next plans we can filter only those plans which are initial plans using where clause. By using simple case statements and sum aggregate function we can find the total numbers and percentages for 4 different plans categories.
  
  <b> Result: </b>
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/8050ea06-823d-41c1-8957-1f94589a368d)













