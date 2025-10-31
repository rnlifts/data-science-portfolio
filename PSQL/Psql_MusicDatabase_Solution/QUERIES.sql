
-- q1 who is the senoir most employye based on job title
select * from employee
order by levels desc
limit 1;

-- q2 which country have the most invoice?
select count(*) as c, billing_country
from invoice
group by billing_country
order by c desc;

-- q3 what are the top 3 values of total invoice?
select total from invoice
order by total desc
limit 3;

--q4 write a query that returrns one city that has the highest sum of invoice.
select billing_city, sum(total) as highest_sum_invoice
from invoice
group by billing_city
order by highest_sum_invoice desc
limit 1;

--q5 write a query that returns the person who has spent the most money
with first_cte as (
select * from customer as c
inner join invoice as i
on c.customer_id = i.customer_id)
select first_name, last_name, sum(total) as total_bill
from first_cte
group by first_name, last_name
order by total_bill desc
limit 1;

--q6 write a query to return the email, firstname,lastname, and genre
--of all rock music listener, return ordered alphabetically by email starting with a

with second_cte as (
select c.first_name, c.last_name, c.email, g.name as genre
from customer as c
inner join invoice as i
on c.customer_id = i.customer_id
inner join invoice_line as il
on il.invoice_id = i.invoice_id
inner join track as t
on t.track_id = il.track_id
inner join genre as g
on g.genre_id = t.genre_id
)
select first_name, last_name, email, genre
from second_cte
where genre ='Rock' and email ilike 'a%'
order by email;

--q7 Let's invite the artists who have written the most rock music in our dataset. Write a 
--query that returns the Artist name and total track count of the top 10 rock bands 

with third_cte as (
select a.name as artist_name, g.name as genre
from artist as a
join album as ab
on a.artist_id = ab.artist_id
join track as t
on ab.album_id = t.album_id
join genre as g
on g.genre_id = t.genre_id
)
select artist_name, genre, count(genre) as track_count
from third_cte
where genre like 'Rock'
group by artist_name, genre
order by track_count desc
limit 10;

--q8 Return all the track names that have a song length longer than the average song length. 
--Return the Name and Milliseconds for each track. Order by the song length with the 
--longest songs listed first

select name , milliseconds
from track
where milliseconds > (select avg(milliseconds) from track)
order by milliseconds desc;

--q9 Find how much amount spent by each customer on artists? Write a query to return 
--customer name, artist name and total spent
with fourth_cte as (
select  c.first_name,c.last_name,il.unit_price * quantity as total_amount,
a.name as artist_name
from customer as c
join invoice as i
on c.customer_id = i.customer_id
join invoice_line as il
on i.invoice_id = il.invoice_id
join track as t
on t.track_id = il.track_id
join album as ab
on ab.album_id = t.album_id
join artist as a
on a.artist_id = ab.artist_id
)
select concat(first_name,' ', last_name) as full_name, artist_name, sum(total_amount) as amount_spent
from fourth_cte
group by full_name, artist_name
order by amount_spent desc;

--q10 We want to find out the most popular music Genre for each country. We determine the 
--most popular genre as the genre with the highest amount of purchases. Write a query 
--that returns each country along with the top Genre. For countries where the maximum 
--number of purchases is shared return all Genres 


with fifth_cte as (
select c.country, g.name as genre
from customer as c
join invoice as i
on c.customer_id = i.customer_id
join invoice_line as il
on i.invoice_id = il.invoice_id
join track as t
on t.track_id = il.track_id
join genre as g
on t.genre_id = g.genre_id
),
genre_count as (
select country, genre, count(*) as purchases
from fifth_cte
group by country, genre
)

select country, genre, purchases,
dense_rank() over(partition by country order by purchases desc)
as rank
from genre_count
order by country,rank;

--q11Write a query that determines the customer that has spent the most on music for each 
--country. Write a query that returns the country along with the top customer and how 
--much they spent. For countries where the top amount spent is shared, provide all 
--customers who spent this amount 

with  customer_spending as (
select c.first_name || ' ' || c.last_name as full_name, c.country, sum(i.total) as total_purchase
from customer as c
join invoice as i
on c.customer_id = i.customer_id
group by full_name, country
order by total_purchase desc
), ranked as (
select full_name, country, total_purchase,
dense_rank() over(partition by country order by total_purchase desc) as ranking from customer_spending)
select full_name, country, total_purchase
from ranked
where ranking =1
order by country;