# 🥑Foodie-Fi
<p align = "center">
<img width="300" height="300" src = "https://user-images.githubusercontent.com/81607668/129742132-8e13c136-adf2-49c4-9866-dec6be0d30f0.png"> 
</p>

# 🔢Problem Statement
Danny finds a few smart friends to launch his new startup Foodie-Fi in 2020 and started selling monthly and annual subscriptions, giving their customers unlimited on-demand access to exclusive food videos from around the world!
Danny created Foodie-Fi with a data driven mindset and wanted to ensure all future investment decisions and new features were decided using data. This case study focuses on using subscription style digital data to answer important business questions.

# 📊Datasets
There are 2 Datasets available with respect to Food-Fi.
* plans
* subscriptions

# ♻️Entity Relationship Diagram
<p align = "center">
<img src = "https://user-images.githubusercontent.com/81607668/129744449-37b3229b-80b2-4cce-b8e0-707d7f48dcec.png" width="450" height="200">
</p>

# 🤔Case Study questions
<h3> A. 🛃Customer Journey </h3>
          
  Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief description about each customer’s onboarding journey.
  Try to keep it as short as possible - you may also want to run some sort of join to make your explanations a bit easier
  sample from the subscriptions table
  <img width="300" height="300" src = "https://user-images.githubusercontent.com/81607668/135704564-30250dd9-6381-490a-82cf-d15e6290cf3a.png"> 
  
    
 <h3> B. 📈📉Data Analysis Questions</h3>
 
   1. How many customers has Foodie-Fi ever had?
   2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
   3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
   4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
   5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
   6. What is the number and percentage of customer plans after their initial free trial?
   7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
   8. How many customers have upgraded to an annual plan in 2020?
   9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
   10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
   11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?
 
 <h3> C.💸🪙Challenge Payment Question</h3>
 
   The Foodie-Fi team wants you to create a new payments table for the year 2020 that includes amounts paid by each customer in the subscriptions table with the following requirements:

  (i). monthly payments always occur on the same day of month as the original start_date of any monthly paid plan
  (ii). upgrades from basic to monthly or pro plans are reduced by the current paid amount in that month and start immediately
  (iii). upgrades from pro monthly to pro annual are paid at the end of the current billing period and also starts at the end of the month period
  (iv). once a customer churns they will no longer make payments
 
  
# 📝Things learnt
 1. Extensively used CTE,joins,group by.
 2. Recursive CTE to generate month series
 3. Window Functions(Lead,lag,rank,row_number)
 4. Width bucket to break the intervals into buckets


# 🤨Insights
 
  

   
