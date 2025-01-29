# Data-analysis-of-pizza_sales-using-SQL

-- 1 Retrieve the total number of orders placed.

select count(order_id) as total_order from orders;

![image](https://github.com/user-attachments/assets/7f0580ad-ed46-4a51-8a1a-67d4baa1228c)



-- 2 Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS total_sales
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id;

  ![image](https://github.com/user-attachments/assets/c406024d-684c-4da1-98ca-6d799a324af6)

    
  -- 3 Identify the highest-priced pizza.

SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;

![image](https://github.com/user-attachments/assets/5e397f1c-9b05-44c2-b88e-bdfdba650bad)


-- 4 Identify the most common pizza size ordered.

SELECT 
    pizzas.size,
    COUNT(order_details.orderdetails_id) AS order_count
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC
LIMIT 1;

![image](https://github.com/user-attachments/assets/340ab386-d7f9-4305-8674-31466830110a)


-- 5 List the top 5 most ordered pizza types along with their quantities.
SELECT 
    pizza_types.name, SUM(order_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY quantity DESC
LIMIT 5;

![image](https://github.com/user-attachments/assets/c10b0747-a889-4bc4-9950-fdd33e1d6bfe)




-- 6 Join the necessary tables to find the total quantity of each pizza category ordered.


SELECT 
    pizza_types.category,
    SUM(order_details.quantity) AS quantity
FROM 
    pizza_types
JOIN 
    pizzas
ON 
    pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN 
    order_details
ON 
    order_details.pizza_id = pizzas.pizza_id
GROUP BY 
    pizza_types.category
    order by quantity desc;

    ![image](https://github.com/user-attachments/assets/8cee3c1b-660d-4066-b062-11a1c2dd9931)

    
  -- 7 Determine the distribution of orders by hour of the day.

SELECT 
    HOUR(order_time) as hour , COUNT(order_id) as order_count
FROM
    orders
GROUP BY HOUR(order_time);

k![image](https://github.com/user-attachments/assets/c080674d-874c-4a47-b449-c0ed9b3c4642)



-- 8 Join relevant  tables to find the category-wise distribution of pizzas.

select category, count(name) from pizza_types
group by category;

![image](https://github.com/user-attachments/assets/a5ad2eac-166a-4506-8e28-2ba4d6e8a2a6)



--  9 Group the orders by date and calculate the average number of pizzas ordered per day.
select round(avg(quantity),0)from
(select sum(order_details.quantity)as quantity,orders.order_date as date
from order_details join orders
on order_details.order_id=orders.order_id
group by date)as order_quantity;

![image](https://github.com/user-attachments/assets/6110a182-0537-4bf4-a280-64a3b1ee326d)


-- 10 Determine the top 3 most ordered pizza types based on revenue.
select pizza_types.name as pizza_names,
sum(order_details.quantity*pizzas.price)as revenue
from pizza_types join pizzas
on pizzas.pizza_type_id=pizza_types.pizza_type_id
join order_details
on order_details.pizza_id=pizzas.pizza_id
group by pizza_names
order by revenue desc limit 3;

![image](https://github.com/user-attachments/assets/f1d2ed9d-9ba6-450d-9452-184b738b592f)


-- 11 Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select name,revenue,category from
(select category,name, revenue,
rank() over (partition by category order by revenue desc) as rn
from
(select pizza_types.category,pizza_types.name,
sum(order_details.quantity*pizzas.price) as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.category,pizza_types.name)as a) as b
where rn<=3;

![image](https://github.com/user-attachments/assets/63829579-4172-4fd8-8656-636956365c14)


-- 12 Analyze the cumulative revenue generated over time.
select order_date,
sum(revenue)over(order by order_date) as cum_revenue
from
(select orders.order_date,
sum(order_details.quantity*pizzas.price)as revenue
from orders join order_details
on orders.order_id=order_details.order_id
join pizzas
on order_details.pizza_id=pizzas.pizza_id
group by orders.order_date)as sales;

![image](https://github.com/user-attachments/assets/0fac3a87-0055-4c0c-9481-529159e95347)


-- 13 Calculate the percentage contribution of each pizza type to total revenue.
select pizza_types.category,
round(sum(order_details.quantity *pizzas.price) /
(select sum(order_details.quantity*pizzas.price)
from pizza_types join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details
on order_details.pizza_id=pizzas.pizza_id)*100.2)as revenuepercent
from pizza_types join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.category order by revenuepercent desc;

![image](https://github.com/user-attachments/assets/1817ac4a-9e58-4c7c-b359-12387624bda3)

TO FORM A COMBINED TABLE 

SELECT 
    orders.order_id,
    orders.order_date,
    orders.order_time,
    order_details.orderdetails_id,
    order_details.order_id,
    order_details.quantity,
    order_details.pizza_id,
    pizzas.pizza_id,
    pizzas.pizza_type_id,
	pizzas.size,
	pizzas.price,
    pizza_types.pizza_type_id,
	pizza_types.name,
    pizza_types.category,
    pizza_types.ingredients
FROM 
    orders
JOIN 
    order_details 
    ON orders.order_id = order_details.order_id
JOIN 
    pizzas ON order_details.pizza_id = pizzas.pizza_id
JOIN 
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id;

   ![image](https://github.com/user-attachments/assets/00f5d278-33b8-4735-9ac3-d9940940a98c)





    
    
    
    
