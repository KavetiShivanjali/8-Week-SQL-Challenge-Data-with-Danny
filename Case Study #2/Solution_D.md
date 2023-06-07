# D.  💵⭐Pricing and Ratings Solutions & Explanations
<b> 1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes 
-- how much money has Pizza Runner made so far if there are no delivery fees?</b>
  
  <b> Solution:</b>
        
        select sum(case when pizza_id = 1 then 12
        else 10
        end) as tot_rev
        from customer_orders;
  <b> Explanation: </b>
  
  To find the total revenue given the prizes for each pizza i.e., 12 dollars for Meat Lovers and 10 dollars for Vegetarian pizza. We can use case statement to add 12 when the pizza is Meat lover and 10 else. Summing these values will result in total revenue from all the orders.
  
  <b> Result: </b>
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/d02306cc-0244-425f-8177-df83e8b235b7)

  
 <b> 2.  What if there was an additional $1 charge for any pizza extras?
--   Add cheese is $1 extra</b>
  
  <b> Solution:</b>
         
         
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
  <b> Explanation: </b>
  
  We need to find the total extras included in every order. Summing up the total extras would give us the total revenue from only extras. Adding this extra's revenue to the original revenue will yield the revenue of all the ordered pizzas with extras.
  
  <b> Result: </b>
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/05829673-d9d3-45d6-89f1-dc85389a2b96)


 <b> 3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, 
-- how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.</b>
  
  <b> Solution:</b>
  
        
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

        select * from runner_orders_temp
  <b> Explanation: </b>
  
  To including the new attribute rating, I created a new table which contains runner_orders information along with ratings as an added attribute. I used random numbers to populate values for ratings belonging to each order.
  
  <b> Result: </b>
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/c88b58f3-18b4-4dab-8393-f67760805655)

  
  <b> 4.  Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
-- customer_id,
-- order_id,
-- runner_id,
-- rating,
-- order_time,
-- pickup_time,
-- Time between order and pickup,
-- Delivery duration,
-- Average speed,
-- Total number of pizzas</b>
  
  <b> Solution:</b>
  
        
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
  <b> Explanation: </b>
  
  To get all the required information we need to join two tables customer_orders and runner_orders_temp and apply the necessary aggregate functions as and when required along with group by over the order_id to get the information for each order_id.
  
  <b> Result: </b>
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/00937fc7-b07d-43b4-8648-ac7846765cae)


  
  <b> 5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and 
-- each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?</b>
  
  <b> Solution:</b>
  
        
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
  <b> Explanation: </b>
  
  To get the Runners left over we need pizza_id, distance covered by each runner, so we need to gather all the information by using join operation on customer_orders and runner_orders. By using case statement to separate Meat Lovers pizza from Vegetarian pizza we can add its corresponding rates and remove the runners payment using the distance from runner_orders will give the left over revenue after the delivery.
  
  <b> Result: </b>
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/acba5f7c-9616-4fd2-8a2a-9c95afe82b53)
