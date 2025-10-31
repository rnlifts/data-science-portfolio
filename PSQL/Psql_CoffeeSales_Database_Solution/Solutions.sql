--QUESTIONS AND ANSWER

--q1 How many people in each city are estimated to consume coffee, give
-- that 25% of the population does?
select city_name,round(population * 0.25) as consumer
from city
order by consumer desc;

--q2 what is the total revenue generated from coffee sales across cities in last qtr of 2023
select ct.city_name, sum(s.total) as total_sales
from city as ct
join customers as c
on c.city_id = ct.city_id
join sales as s
on s.customer_id = c.customer_id
where sale_date >= '2023-10-01'
and sale_date< '2024-01-01'
group by ct.city_name
order by total_sales desc;

--Q3 How many units of each coffee product have been sold?
select p.product_name, count(product_name) as units_sold
from products as p
join sales as s
on p.product_id = s.product_id
group by product_name 
order by units_sold desc;

--q4 what is the average sales amount per customer in each city?

select c.customer_name, ct.city_name, avg(s.total) as average_spending
from city as ct
join customers as c
on ct.city_id = c.city_id
join sales as s
on c.customer_id = s.customer_id
group by city_name, customer_name
order by average_spending desc;

--q5 provide a list of cities along with their populations and estimated coffee consumers
select ct.city_name, ct.population, round(population * 0.25) as consumer
from city as ct
order by consumer desc;

