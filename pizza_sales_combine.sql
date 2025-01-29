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
