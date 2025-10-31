--schemas
create table city(
city_id int primary key,
city_name varchar(50),
population bigint,
estimated_rent float,
city_rank int
);

create table customers(
customer_id int primary key,
customer_name varchar(50),
city_id int,
constraint fkey_city foreign key(city_id) references city(city_id)
);

create table products(
product_id int primary key,
product_name varchar(50),
price float
);

create table sales(
sales_id int primary key,
sale_date date,
product_id int,
constraint fkey_product foreign key(product_id) references products(product_id),
customer_id int,
constraint fkey_customer foreign key(customer_id) references customers(customer_id),
total float,
rating int
);
