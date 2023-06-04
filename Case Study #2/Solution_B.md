# B. Runner and Customer Experience Solutions & Explanations
<b> 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)</b>
  
  <b> Solution:</b>
        
        select to_char(registration_date,'w') as week, count(runner_id) as tot_runners
        from runners
        group by 1
        order by 1;
  <b> Explanation: </b>
  
  customer_orders table is containing information of all the orders and hence a simple count function over the table will give the result.
  
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
  
  customer_orders table contains customer_id those who ordered pizzas. A simple count distinct on customer_id will give the necessary result.
  
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
  
  runner_orders table contains the assignment information for each order to its corresponding runner_id. It also contains cancellation attribute
  whose value is NULL for successful orders.
  By using the above mentioned columns(runner_id, cancellation) we can extract the count of orders for each runner where cancellation is null to get successful     orders.
  To get the successful orders of the runners not present in runner_orders table we can left join with the runners table and can make the count to zero if it is     not present in runner_orders table.
  
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
  
  runner_orders table contains the assignment information for each order to its corresponding runner_id. It also contains cancellation attribute
  whose value is NULL for successful orders.
  By using the above mentioned columns(runner_id, cancellation) we can extract the count of orders for each runner where cancellation is null to get successful     orders.
  To get the successful orders of the runners not present in runner_orders table we can left join with the runners table and can make the count to zero if it is     not present in runner_orders table.
  
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
  
  runner_orders table contains the assignment information for each order to its corresponding runner_id. It also contains cancellation attribute
  whose value is NULL for successful orders.
  By using the above mentioned columns(runner_id, cancellation) we can extract the count of orders for each runner where cancellation is null to get successful     orders.
  To get the successful orders of the runners not present in runner_orders table we can left join with the runners table and can make the count to zero if it is     not present in runner_orders table.
  
  <b> Result: </b>
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/74eb47dc-2002-442b-8ab3-94792c052f8f)


  
  <b> 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?</b>
  
  <b> Solution:</b>
  
        
          select order_id, runner_id, (distance/duration) as speed
          from runner_orders
          where cancellation is NULL
          order by 2,1;
  <b> Explanation: </b>
  
  runner_orders table contains the assignment information for each order to its corresponding runner_id. It also contains cancellation attribute
  whose value is NULL for successful orders.
  By using the above mentioned columns(runner_id, cancellation) we can extract the count of orders for each runner where cancellation is null to get successful     orders.
  To get the successful orders of the runners not present in runner_orders table we can left join with the runners table and can make the count to zero if it is     not present in runner_orders table.
  
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
  
  runner_orders table contains the assignment information for each order to its corresponding runner_id. It also contains cancellation attribute
  whose value is NULL for successful orders.
  By using the above mentioned columns(runner_id, cancellation) we can extract the count of orders for each runner where cancellation is null to get successful     orders.
  To get the successful orders of the runners not present in runner_orders table we can left join with the runners table and can make the count to zero if it is     not present in runner_orders table.
  
  <b> Result: </b>
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/ffe7d508-b167-4708-807e-1a05f50393f4)
