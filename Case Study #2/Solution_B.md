# B. 🛃Runner and Customer Experience Solutions & Explanations
<b> 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)</b>
  
  <b> Solution:</b>
        
        select to_char(registration_date,'w') as week, count(runner_id) as tot_runners
        from runners
        group by 1
        order by 1;
  <b> Explanation: </b>
  
  To get the total runners added weekly, we need to extract week_no information from registration_date which is present in runners table. For each week we can count the runner_id signed up by adding a group by clause over the week_no.
  
  <b> Result: </b>
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/96af82e8-a45c-4edf-a2ec-14b5ae75d32e)
  
 <b> 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?</b>
  
  <b> Solution:</b>
         
         
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
  <b> Explanation: </b>
  
  Here we need to calculate the difference in between order_time and pickup_time in terms of mins by gathering information using join between customer_orders which contain order_time and runner_order which contain pickup_time and runner_information. After getting the time_difference in mins we can average the total difference in time for each runner_id.
  
  <b> Result: </b>
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/8b9d50ce-2943-4726-bd85-cc1543a9ade3)

 <b> 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?</b>
  
  <b> Solution:</b>
  
        
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
  <b> Explanation: </b>
  
  Here I am conidering time to be the difference between order_time and pickup_time. As mentioned in the above question, both these informations come from two different tables and hence we need to join them. I have written a cte(common table expression which gathers the information such as order_id, number of pizzas for order_id, pickup_time, order_time for each order which was done by adding a group by clause over order_id. To select only the orders which got delivered I used a where clause to only include successful deliveries. After gathering this information we can extract total pizzas ordered along with the time of preparation by finding the difference between order_time and pickup_time.In order to compare the values between number of pizzas and time of preparation order by clause id also included.
  
  <b> Result: </b>
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/766aa1bf-31ff-4d55-9384-c4c46b2050ba)
  
  <b> 4.  What was the average distance travelled for each customer?</b>
  
  <b> Solution:</b>
  
        
          select c.customer_id, avg(r.distance) as average_distance
          from customer_orders c
          join runner_orders r
          on c.order_id = r.order_id
          group by 1
          order by 2 desc;
  <b> Explanation: </b>
  
  Distance information is in the runner_orders table and customer_id is in the customer_orders table. A simple join on the two tables will gather all the information. As it is for each customer group by customer_id and average over the runner's distance will give the average distance travelled for each customer.
  
  <b> Result: </b>
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/0354829d-8f78-468c-9bca-2a4e3b039d79)

  
  <b> 5. What was the difference between the longest and shortest delivery times for all orders?</b>
  
  <b> Solution:</b>
  
        
          with cte as
          ( select max(duration) as long_dur, min(duration) as short_dur
           from runner_orders
          )
          select long_dur - short_dur as diff
          from cte;
  <b> Explanation: </b>
  
  To find the difference between the longest and shortest delivery times we need to extract max and min values of duration from runners table and find the difference.
  
  <b> Result: </b>
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/74eb47dc-2002-442b-8ab3-94792c052f8f)


  
  <b> 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?</b>
  
  <b> Solution:</b>
  
        
          select order_id, runner_id, (distance/duration) as speed
          from runner_orders
          where cancellation is NULL
          group by 2,1
          order by 2,1;
  <b> Explanation: </b>
  
  We need to find the speed (distance/duration) as the units in the table for distance is kms and for duration is in mins. The speed I calculated above is in kms/min. As they mentioned the average speed for each runner_id for each order_id, a group by clause on two columns runner_id, order_id is done. To analyse trend order by runer_id and order_id is done.
  
  <b> Result: </b>
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/876af250-9a43-4794-9d63-be7125b41b64)

  
  <b> 7. What is the successful delivery percentage for each runner?</b>
  
  <b> Solution:</b>
  
        
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
  <b> Explanation: </b>
  
  To find the successful delivery percentage, we need to find the total number of successful orders and total number of orders for each runner_id from runner_orders by using group by clause. All this information is calculated using cte and later we use this information to calculate the actual succcess percentage i.e., (success * 100/tot) will give the required results.
  
  <b> Result: </b>
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/ffe7d508-b167-4708-807e-1a05f50393f4)
