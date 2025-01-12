create database Faasos_Analysis;

use faasos_analysis;
CREATE TABLE driver(
	driver_id int ,
    reg_date date
);

INSERT INTO driver(driver_id,reg_date) VALUES 
(1,'2021-01-01'),
(2,'2021-01-03'),
(3,'2022-01-08'),
(4,'2023-01-15');

CREATE TABLE ingredients(ingredients_id integer,ingredients_name varchar(60)); 

INSERT INTO ingredients(ingredients_id ,ingredients_name) 
 VALUES (1,'BBQ Chicken'),
(2,'Chilli Sauce'),
(3,'Chicken'),
(4,'Cheese'),
(5,'Kebab'),
(6,'Mushrooms'),
(7,'Onions'),
(8,'Egg'),
(9,'Peppers'),
(10,'schezwan sauce'),
(11,'Tomatoes'),
(12,'Tomato Sauce');

drop table if exists rolls;
CREATE TABLE rolls(roll_id integer,roll_name varchar(30)); 

INSERT INTO rolls(roll_id ,roll_name) 
 VALUES (1	,'Non Veg Roll'),
(2	,'Veg Roll');

drop table if exists rolls_recipes;
CREATE TABLE rolls_recipes(roll_id integer,ingredients varchar(24)); 

INSERT INTO rolls_recipes(roll_id ,ingredients) 
 VALUES (1,'1,2,3,4,5,6,8,10'),
(2,'4,6,7,9,11,12');

drop table if exists driver_order;
CREATE TABLE driver_order(order_id integer,driver_id integer,pickup_time datetime,distance VARCHAR(7),duration VARCHAR(10),cancellation VARCHAR(23));
INSERT INTO driver_order(order_id,driver_id,pickup_time,distance,duration,cancellation) 
 VALUES(1,1,'2021-01-01 18:15:34','20km','32 minutes',''),
(2,1,'2021-01-01 19:10:54','20km','27 minutes',''),
(3,1,'2021-01-03 00:12:37','13.4km','20 mins','NaN'),
(4,2,'2021-01-04 13:53:03','23.4','40','NaN'),
(5,3,'2021-01-08 21:10:57','10','15','NaN'),
(6,3,null,null,null,'Cancellation'),
(7,2,'2021-01-08 21:30:45','25km','25mins',null),
(8,2,'2021-01-10 00:15:02','23.4 km','15 minute',null),
(9,2,null,null,null,'Customer Cancellation'),
(10,1,'2021-01-11 18:50:20','10km','10minutes',null);


drop table if exists customer_orders;
CREATE TABLE customer_orders(order_id integer,customer_id integer,roll_id integer,not_include_items VARCHAR(4),extra_items_included VARCHAR(4),order_date datetime);
INSERT INTO customer_orders(order_id,customer_id,roll_id,not_include_items,extra_items_included,order_date)
values (1,101,1,'','','2021-01-01  18:05:02'),
(2,101,1,'','','2021-01-01 19:00:52'),
(3,102,1,'','','2021-01-02 23:51:23'),
(3,102,2,'','NaN','2021-01-02 23:51:23'),
(4,103,1,'4','','2021-01-04 13:23:46'),
(4,103,1,'4','','2021-01-04 13:23:46'),
(4,103,2,'4','','2021-01-04 13:23:46'),
(5,104,1,null,'1','2021-01-08 21:00:29'),
(6,101,2,null,null,'2021-01-08 21:03:13'),
(7,105,2,null,'1','2021-01-08 21:20:29'),
(8,102,1,null,null,'2021-01-09 23:54:33'),
(9,103,1,'4','1,5','2021-01-10 11:22:59'),
(10,104,1,null,null,'2021-01-11 18:34:49'),
(10,104,1,'2,6','1,4','2021-01-11 18:34:49');

select * from customer_orders;
select * from driver_order;
select * from ingredients;
select * from driver;
select * from rolls;
select * from rolls_recipes;

-- Q1. How many rolls were ordered ?   

select count(roll_id) as Ordered_count from customer_orders;

-- Q2. How many unique orders are made by customers ?

select count(distinct customer_id) as UniqueCustomers from customer_orders;

-- Q3. How many successful orders were delivered by each driver ?

select driver_id,count(driver_id) as Successful_Order_Count from driver_order
where cancellation<>'Cancellation' AND cancellation<>'Customer Cancellation' or cancellation is null
group by driver_id;


-- Q4. How many of each type of rolls are delivered 

select c.roll_id,count(c.roll_id) from driver_order d 
join customer_orders c on d.order_id=c.order_id 
and (d.cancellation not in ('Cancellation','Customer Cancellation') or d.cancellation is null) 
group by c.roll_id;

