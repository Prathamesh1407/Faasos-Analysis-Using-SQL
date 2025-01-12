# Faasos Analysis

Welcome to the **Faasos Analysis** repository! This project is designed to analyze various aspects of customer orders, driver operations, and ingredient usage in Faasos' roll deliveries. The project uses SQL to perform detailed analysis of customer behavior, driver performance, and order patterns, all of which are key to improving business decisions and logistics.

## Project Overview

The database consists of the following tables:

- **driver**: Contains information about drivers.
- **ingredients**: Contains ingredients used in rolls.
- **rolls**: Contains roll types like 'Non-Veg Roll' and 'Veg Roll'.
- **rolls_recipes**: Maps rolls to their ingredients.
- **driver_order**: Contains details about driver assignments for orders.
- **customer_orders**: Contains data related to customer orders.

This project helps analyze delivery patterns, order types, and ingredient usage, with a focus on optimizing operations and customer satisfaction.

## Table of Contents

1. [Database Creation](#database-creation)
   - Step 1. Create Database `Faasos_Analysis`
   - Step 2. Create Driver Table
   - Step 3. Create Ingredients Table
   - Step 4. Create Rolls Table
   - Step 5. Create Rolls Recipes Table
   - Step 6. Create Driver Order Table
   - Step 7. Create Customer Orders Table
   - Step 8. Create Stored Procedure to Print All Data
2. [SQL Queries and Answers](#sql-queries-and-answers)
   - Q1. How many rolls were ordered?
   - Q2. How many unique orders were made by customers?
   - Q3. How many successful orders were delivered by each driver?
   - Q4. How many of each type of roll were delivered?
   - Q5. How many Veg/Non-Veg rolls were ordered by customers?
   - Q6. What was the maximum number of rolls ordered in a single order?
   - Q7. For each customer, how many delivered rolls had changes?
   - Q8. How many rolls were delivered with both exclusions and extras?
   - Q9. What was the total number of rolls ordered for each hour of the day?
   - Q10. What was the number of orders for each day of the week?
   - Q11. What was the average time in minutes it took for each driver to arrive at Faasos HQ and pickup the order?
   - Q12. What was the average distance traveled for the customer?
   - Q13. What was the difference between the shortest and longest delivery time?
   - Q14. What was the average speed for each driver for each delivery?
   - Q15. What is the successful order percentage for each driver?


## Database Creation

### Step 1: Create Database

```sql
CREATE DATABASE Faasos_Analysis;
USE faasos_analysis;
```

### Step 2: Create Driver Table
```sql
CREATE TABLE driver (
    driver_id INT,
    reg_date DATE
);
```
Insert Data into Driver Table
```sql
INSERT INTO driver(driver_id, reg_date) VALUES 
(1, '2021-01-01'),
(2, '2021-01-03'),
(3, '2022-01-08'),
(4, '2023-01-15');
```
### Step 3: Create Ingredients Table
```sql
CREATE TABLE ingredients (
    ingredients_id INT,
    ingredients_name VARCHAR(60)
);
```
Insert Data into Ingredients Table
```sql
INSERT INTO ingredients(ingredients_id, ingredients_name) 
VALUES 
(1, 'BBQ Chicken'),
(2, 'Chilli Sauce'),
(3, 'Chicken'),
(4, 'Cheese'),
(5, 'Kebab'),
(6, 'Mushrooms'),
(7, 'Onions'),
(8, 'Egg'),
(9, 'Peppers'),
(10, 'Schezwan Sauce'),
(11, 'Tomatoes'),
(12, 'Tomato Sauce');
```
### Step 4: Create Rolls Table
```sql
DROP TABLE IF EXISTS rolls;
CREATE TABLE rolls (
    roll_id INT,
    roll_name VARCHAR(30)
);
```
Insert Data into Rolls Table
```sql
INSERT INTO rolls(roll_id, roll_name) 
VALUES 
(1, 'Non Veg Roll'),
(2, 'Veg Roll');
```
### Step 5: Create Rolls Recipes Table
```sql
DROP TABLE IF EXISTS rolls_recipes;
CREATE TABLE rolls_recipes (
    roll_id INT,
    ingredients VARCHAR(24)
);
```
Insert Data into Rolls Recipes Table
```sql
INSERT INTO rolls_recipes(roll_id, ingredients) 
VALUES 
(1, '1,2,3,4,5,6,8,10'),
(2, '4,6,7,9,11,12');
```
### Step 6: Create Driver Order Table
```sql
DROP TABLE IF EXISTS driver_order;
CREATE TABLE driver_order (
    order_id INT,
    driver_id INT,
    pickup_time DATETIME,
    distance VARCHAR(7),
    duration VARCHAR(10),
    cancellation VARCHAR(23)
);
```
Insert Data into Driver Order Table
```sql
INSERT INTO driver_order(order_id, driver_id, pickup_time, distance, duration, cancellation) 
VALUES 
(1, 1, '2021-01-01 18:15:34', '20km', '32 minutes', ''),
(2, 1, '2021-01-01 19:10:54', '20km', '27 minutes', ''),
(3, 1, '2021-01-03 00:12:37', '13.4km', '20 mins', 'NaN'),
(4, 2, '2021-01-04 13:53:03', '23.4', '40', 'NaN'),
(5, 3, '2021-01-08 21:10:57', '10', '15', 'NaN'),
(6, 3, NULL, NULL, NULL, 'Cancellation'),
(7, 2, '2021-01-08 21:30:45', '25km', '25mins', NULL),
(8, 2, '2021-01-10 00:15:02', '23.4 km', '15 minute', NULL),
(9, 2, NULL, NULL, NULL, 'Customer Cancellation'),
(10, 1, '2021-01-11 18:50:20', '10km', '10minutes', NULL);
```
### Step 7: Create Customer Orders Table
```sql
DROP TABLE IF EXISTS customer_orders;
CREATE TABLE customer_orders (
    order_id INT,
    customer_id INT,
    roll_id INT,
    not_include_items VARCHAR(4),
    extra_items_included VARCHAR(4),
    order_date DATETIME
);
```
Insert Data into Customer Orders Table
```sql
INSERT INTO customer_orders(order_id, customer_id, roll_id, not_include_items, extra_items_included, order_date)
VALUES 
(1, 101, 1, '', '', '2021-01-01  18:05:02'),
(2, 101, 1, '', '', '2021-01-01 19:00:52'),
(3, 102, 1, '', '', '2021-01-02 23:51:23'),
(3, 102, 2, '', 'NaN', '2021-01-02 23:51:23'),
(4, 103, 1, '4', '', '2021-01-04 13:23:46'),
(4, 103, 1, '4', '', '2021-01-04 13:23:46'),
(4, 103, 2, '4', '', '2021-01-04 13:23:46'),
(5, 104, 1, NULL, '1', '2021-01-08 21:00:29'),
(6, 101, 2, NULL, NULL, '2021-01-08 21:03:13'),
(7, 105, 2, NULL, '1', '2021-01-08 21:20:29'),
(8, 102, 1, NULL, NULL, '2021-01-09 23:54:33'),
(9, 103, 1, '4', '1,5', '2021-01-10 11:22:59'),
(10, 104, 1, NULL, NULL, '2021-01-11 18:34:49'),
(10, 104, 1, '2,6', '1,4', '2021-01-11 18:34:49');
```
### Step 8: View Data from All Tables

You can use the following queries to view the data from all tables:
```sql
SELECT * FROM customer_orders;
SELECT * FROM driver_order;
SELECT * FROM ingredients;
SELECT * FROM driver;
SELECT * FROM rolls;
SELECT * FROM rolls_recipes;
```
### Step 9: Create Stored Procedure

To print all data from the tables, you can create the following stored procedure:
```sql
DELIMITER $$

CREATE PROCEDURE print_all()
BEGIN
    -- Print all data from customer_orders
    SELECT * FROM customer_orders;

    -- Print all data from driver_order
    SELECT * FROM driver_order;

    -- Print all data from ingredients
    SELECT * FROM ingredients;

    -- Print all data from driver
    SELECT * FROM driver;

    -- Print all data from rolls
    SELECT * FROM rolls;

    -- Print all data from rolls_recipes
    SELECT * FROM rolls_recipes;
END$$

DELIMITER ;
```

## SQL Queries and Answers

### Q1. How many rolls were ordered?

The total number of rolls ordered is:

```sql
SELECT count(roll_id) AS Ordered_count FROM customer_orders;
```

### Q2. How many unique orders were made by customers?

The number of unique customers who placed orders is:
```sql
SELECT count(distinct customer_id) AS UniqueCustomers FROM customer_orders;
```

### Q3. How many successful orders were delivered by each driver?

The number of successful orders delivered by each driver (excluding cancellations) is:
```sql
SELECT driver_id, COUNT(driver_id) AS Successful_Order_Count FROM driver_order
WHERE cancellation NOT IN ('Cancellation', 'Customer Cancellation') OR cancellation IS NULL
GROUP BY driver_id;
```

### Q4. How many of each type of roll were delivered?

The number of each type of roll delivered is:
```sql
SELECT c.roll_id, COUNT(c.roll_id) FROM driver_order d
JOIN customer_orders c ON d.order_id = c.order_id
WHERE (d.cancellation NOT IN ('Cancellation', 'Customer Cancellation') OR d.cancellation IS NULL)
GROUP BY c.roll_id;
```
### Q5. How many Veg, Non-Veg rolls were ordered by customers?

The count of Veg and Non-Veg rolls ordered by each customer is:
```sql
SELECT c.customer_id, r.roll_name AS Roll_Type, COUNT(r.roll_name) AS Roll_Count FROM customer_orders c
JOIN rolls r ON c.roll_id = r.roll_id
GROUP BY c.customer_id, r.roll_name
ORDER BY c.customer_id;
```
### Q6. What was the maximum number of rolls ordered in a single order?

The maximum number of rolls ordered in a single order is:
```sql
SELECT order_id, COUNT(roll_id) AS Max_ordered_rolls FROM customer_orders
GROUP BY order_id
ORDER BY Max_ordered_rolls DESC LIMIT 1;
```
### Q7. For each customer, how many delivered rolls had changes and how many did not?

The count of rolls ordered with and without changes for each customer is:
```sql
WITH temp_customer_orders AS (
    SELECT order_id, customer_id, roll_id,
    CASE WHEN not_include_items IS NULL OR not_include_items = '' THEN '0' ELSE not_include_items END AS new_not_include_items,
    CASE WHEN extra_items_included IN ('NULL', 'Nan', '') OR extra_items_included IS NULL THEN '0' ELSE extra_items_included END AS new_extra_items_included,
    order_date
    FROM customer_orders
)
SELECT customer_id,
SUM(not_include_items <> '0' OR extra_items_included <> '0') AS changed_orders,
SUM(not_include_items = '0' AND extra_items_included = '0') AS not_changed_orders
FROM temp_customer_orders
GROUP BY customer_id;
```
### Q8. How many rolls were delivered with both exclusions and extras?

The count of rolls delivered with both exclusions and extras is:

```sql
WITH temp_customer_orders AS (
    SELECT order_id, customer_id, roll_id,
    CASE WHEN not_include_items IS NULL OR not_include_items = '' THEN '0' ELSE not_include_items END AS new_not_include_items,
    CASE WHEN extra_items_included IN ('NULL', 'Nan', '') OR extra_items_included IS NULL THEN '0' ELSE extra_items_included END AS new_extra_items_included,
    order_date
    FROM customer_orders
)
SELECT customer_id,
SUM(not_include_items <> '0' AND extra_items_included <> '0') AS Both_exc_inc,
SUM(not_include_items = '0' OR extra_items_included = '0') AS Either_exc_inc
FROM temp_customer_orders
GROUP BY customer_id;
```
### Q9. What was the total number of rolls ordered for each hour of the day?

The total number of rolls ordered for each hour is:
```sql
SELECT CONCAT(HOUR(order_date), '-', IF(HOUR(order_date) + 1 = 24, '00', HOUR(order_date) + 1)) AS Hour_Intervals, COUNT(*)
FROM customer_orders
GROUP BY Hour_Intervals;
```
### Q10. What was the number of orders for each day of the week?

The number of orders for each day of the week is:
```sql
SELECT DAYNAME(order_date) AS DAY, COUNT(*) FROM customer_orders
GROUP BY DAY;
```
### Q11. What was the average time in minutes it took for each driver to arrive at Faasos HQ and pick up the order?

The average pickup time for each driver is:
```sql
SELECT d.driver_id, AVG(TIMESTAMPDIFF(MINUTE, c.order_date, d.pickup_time)) AS avg_pickup_time
FROM customer_orders c
JOIN driver_order d ON c.order_id = d.order_id
WHERE d.pickup_time IS NOT NULL
GROUP BY d.driver_id;
```
### Q12. What was the average distance traveled for the customer?

The average distance traveled by each customer is:
```sql
SELECT c.customer_id, ROUND(AVG(d.distance), 2), SUM(d.distance)
FROM customer_orders c
JOIN driver_order d ON c.order_id = d.order_id
GROUP BY c.customer_id;
```
### Q13. What was the difference between the shortest and longest delivery time?

The difference in delivery times is:
```sql
SELECT MAX(duration) - MIN(duration) AS Difference FROM driver_order;
```
### Q14. What was the average speed for each driver for each delivery?

The average speed for each driver is:
```sql
SELECT order_id, driver_id, CONCAT(AVG(ROUND(distance / duration, 4)), ' km') AS Avg_Speed
FROM driver_order
WHERE distance IS NOT NULL OR duration IS NOT NULL
GROUP BY order_id, driver_id;
```
### Q15. What is the successful order percentage for each driver?

The successful order percentage for each driver is:
```sql
SELECT driver_id, ROUND((SUM(pickup_time IS NOT NULL) / COUNT(driver_id)) * 100, 2) AS Success_Rate
FROM driver_order
GROUP BY driver_id;
```
