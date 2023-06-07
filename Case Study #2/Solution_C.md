# C. 🥩🥔Ingredient Optimization Solutions & Explanations
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
  
  To get the standard ingredients for each pizza, we need to get the pizza name and its ingredient names. For pizza name ther is pizza names table with pizza_id and pizza name as the two columns. To get the ingredients there is pizza_recipes table with pizza_id and toppings. To get the names of toppings ther is pizza_toppings with topping_id and topping_name. We can join these three tables to get the pizza name and ingredient names and group by pizza_name to get the ingredients for each pizza. 
  
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
  
  To get the most commonly added extras, we need to count the orders for each extra requested. This information I collected from a temporary table which was created during data_preprocessing phase. With this temp table we can get the count for each extra requested and pick the top extra by using order by count descending and by keeping the limit as 1 to select the top row. 
  
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
  To get the most commonly added exclusion, we need to count the orders for each exclusion requested. This information I collected from a temporary table which was created during data_preprocessing phase. With this temp table we can get the count for each exclusion requested and pick the top extra by using order by count descending and by keeping the limit as 1 to select the top row.
  
  
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
  
  As the options above involve only Meat Lovers, so I used a where clause to pick only Meat lovers pizza. By using case statements over the exclusions and extras
  we can categorise each order into 4 options mentioned in the question.
  
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
  
  My approach to this question is as follows.
  
    Step-1: I gathered all the standard ingredients for each pizza ordered by joining the customer orders temp table and pizza recipes table, so that each ordered pizza has a row corresponding to an ingredient being used in it.
    Step-2: From this standard ingedients we need to add the extras and remove the exlusion ingredient if they are mentioned. I used union all to add the extras and except all to remove the exclusion
    Step-3: Count the ingredients for each ordered pizza.
    Step-4: Based on the count mark ingredient as 2X before its name if it's count is 2 else include just the name.
    Step-5: Use string_agg over the ingredient names along with the pizza name to make the final list of ingredients for each ordered pizza.
  
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
  
  My approach to find the total quantity of each ingredient used is as follows.
  
    Step-1: Gather all the delivered pizzas along with their standard ingredients by joining customer_orders_temp, runner_orders, pizza_recipes table.
    Step-2: Add the extras by using union all and remove the exclusions by using except all from the gathered ingredients.
    Step-3: Get the count of each ingredient used.
    Step-4: Order the results based on the count in descending order to get the top ingredients.
  
  <b> Result: </b>
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/4dca778a-5636-4e5b-be5d-b9bd922e25c2)