-- Q5. How many Veg , Non-veg rolls were ordered by customer
select * from customer_orders;
select c.customer_id,r.roll_name as Roll_Type,count(r.roll_name) as Roll_Count from customer_orders c join rolls r on c.roll_id=r.roll_id
group by c.customer_id,r.roll_name
order by c.customer_id;


-- Q6. What was the maximum number of rolls were oredered in single time

select * from customer_orders;

select order_id,count(roll_id) as Max_ordered_rolls from customer_orders 
group by order_id
order by Max_ordered_rolls desc limit 1;

-- Data Cleaning for better operations

with temp_customer_orders (order_id,customer_id,roll_id,not_include_items,extra_items_included,order_date) as
(
	select order_id,customer_id,roll_id,
    case when not_include_items is null or not_include_items = '' then '0' else not_include_items end as new_not_include_items,
    case when extra_items_included in('NULL','Nan','') or extra_items_included is null then '0' else extra_items_included end as new_extra_items_included,
    order_date
    from customer_orders
)
select * from temp_customer_orders;


with temp_driver_orders (order_id,driver_id,pickup_time,distance,duration,cancellation) as
(
	select order_id,driver_id,pickup_time,distance,duration,
	case when cancellation in ('Cancellation','Customer Cancellation') then 0 else 1 end as new_cancellation
	from driver_order
)
select * from temp_driver_orders;

-- Q7. for each customer, how many delivered rolls ordered had changes and how many not changes ?
with temp_customer_orders (order_id,customer_id,roll_id,not_include_items,extra_items_included,order_date) as
(
	select order_id,customer_id,roll_id,
    case when not_include_items is null or not_include_items = '' then '0' else not_include_items end as new_not_include_items,
    case when extra_items_included in('NULL','Nan','') or extra_items_included is null then '0' else extra_items_included end as new_extra_items_included,
    order_date
    from customer_orders
)

select customer_id,sum(not_include_items<>'0' or extra_items_included<>'0') as changed_orders,sum(not_include_items='0' and extra_items_included='0') as not_changed_orders from temp_customer_orders
group by customer_id;


-- Q8. how many rolls were delivered that has both exclusion and extras
with temp_customer_orders (order_id,customer_id,roll_id,not_include_items,extra_items_included,order_date) as
(
	select order_id,customer_id,roll_id,
    case when not_include_items is null or not_include_items = '' then '0' else not_include_items end as new_not_include_items,
    case when extra_items_included in('NULL','Nan','') or extra_items_included is null then '0' else extra_items_included end as new_extra_items_included,
    order_date
    from customer_orders
)

select customer_id,sum(not_include_items<>'0' and extra_items_included<>'0') as Both_exc_inc,sum(not_include_items='0' or extra_items_included='0') as Either_exc_inc from temp_customer_orders
group by customer_id;


-- Q9. What was the total number of rolls ordered for each hour of a day
select *,dayname(order_date) from customer_orders;

select concat(hour(order_date),'-',if(hour(order_date)+1=24,'00',hour(order_date)+1)) as Hour_Intervals,count(*) from customer_orders
group by Hour_Intervals;


-- Q10. What was the number of orders for each day of the week 
select dayname(order_date) as DAY,count(*) from customer_orders
group by DAY;


-- Q11. What was the average time in minutes it took for each driver to arrive at fassos HQ and pickup the order ?
select * from driver_order; 

SELECT 
    d.driver_id,
    AVG(TIMESTAMPDIFF(MINUTE, c.order_date, d.pickup_time)) AS avg_pickup_time
FROM 
    customer_orders c
JOIN 
    driver_order d 
ON 
    c.order_id = d.order_id
WHERE 
    d.pickup_time IS NOT NULL  -- Ensure we only consider orders with a valid pickup time
GROUP BY 
    d.driver_id;
    


-- Q12. What was the average distance travelled for the customer

select c.customer_id,round(avg(d.distance),2),sum(d.distance) from customer_orders c join driver_order d on c.order_id=d.order_id
group by c.customer_id;


-- Q13. What was the diffrence between shortes and longest delivery time

select max(duration)-min(duration) as Diffrence from driver_order;


-- Q14. What was the average speed for each driver for each delivery and do you notice any trend for these values

select order_id,driver_id,concat(avg(round(distance/duration,4)), ' km') as Avg_Speed from driver_order
where distance is not null or duration is not null
group by order_id,driver_id;

-- For Trend Observation
select d.order_id,d.driver_id,concat(avg(round(d.distance/d.duration,4)), ' km') as Avg_Speed,count(d.order_id) from driver_order d join customer_orders c on d.order_id=c.order_id
where distance is not null or duration is not null
group by order_id,driver_id;


-- Q15. What is the successful order percentage for driver
select * from driver_order;

select driver_id,round((sum(pickup_time is not null)/count(driver_id))*100,2) as Success_Rate from driver_order
group by driver_id;