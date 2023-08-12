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
  
  <img width="300" height="500" src = "https://user-images.githubusercontent.com/81607668/135704564-30250dd9-6381-490a-82cf-d15e6290cf3a.png"> 
  
    
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

   1. monthly payments always occur on the same day of month as the original start_date of any monthly paid plan
   2. upgrades from basic to monthly or pro plans are reduced by the current paid amount in that month and start immediately
   3. upgrades from pro monthly to pro annual are paid at the end of the current billing period and also starts at the end of the month period
   4. once a customer churns they will no longer make payments
 
  
# 📝Things learnt
 1. Extensively used CTE,joins,group by.
 2. Recursive CTE to generate month series
 3. Window Functions(Lead,lag,rank,row_number)
 4. Width bucket to break the intervals into buckets


# 🤨Insights
 🥑 There are a total of **1000 customers** who subscribed for foodie fi.
 
 🥑 Every **customer** is **starting** their foodie fi journey with **trial plan**.
 
 🥑 **Most** of the **trial plan enrollments** is observed in the month of **March** and **July**.
 
 🥑 The **least** number of **trial plan enrollments** is observed in the month of **February** and **November**.
 
 🥑 **After the year 2020**, **most** of the customers have **churned** their plan.
 
 🥑 Only **few people** have subscribed for **basic monthly** after the year 2020.
 
 🥑 Nearly **30%** people have **churned** their subscription overall.
 
 🥑 Nearly **9%** of people have **churned right after their trial period**.
 
 🥑 Nearly **55%** of the people have opted for **Basic Monthly after their trial period**.
 
 🥑 **4%** of people have opted for **Pro Annualy plan after their trial period**.
 
 🥑 At the **end of the year 2020**,

   * nearly **2%** of the people are in **trial period**,
     
   * **22%** in **basic monthly**,
     
   * **33%** in **pro monthly**,
     
   * **20%** in **pro annual** and
     
   * **24%** have **churned** their subscription.
      
 🥑 In 2020, **19.5%** have **upgraded** to **annual plan**.
 
 🥑 A total of **105 days** has been observed for an existing **customer to switch to annual plan** on an **average**.
 
 🥑 **Zero** customers have **downgraded** from a pro monthly to a basic monthly plan in **2020**.
 
  

   
