# 🧹Data Cleaning and Transformation
<h3>1. Table: Cleaning runner_orders</h3>
   
   <b> Need to be done: </b>
   * Update columns cancellation, pickup_time, distance and duration values which contain "" and "null" to NULL values
   * Extract numbers from alphanumeric values in columns distance and duration.
   * Alter the data type for pickup_time to datetime format
   * Alter the data type for distance and duration to float
   
   <b> Code snippets: </b>
   
          -- Update code
          update runner_orders
          set cancellation = case when cancellation = 'null' then replace(cancellation, 'null', NULL)
          else replace(cancellation, '', NULL)
          end 
          where cancellation = '' or cancellation = 'null';
          
          --Extract numbers code
          UPDATE runner_orders
          set distance = TRIM(SUBSTRING(distance,1,POSITION('k' in distance)-1))
          where POSITION('k' in distance) != 0;
          
          -- Alter data type code
          ALTER TABLE runner_orders
          ALTER COLUMN pickup_time TYPE timestamp
          USING pickup_time::timestamp;
    
    
   <b> Final Table: </b>
    
   ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/442fdf02-c0af-4872-a66e-0744de1afc2b)

<h3>2. Table: Cleaning customer_orders</h3>
  
  <b> Need to be done: </b>
     
   * Alter data type of order_time to datetime format.
   * Create a temporary table to store unnested values of multivalue columns extras and exclusions.
   * Alter data type of columns present in customer_orders temporary table.
   
  <b> Code snippets: </b>
      
       --Alter data type code
        ALTER TABLE customer_orders
        ALTER COLUMN order_time TYPE timestamp
        USING order_time::timestamp;
        
        --Creating and inserting into Temporary table "customer_orders_temp"
        create temp table customer_orders_temp
        (
          "order_id" INTEGER,
          "customer_id" INTEGER,
          "pizza_id" INTEGER,
          "exclusions" VARCHAR(4),
          "extras" VARCHAR(4),
          "order_time" TIMESTAMP,
        "sno" INTEGER
        );

        insert into customer_orders_temp
        with cte as
        (select *, row_number() over() as sno from customer_orders
         )
        select order_id,customer_id,pizza_id,t1.exclusions,t2.extras,order_time, sno
        from cte
           cross join lateral unnest(coalesce(nullif(string_to_array(exclusions,', '),'{}'),array[null::VARCHAR(4)])) as t1(exclusions)
           cross join lateral unnest(coalesce(nullif(string_to_array(extras,', '),'{}'),array[null::VARCHAR(4)])) as t2(extras);
           
        --Altering data types for temporary tables
        ALTER table customer_orders_temp
        ALTER COLUMN extras TYPE INTEGER
        USING extras::INTEGER
        
   <b> Final tables (temporary and original)</b>
   * customer_orders table (original)
   ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/96fadd0f-6676-4830-a0f6-d3b07fe19c23)
   * customer_orders_temp table (temporary)
   ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/352bf6ad-dd9d-4ebd-871f-d01b9fe03e05)

 <h3>3. Table: Cleaning pizza_recipes</h3>
  
  <b> Need to be done:</b>
  
  * Create a temporary table.
  * Insert data Unnest toppings coulmn into single valued column.
  * Alter data types
  * Make this temporary table as original table by truncating existing values and inserting new values

  <b> Code snippets:</b>
       
        -- Temporary table
        create temp table pizza_recipes_temp
        (
          "pizza_id" INTEGER,
          "toppings" TEXT
        )

        insert into pizza_recipes_temp
        select pizza_id,t.toppings
        from pizza_recipes
        cross join lateral unnest(coalesce(nullif(string_to_array(toppings,', '),'{}'),array[null::TEXT])) as t(toppings);
        
        --Altering table
        ALTER table pizza_recipes_temp
        ALTER COLUMN toppings TYPE INTEGER
        USING toppings::INTEGER;
        
        --Shifting contents from temporary data to original data
        TRUNCATE TABLE pizza_recipes;
        insert into pizza_recipes
        select * from pizza_recipes_temp;
        
  <b> Final table: </b>
  
  ![image](https://github.com/KavetiShivanjali/8-Week-SQL-Challenge-Data-with-Danny/assets/30626886/af658196-2a47-4b14-91b0-f1781a6478f6)

        
        

  
     

   
    
