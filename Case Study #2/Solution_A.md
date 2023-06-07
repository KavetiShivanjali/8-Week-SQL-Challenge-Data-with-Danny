# A. Pizza Metric Solutions & Explanations
<b> 1. How many pizzas were ordered?</b>
  
  <b> Solution:</b>
        
        select count(order_id) as tot_pizzas from customer_orders;
  <b> Explanation: </b>
  
  customer_orders table is containing information of all the orders and hence a simple count function over the table will give the result.
  
  <b> Result: </b>
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/92f8b9e3-c921-4d70-84aa-062d4f31aca7)
  
 <b> 2. How many unique customer orders were made?</b>
  
  <b> Solution:</b>
         
         
         select count(distinct customer_id) as tot_cust from customer_orders;
  <b> Explanation: </b>
  
  customer_orders table contains customer_id those who ordered pizzas. A simple count distinct on customer_id will give the necessary result.
  
  <b> Result: </b>
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/e5c93817-3dc7-4faa-9516-9cf7cf72f51d)

 <b> 3. How many successful orders were delivered by each runner?</b>
  
  <b> Solution:</b>
  
        
          select r.runner_id, COALESCE(count(distinct ro.order_id),0) as suc_orders 
          from runners r
          left join
          (select * from runner_orders
          where cancellation is  NULL) ro
          on r.runner_id = ro.runner_id
          group by r.runner_id;
  <b> Explanation: </b>
  
  runner_orders table contains the assignment information for each order to its corresponding runner_id. It also contains cancellation attribute
  whose value is NULL for successful orders.
  By using the above mentioned columns(runner_id, cancellation) we can extract the count of orders for each runner where cancellation is null to get successful     orders.
  To get the successful orders of the runners not present in runner_orders table we can left join with the runners table and can make the count to zero if it is     not present in runner_orders table.
  
  <b> Result: </b>
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/206a9dc6-8535-4fe6-ba82-56f0e533c2bc)
  
  <b> 4. How many of each type of pizza was delivered?</b>
  
  <b> Solution:</b>
  
        
          select c.pizza_id, count(r.order_id) as tot_pizza 
          from customer_orders c
          join runner_orders r
          on c.order_id = r.order_id
          where r.cancellation is NULL
          group by 1;
  <b> Explanation: </b>
  
   To get the count of each pizza type successfully delivered, we need to gather information containing pizza and delivery status. This information comes from
   two tables customer_orders which contains pizza_type in the form of pizza_id and runner_orders containing delivery status information in the form of   cancellation. After joining these tables, we need to count the orders for each pizza which clearly hints the use of group by over pizza_id.
  
  <b> Result: </b>
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/e4e56616-ae20-4e67-808d-5b835b9b245c)

  
  <b> 5. How many Vegetarian and Meatlovers were ordered by each customer?</b>
  
  <b> Solution:</b>
  
        
          select customer_id, sum(case when pizza_id = 1 then 1 else 0 end) as meatlovers_count,
          sum(case when pizza_id = 2 then 1 else 0 end) as veg_count
          from customer_orders
          group by 1
          order by 1;
  <b> Explanation: </b>
  
  To get the count of a sub-category for each category we can use sum over case statements. Each sum would represent for each sub-category. Inside sum we can add a conditional statement such as case to trigger when that sub-category is triggered just by simply storing as 1 when the sub-category condition is met else 0.
  By summing over this case statement will actually give the count of that particular sub-category. At the end, we need it for each category so a simple group by over category will do the needful. Considering, customers as cateories and pizzas as sub-categories the above code will give the following result.
  
  <b> Result: </b>
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/5418bfa4-c31e-4286-9386-fcc5c0e8a6a8)

  
  <b> 6. What was the maximum number of pizzas delivered in a single order?</b>
  
  <b> Solution:</b>
  
        
          select order_id, count(order_id) as count_pizza
          from customer_orders
          group by 1
          order by 2 desc
          limit 1;
  <b> Explanation: </b>
  
  As we need to find the maximum number of pizzas delivered in a single order, we have to gather the information related to orders primarily. For each order_id we
  need to get the total count of orders done in customer_orders table, a simple group by over order_id will give the required results.
  
  <b> Result: </b>
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/50dc57d8-6cad-4c15-81da-1fb1714344f4)

  
  <b> 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?</b>
  
  <b> Solution:</b>
  
        
          select customer_id, sum(case when extras is NULL and exclusions is NULL then 1 else 0 end) as nochng_sum,
          sum(case when extras is not NULL or exclusions is not NULL then 1 else 0 end) as chng_sum
          from customer_orders
          join runner_orders
          on customer_orders.order_id = runner_orders.order_id
          where cancellation is NULL
          group by 1
  <b> Explanation: </b>
   
   By change here, I think it is the exclusions and extras. As they are talking for each delivered pizza, we need to consider cancellation status by which we require to join customer_orders which contains customer details and runner_orders which contains cancellation information. After joining the tables we need to check the orders for each customer_id whether a change is included or not which can easily done by case statements. If a change is included we can count as 1 else 0 for changed_orders and vice-versa for unchanged orders. To get the total orders we enclose case statements in sum function and gorup by over customer_id will give the required results. 
   
  <b> Result: </b>
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/71df260f-7e7c-41e9-86fc-4923136114b3)

  
  <b> 8. How many pizzas were delivered that had both exclusions and extras?</b>
  
  <b> Solution:</b>
  
        
          select count(customer_orders.order_id) as tot_pizzas
          from customer_orders
          join runner_orders
          on customer_orders.order_id = runner_orders.order_id
          where extras is not NULL and exclusions is not NULL;
  <b> Explanation: </b>
  
  To get the extras and exclusions information we need customer_orders table, to get delivery status details we need runner_orders. So, a join of these tables will provide the entire information. To include only extras and exclusions we can add a where clause which eliminates other combinations of extras and exclusions.
  By counting the order_id we get the exact answer needed.
  
  <b> Result: </b>
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/99e554eb-3efc-4aeb-8b6a-93b878239512)
  
  <b> 9. What was the total volume of pizzas ordered for each hour of the day?</b>
  
  <b> Solution:</b>
  
        
          select EXTRACT(hour from order_time) as "Hour", count(order_id) as tot_vol
          from customer_orders
          group by 1
          order by 2 desc;
  <b> Explanation: </b>
  
  To get the hourly information, we need to capture the order_time information from customer_orders and extract hours. After extracting hours, we can count the order_id for each hour by adding a group by clause over hour information. 
  
  <b> Result: </b>
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/7d61c98c-e639-4d06-9554-909c43fc691e)
  
  <b> 10. What was the volume of orders for each day of the week?</b>
  
  <b> Solution:</b>
  
        
          select to_char(order_time,'Day') as "Day", count(order_id) as tot_vol
          from customer_orders
          group by 1
          order by 2 desc;
  <b> Explanation: </b>
  
  To get the weekly information, we extract weekday from order_time and count the order_id for each weekday by adding a group by clause.
  
  <b> Result: </b>
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/f4b4702b-7f6c-4d23-ac56-043495c1c7b9)

  
  

  
  
  
  

  
