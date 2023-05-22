-- Question-1: What is the total amount each customer spent at the restaurant?
select s.customer_id, sum(m.price) as amount
from dannys_diner.sales s
join dannys_diner.menu m
on s.product_id = m.product_id
group by 1
order by 2 desc;
-- Result
+──────────────+──────────────+
| customer_id  | amount       |
+──────────────+──────────────+
| A            | 76           | 
| B            | 74           |
| C            | 36           |
+──────────────+──────────────+ 

-- Question-2: How many days has each customer visited the restaurant?
select s.customer_id, count(s.order_date) as no_of_visits
from dannys_diner.sales s
group by 1
order by 2 desc;
-- Result 
+──────────────+──────────────+
| customer_id  | no_of_visits |
+──────────────+──────────────+
| A            | 6            |
| B            | 4            |
| C            | 3            |
+──────────────+──────────────+ 

-- Question-3:  What was the first item from the menu purchased by each customer?
with cte as
(
  select customer_id, min(order_date) as first_date
  from dannys_diner.sales
  group by customer_id
 ),
 cte2 as
 (
   select c.customer_id,c.first_date,s.product_id
   from cte c
   join dannys_diner.sales s
   on c.first_date = s.order_date and c.customer_id = s.customer_id
 )
 
 select distinct c.customer_id, m.product_name as first_product
 from cte2 c
 join dannys_diner.menu m
 on c.product_id = m.product_id
 order by 1;
 
 -- Result
+───────────────+──────────────+
| customer_id  | first_product |
+──────────────+───────────────+
| A            | sushi         |
| A            | curry         |
| B            | curry         |
| C            | ramen         |
+──────────────+───────────────+ 

-- Question 4: What is the most purchased item on the menu and how many times was it purchased by all customers?
select m.product_name, count(*) as no_of_orders
from dannys_diner.sales s
join dannys_diner.menu m
on s.product_id = m.product_id
group by 1
order by 2 desc
limit 1;

-- Result
+───────────────+──────────────+
| product_name  | no_of_orders |
+───────────────+──────────────+
| ramen         | 8            |
+───────────────+──────────────+

-- Question 5: Which item was the most popular for each customer?
with cte as
(
  select customer_id, product_id, count(*) as no_of_orders
  from dannys_diner.sales
  group by 1,2
 ),
 cte2 as
 (
   select customer_id,product_id, rank() over(partition by customer_id order by no_of_orders desc) as popular
   from cte
 )
 
 select c.customer_id, m.product_name as popular_item
 from cte2 c
 join dannys_diner.menu m
 on c.product_id = m.product_id
 where c.popular = 1
 order by 1
 
 -- Result
+───────────────+──────────────+
| customer_id   | popular_item |
+───────────────+──────────────+
| A             | ramen        |
| B             | sushi        |
| B             | curry        |
| B             | ramen        |
| C             | ramen        |
+───────────────+──────────────+

-- Question 6: Which item was purchased first by the customer after they became a member?
 
with cte as
(
  select c.customer_id,c.order_date,c.product_id
  from dannys_diner.sales c
  join dannys_diner.members m
  on m.customer_id = c.customer_id and c.order_date >= m.join_date
 ),
 cte2 as
 (
   select c.customer_id, min(c.order_date) as first_date
   from cte c
   group by 1
  ),
 cte3 as
 (select c.customer_id,c.first_date,c2.product_id
  from cte2 c
  join cte c2
  on c.customer_id = c2.customer_id and c.first_date = c2.order_date
 )
 
 select c.customer_id, m.product_name as first_product
 from cte3 c
 join dannys_diner.menu m
 on c.product_id = m.product_id
 
 -- Result
+───────────────+──────────────+
| customer_id   | popular_item |
+───────────────+──────────────+
| B             | sushi        |
| A             | curry        |
+───────────────+──────────────+

-- Question 7: Which item was purchased just before the customer became a member?
with cte as
(
  select c.customer_id,c.order_date,c.product_id
  from dannys_diner.sales c
  join dannys_diner.members m
  on m.customer_id = c.customer_id and c.order_date < m.join_date
 ),
 cte2 as
 (
   select c.customer_id, max(c.order_date) as first_date
   from cte c
   group by 1
  ),
 cte3 as
 (select c.customer_id,c.first_date,c2.product_id
  from cte2 c
  join cte c2
  on c.customer_id = c2.customer_id and c.first_date = c2.order_date
 )
 
 select c.customer_id, m.product_name as last_product
 from cte3 c
 join dannys_diner.menu m
 on c.product_id = m.product_id
 
 -- Result
+───────────────+──────────────+
| customer_id   | last_product |
+───────────────+──────────────+
| B             | sushi        |
| A             | sushi        |
| A             | curry        |
+───────────────+──────────────+

-- Question 8: What is the total items and amount spent for each member before they became a member?
with cte as
(
  select c.customer_id,c.order_date,c.product_id
  from dannys_diner.sales c
  left join dannys_diner.members m
  on m.customer_id = c.customer_id 
  where c.order_date < m.join_date or m.join_date is NULL
 )

   
select cte.customer_id, count(*) as orders_before, sum(m.price) as amount_before
from cte
join dannys_diner.menu m
on cte.product_id = m.product_id
group by 1
order by 2

