# C. Ingredient Optimization Solutions & Explanations
<b> 1. What are the standard ingredients for each pizza?</b>
  
  <b> Solution:</b>
        
        select pn.pizza_name, string_agg(pt.topping_name, ', ') as standard_ingredients
        from pizza_recipes pr
        join pizza_names pn
        on pr.pizza_id = pn.pizza_id
        join pizza_toppings pt
        on pr.toppings = pt.topping_id
        group by 1;
  <b> Explanation: </b>
  
  customer_orders table is containing information of all the orders and hence a simple count function over the table will give the result.
  
  <b> Result: </b>
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/6c031112-0533-4c45-a4c3-29f412852ac1)

  
 <b> 2. What was the most commonly added extra?</b>
  
  <b> Solution:</b>
         
         
         select pt.topping_name as common_extras, count(distinct sno) as tot
          from customer_orders_temp c
          join pizza_toppings pt
          on c.extras = pt.topping_id
          where extras is not NULL
          group by 1
          order by 2 desc
          limit 1;
  <b> Explanation: </b>
  
  customer_orders table contains customer_id those who ordered pizzas. A simple count distinct on customer_id will give the necessary result.
  
  <b> Result: </b>
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/6ad10e4a-d559-410f-b583-891b7bb2fc9d)

 <b> 3. What was the most common exclusion?</b>
  
  <b> Solution:</b>
  
        
          select pt.topping_name as common_exclusions, count(distinct sno) as tot
          from customer_orders_temp c
          join pizza_toppings pt
          on c.exclusions = pt.topping_id
          where exclusions is not NULL
          group by 1
          order by 2 desc
          limit 1;
  <b> Explanation: </b>
  
  runner_orders table contains the assignment information for each order to its corresponding runner_id. It also contains cancellation attribute
  whose value is NULL for successful orders.
  By using the above mentioned columns(runner_id, cancellation) we can extract the count of orders for each runner where cancellation is null to get successful     orders.
  To get the successful orders of the runners not present in runner_orders table we can left join with the runners table and can make the count to zero if it is     not present in runner_orders table.
  
  <b> Result: </b>
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/9a0494e1-9084-473b-b17c-80d43a5e2bff)

  
  <b> 4. Generate an order item for each record in the customers_orders table in the format of one of the following:
       Meat Lovers,
       Meat Lovers - Exclude Beef,
       Meat Lovers - Extra Bacon,
       Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers</b>
  
  <b> Solution:</b>
  
        
          select *, case 
          when POSITION('3' in exclusions) != 0 then 'Meat Lovers - Exclude Beef'
          when POSITION('1' in extras) != 0  then 'Meat Lovers - Extra Bacon'
          when POSITION('1' in exclusions) != 0 and POSITION('4' in exclusions) != 0 and POSITION('6' in extras) != 0
          and POSITION('9' in extras) != 0 then 'Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers'
          else 'Meat Lovers'
          end as order_item
          from customer_orders
          where pizza_id = 1;
  <b> Explanation: </b>
  
  runner_orders table contains the assignment information for each order to its corresponding runner_id. It also contains cancellation attribute
  whose value is NULL for successful orders.
  By using the above mentioned columns(runner_id, cancellation) we can extract the count of orders for each runner where cancellation is null to get successful     orders.
  To get the successful orders of the runners not present in runner_orders table we can left join with the runners table and can make the count to zero if it is     not present in runner_orders table.
  
  <b> Result: </b>
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/d7ffd6d3-8782-46e9-8ee6-85c26ed64174)


  
  <b> 5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table 
      -- and add a 2x in front of any relevant ingredients
      -- For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"</b>
  
  <b> Solution:</b>
  
        
          with cte as
          (
            select distinct c.order_id, c.customer_id, c.pizza_id,c.sno,pr.toppings
            from customer_orders_temp c 
            join pizza_recipes pr
            on c.pizza_id = pr.pizza_id
            order by 4,1,2
          )
          , cte2 as
          (
            (select sno, customer_id, order_id, pizza_id, toppings
            from cte
            union all
            select distinct sno, customer_id, order_id, pizza_id, extras as toppings
            from customer_orders_temp
            where extras is not NULL)
            except all
            (select distinct sno, customer_id, order_id, pizza_id, exclusions as toppings
            from customer_orders_temp
            where exclusions is not NULL)
          )
          ,cte3 as (
          select sno,order_id,customer_id,pizza_id,toppings,count(*) as count_top
          from cte2
          group by 1,2,3,4,5
          order by 1,2,3,5
          )
          , cte4 as (
          select c.sno, c.order_id,c.customer_id, c.pizza_id,
          case when count_top = 2 then CONCAT('2x',pt.topping_name)
          else pt.topping_name
          end
          as ingredient_name
          from cte3 as c
          join pizza_toppings as pt
          on c.toppings = pt.topping_id
          )

          select sno, order_id, customer_id, case when pizza_id = 1 then CONCAT('Meat Lovers: ', string_agg(ingredient_name,', '))
          else CONCAT('Vegetarian: ', string_agg(ingredient_name,', '))
          end as ingredients
          from cte4
          group by 1,2,3,cte4.pizza_id
          order by 1,2,3;
  <b> Explanation: </b>
  
  runner_orders table contains the assignment information for each order to its corresponding runner_id. It also contains cancellation attribute
  whose value is NULL for successful orders.
  By using the above mentioned columns(runner_id, cancellation) we can extract the count of orders for each runner where cancellation is null to get successful     orders.
  To get the successful orders of the runners not present in runner_orders table we can left join with the runners table and can make the count to zero if it is     not present in runner_orders table.
  
  <b> Result: </b>
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/7b0ae49b-d453-4b59-baca-e0c135f17117)


  
  <b> 6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?</b>
  
  <b> Solution:</b>
  
        
          with cte as
          (
            select distinct c.order_id, c.customer_id, c.pizza_id,c.sno,pr.toppings
            from customer_orders_temp c 
            join pizza_recipes pr
            on c.pizza_id = pr.pizza_id
            join runner_orders r
            on r.order_id = c.order_id
            where r.cancellation is NULL
            order by 4,1,2
          )
          , cte2 as
          (
            (select sno, customer_id, order_id, pizza_id, toppings
            from cte
            union all
            select distinct sno, customer_id, c.order_id, c.pizza_id, extras as toppings
            from customer_orders_temp c
            join runner_orders r
            on r.order_id = c.order_id
            where r.cancellation is NULL
             and extras is not NULL)
            except all
            (select distinct sno, customer_id, c.order_id, c.pizza_id, exclusions as toppings
            from customer_orders_temp c
            join runner_orders r
            on r.order_id = c.order_id
            where r.cancellation is NULL and 
            exclusions is not NULL)
          )

          select pt.topping_name, count(*) as tot_qty
          from cte2 c
          join pizza_toppings as pt
          on c.toppings = pt.topping_id
          group by 1
          order by 2 desc;
  <b> Explanation: </b>
  
  runner_orders table contains the assignment information for each order to its corresponding runner_id. It also contains cancellation attribute
  whose value is NULL for successful orders.
  By using the above mentioned columns(runner_id, cancellation) we can extract the count of orders for each runner where cancellation is null to get successful     orders.
  To get the successful orders of the runners not present in runner_orders table we can left join with the runners table and can make the count to zero if it is     not present in runner_orders table.
  
  <b> Result: </b>
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/4dca778a-5636-4e5b-be5d-b9bd922e25c2)

