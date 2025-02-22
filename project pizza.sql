use pizza;
-- Q1. Retrieve the total nummber of orders placed.
select count(order_id) from orders;

-- Q2. Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS total_revenue
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id;

-- Q3.Identify the highest-priced pizza.

 SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY price DESC
LIMIT 1;
 
 -- Q3 Identify the most common pizza size ordered.
select pizzas.size, count(order_details.order_details_id)
from pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size;

-- Q4. List the top 5 most ordered pizza types along with their quantities.
SELECT 
    pizza_types.name,
    count(order_details.order_details_id)as total_orders,
    SUM(order_details.quantity) as total_quantity
FROM
pizza_types
        JOIN pizzas
     ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN order_details
        on order_details.pizza_id = pizzas.pizza_id
        group by pizza_types.name;
        
-- Q5. Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    pizza_types.category,
    SUM(order_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category;

-- Q6. Determine the distribution of orders by hour of the day.
SELECT 
    HOUR(orders.time), COUNT(orders.order_id)
FROM
    orders
GROUP BY HOUR(orders.time);

-- Q7 Join relevant tables to find the category-wise distribution of pizzas.
SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category;

-- Q8 Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT 
    ROUND(AVG(quantity), 2)
FROM
    (SELECT 
        orders.date, SUM(order_details.quantity) AS quantity
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.date) AS order_quantity;
    
-- Q9 Determine the top 3 most ordered pizza types based on revenue.
SELECT 
    pizza_types.name,
    order_details.quantity * pizzas.price AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
ORDER BY revenue DESC
LIMIT 3;

-- Q10 Calculate the percentage contribution of each pizza type to total revenue.
SELECT 
    pizza_types.category,
    ROUND((SUM(order_details.quantity * pizzas.price) / (SELECT 
                    ROUND(SUM(order_details.quantity * pizzas.price),
                                2) AS total_revenue
                FROM
                    order_details
                        JOIN
                    pizzas ON pizzas.pizza_id = order_details.pizza_id)) * 100,
            2) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue;

-- Q11 Analyze the cumulative revenue generated over time.

select date,
sum(rev) over (order by date ) as cum_rev
from
(select orders.date,
sum(order_details.quantity * pizzas.price) as rev
from order_details
join pizzas on order_details.pizza_id = pizzas.pizza_id
join orders
on orders.order_id = order_details.order_id
group by orders.date) as sales;

-- Q12 Determine the top 3 most ordered pizza types based on revenue for each pizza category.


select category, name, revenue,
rank() over (partition by category order by revenue desc) as Ranking
from
(select pizza_types.category, pizza_types.name,
sum((order_details.quantity)*(pizzas.price))as revenue
from pizza_types join
pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category, pizza_types.name) as ar;
