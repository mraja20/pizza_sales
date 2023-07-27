select count(*) from pizzas;
select * from order_details;
select * from pizzas;

select * from pizza_types;
select * from orders;

-- select orders.order_id, orders.order_date, orders.order_time ,
-- order_details.order_details_id, order_details.pizza_id, order_details.quantity,
-- pizzas.pizza_id, pizzas.pizza_type_id, pizzas.size, pizzas.price ,
 -- pizza_types.category, pizza_types.ingredients from orders
-- inner join order_details on orders.order_id=order_details.order_id
-- inner join order_details on order_details.pizza_id=pizzas.pizza_id
-- inner join pizza_types on pizzas_pizza_type_id=pizza_types.pizza_type_id;

SET SQL_SAFE_UPDATES = 0;
select * from orders;

desc orders;  # to check data types 

update orders
set order_date=str_to_date(order_date,"%d-%m-%Y");  # to change date format to default date format in my sql

ALTER TABLE orders 
modify COLUMN order_date date; # changing the data type of a column


-- Q1) How many customers do we have each day? 
select * from orders;

select order_id, order_date, order_time, 
  weekday(order_date) as day_of_week,
 case when weekday(order_date)='0' then 'Monday' 
    when weekday(order_date)='1' then 'Tuesday' 
    when weekday(order_date)='2' then 'Wednesday' 
    when weekday(order_date)='3' then 'Thursday' 
    when weekday(order_date)='4' then 'Friday' 
    when weekday(order_date)='5' then 'Saturday' 
    when weekday(order_date)='6' then 'Sunday' 
    
    end as day_of_week  from orders;  

select count(x.order_id) as total_orders, x.day_of_week1 from 
(select order_id, order_date, order_time, 
  weekday(order_date) as day_of_week,
 case when weekday(order_date)='0' then 'Monday' 
    when weekday(order_date)='1' then 'Tuesday' 
    when weekday(order_date)='2' then 'Wednesday' 
    when weekday(order_date)='3' then 'Thursday' 
    when weekday(order_date)='4' then 'Friday' 
    when weekday(order_date)='5' then 'Saturday' 
    when weekday(order_date)='6' then 'Sunday' 
    
    end as day_of_week1  from orders) x 
group by x.day_of_week1 ,  x.day_of_week
order by x.day_of_week;


-- Q2) What is the busiest time in the day?

select * from orders;

 desc orders;
 
 select count(order_id), left(order_time, 2) from orders
 group by left(order_time, 2)
 order by left(order_time, 2) asc;
 select left(order_time, 2) from orders;
 
 
--  Q3) How many orders are we expecting each day?

select sum(x.total_orders) / count(x.order_date) as average_no_of_orders_per_day from
(select count(distinct order_id)  total_orders, order_date
from orders
group by order_date) x ;


-- Q4) What are our best and worst selling pizzas?

select * from pizza_types;
select * from pizzas;
select * from order_details;
select * from orders;

with temp1(a,b) as (
select pizza_id, count(quantity) from order_details
group by pizza_id
order by pizza_id),

temp2(c,d) as (
select pizza_id, sum(price) from pizzas

group by pizza_id
order by pizza_id) 

select temp1.a, temp1.b, temp2.d , round(temp1.b *temp2.d, 2) as total_sales from temp1, temp2
order by total_sales desc;


--  Q5) How many pizzas are typically in an order?

select * from pizza_types;
select * from pizzas;
select * from order_details;
select * from orders;

select round(count(o.order_details_id) / count(distinct o.order_id),2) as average_no_of_pizzas_per_order
from order_details o;

-- Q6)  Identify the peak and crest days ?

select count(order_id) as no_of_orders , order_date from orders
group by order_date
order by no_of_orders desc
limit 1;

select count(order_id) as no_of_orders , order_date from orders
group by order_date
order by no_of_orders asc
limit 1;

-- Q7) How much revenue did store make this year? 



