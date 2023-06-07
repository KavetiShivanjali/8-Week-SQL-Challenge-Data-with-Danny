# 🍕🛵Pizza Runner
<p align = "center">
<img width="300" height="300" src = "https://user-images.githubusercontent.com/81607668/127271856-3c0d5b4a-baab-472c-9e24-3c1e3c3359b2.png"> 
</p>

# 🔢Problem Statement
Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers. He has prepared for us an entity relationship diagram of his database design but requires further assistance to clean his data and apply some basic calculations so he can better direct his runners and optimise Pizza Runner’s operations.

# 📊Datasets
There are 6 Datasets available with respect to Food-Delivery system.
* runner_orders
* runners
* customer_orders
* pizza_names
* pizza_recipes
* pizza_toppings

# ♻️Entity Relationship Diagram
<p align = "center">
<img src = "https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/06b7e81c-7dbf-4da3-8b54-abf8ceee8e49.png" width="450" height="200">
</p>

# 🤔Case Study questions
<h3> A.🍕Pizza Metrics </h3>
          
   1. How many pizzas were ordered?
   2. How many unique customer orders were made?
   3. How many successful orders were delivered by each runner?
   4. How many of each type of pizza was delivered?
   5. How many Vegetarian and Meatlovers were ordered by each customer?
   6. What was the maximum number of pizzas delivered in a single order?
   7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
   8. How many pizzas were delivered that had both exclusions and extras?
   9. What was the total volume of pizzas ordered for each hour of the day?
   10. What was the volume of orders for each day of the week?
    
 <h3> B.🛃Runner and Customer Experience</h3>
 
   1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
   2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
   3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
   4. What was the average distance travelled for each customer?
   5. What was the difference between the longest and shortest delivery times for all orders?
   6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
   7. What is the successful delivery percentage for each runner?
 
 <h3> C.🥩🥔Ingredient Optimisation</h3>
 
   1. What are the standard ingredients for each pizza?
   2. What was the most commonly added extra?
   3. What was the most common exclusion?
   4. Generate an order item for each record in the customers_orders table in the format of one of the following:
      * Meat Lovers
      * Meat Lovers - Exclude Beef
      * Meat Lovers - Extra Bacon
      * Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
   5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any  relevant ingredients
For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
   6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
 
 <h3> D.💵⭐ Pricing and Ratings</h3>
  
   1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
   2. What if there was an additional $1 charge for any pizza extras?
      Add cheese is $1 extra
   3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
   4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
      * customer_id
      * order_id
      * runner_id
      * rating
      * order_time
      * pickup_time
      * Time between order and pickup
      * Delivery duration
      * Average speed
     * Total number of pizzas
  5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?
  
# 📝Things learnt
 1. Data Cleaning in Postgres.
 2. Unnesting multi value columns.
 3. Converting space and "null" strings to NULL values.
 4. Gathering attributes of one single entity using Union and Except.
 5. Changing data types of original attributes.
 6. Extensively used string_agg, CTEs, Datetime functions.
 7. Randmly generated floating numbers in Postgres. 

# 🤨Insights
 1. Total **pizzas** ordered are **14** with total **customers** as **5**.
 2. **Meat Lovers Pizza** is the **most popular pizza** on Pizza Runner when compared to Vegetarian Pizza.🥩🔥
 3. Customers are ordering **Meat Lovers Pizza and Vegetarian Pizza** in the **ratio of 2:1**.🥩🥩:🥕
 4. **1 among 5 customers** have ordered **only Vegetarian Pizzas**.🥕
 5. **2 among 14 Pizzas** ordered have been requested for **both "Exclusion" and "Extras"**.
 6. **Most** of the customers are **requesting to change the standard ingredients** of the pizza ordered.😔
 7. **Delay of service** for **higher orders** is noticed.😔
 8. **6PM, 9PM, 11PM, 1PM** are the **happy hours** as most number of orders are placed during these hours.😀😃
 9. **7PM, 11AM** are the **moderate hours** for orders🙂
 10. **Wednesday. Saturday** are the **peak days for orders** follwed by Thursday and Friday🔥
 11. 1st Week has the highest number of runners signed up, **Work Dissatisfaction** among **runners** is noticed here.😔
 12. **12 mins** is the **average duration** in mins for the **runners to reach Pizza Runner HQ**.1️⃣2️⃣
 13. **30 mins** the **range** of duration **to deliver the pizza**.3️⃣0️⃣
 14. **Bacon** is the **most preferred** ingredient and **Cheese** is the **most excluded** ingredient🥓🧀
 15. **Bacon, Mushrooms and Cheese** are the **highly used** ingredients in Pizza.🥓🍄🧀
 16. **1 among 4** runners hold **100% succesful deliveries**.🔢
 17. **Revenue** generated **without** added charges for **extras** is **$160**.💵
 18. **Revenue** generated **with** added **charges for extras** is **$166**.💵
 19. **Revenue** generated **after runners cut** is **$73.38**.💵  
  

   
