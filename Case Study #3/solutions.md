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
  So, for this question I have gathered all the information such as plan_name, start and end date of each plan, number of days he/she were in that plan ordered by the date at which they have chosen that plan
  for each customer mentioned in the question using common table expressions to gather information from both the source tables subscriptions and plans.
  
  <b> Result: </b>
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/6efb7981-3940-4124-aabe-543d08279cc2)