-- Result
+───────────────+──────────────+──────────────+
| customer_id   | orders_before| amount_before|
+───────────────+──────────────+──────────────+
| A             | 2            | 25           |
| B             | 3            | 40           | 
| C             | 3            | 36           |
+───────────────+──────────────+──────────────+

-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

with cte as
(select s.customer_id, POWER(count(*),2) as tot_sushis_mult
 from dannys_diner.sales s
 join dannys_diner.menu m
 on s.product_id = m.product_id
 where m.product_name = 'sushi'
 group by s.customer_id
 )
 
 , cte1 as
 (select s.customer_id, sum(m.price) as tot_price 
  from dannys_diner.sales s
  join dannys_diner.menu m
  on s.product_id = m.product_id
  group by s.customer_id
 )
 
 select s.customer_id, IFNULL(s.tot_price,0)*10*IFNULL(d.tot_sushis_mult,1) as tot_points
 from cte1 s
 left join cte d
 on s.customer_id = d.customer_id
 order by 2 desc
 
 -- Result
+───────────────+──────────────+
| customer_id   | tot_points   |
+───────────────+──────────────+
| B             | 2960         |
| A             | 760          |
| C             | 360          |
+───────────────+──────────────+

-- Question 10 In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

with cte as
(
  select s.customer_id, count(s.order_date) as tot
  from dannys_diner.sales s
  join dannys_diner.members m
  on s.customer_id = m.customer_id
  where s.order_date between m.join_date and DATE_ADD(m.join_date ,INTERVAL 7 DAY)
  and MONTH(s.order_date) = 1 and YEAR(s.order_date) = 2021
  group by 1
)
, cte1 as
(
  select customer_id, count(*) as tot
  from dannys_diner.sales s
  join dannys_diner.menu m
  on s.product_id = m.product_id
  where m.product_name = 'sushi' and MONTH(s.order_date) = 1 and YEAR(s.order_date) = 2021
  group by s.customer_id
 )
 , cte2 as
 (
 	select customer_id,tot
   from cte
   union all
   select customer_id,tot
   from cte1
 )
 ,cte3 as
 (select customer_id, power(sum(tot),2) as points_multiplier
  from cte2
  group by 1
 )
 ,cte4 as
 (
   select s.customer_id, sum(m.price) as tot_price
   from dannys_diner.sales s
   join dannys_diner.menu m
   on s.product_id = m.product_id
   where MONTH(s.order_date) = 1 and YEAR(s.order_date) = 2021
   group by s.customer_id
  )
 
 select s.customer_id, round(s.tot_price*10*d.points_multiplier) as tot_points
 from cte4 s
 join cte3 d
 on s.customer_id = d.customer_id
 order by 2;
 
 -- Result
+───────────────+──────────────+
| customer_id   | tot_points   |
+───────────────+──────────────+
| B             | 9920         |
| A             | 19000        |
+───────────────+──────────────+

-- Bonus Questions
-- Rank All The Things
with cte as
(
select s.customer_id, s.order_date, m.product_name, m.price, 
case when mem.join_date > s.order_date or mem.join_date is NULL then 'N'
else 'Y' 
end as mem
from dannys_diner.sales s
join dannys_diner.menu m
on s.product_id = m.product_id
left join dannys_diner.members mem
on s.customer_id = mem.customer_id
 )
 
, cte1 as
(
select *,dense_rank() over(partition by customer_id order by order_date) as ranking
from cte
where mem = 'Y'
)

,cte2 as
(select *, NULL as ranking
 from cte
 where mem = 'N'
)

select * from cte2
union all
select * from cte1
order by 1,2;

-- Result
+───────────────+──────────────+───────────────+──────────────+──────────+───────────+
| customer_id   | order_date   | product_name  | price        | mem      | ranking   |
+───────────────+──────────────+───────────────+──────────────+──────────+───────────+
| A		| 2021-01-01   | sushi	       |10	      | N	 | NULL      |
| A		| 2021-01-01   | curry	       |15	      | N	 | NULL      | 	
| A		| 2021-01-07   | curry	       |15	      | Y	 |1          |
| A		| 2021-01-10   | ramen	       |12	      | Y	 |2          |
| A		| 2021-01-11   | ramen	       |12	      | Y	 |3          |
| A		| 2021-01-11   | ramen	       |12	      | Y	 |3          |
| B		| 2021-01-01   | curry	       |15	      | N	 | NULL      |
| B		| 2021-01-02   | curry	       |15	      | N	 | NULL      |
| B		| 2021-01-04   | sushi	       |10	      | N	 | NULL      |
| B		| 2021-01-11   | sushi	       |10	      | Y	 | 1         |
| B		| 2021-01-16   | ramen	       |12	      | Y	 | 2         |
| B		| 2021-02-01   | ramen	       |12	      | Y	 | 3         |
| C		| 2021-01-01   | ramen	       |12	      | N	 | NULL      |
| C		| 2021-01-01   | ramen	       |12	      | N	 | NULL      |
| C		| 2021-01-07   | ramen	       |12	      | N	 | NULL      |
+───────────────+──────────────+───────────────+──────────────+──────────+───────────+


