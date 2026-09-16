drop table if exists orders;
drop table if exists products;


create table orders
(
order_id int,
customer_id int,
product_id int
);

insert into orders VALUES 
(1, 1, 1),
(1, 1, 2),
(1, 1, 3),
(2, 2, 1),
(2, 2, 2),
(2, 2, 4),
(3, 1, 5);

create table products (
id int,
name varchar(10)
);

insert into products VALUES 
(1, 'A'),
(2, 'B'),
(3, 'C'),
(4, 'D'),
(5, 'E');



select * from products;
select * from orders;

select 
	o.order_id,
	o.customer_id,
	o.product_id,
	p.name
from orders o join products p
on o.product_id = p.id
order by o.order_id;



-- Orders and products sold
select 
	o.order_id,
	string_agg(o.product_id::varchar, ',') order_product_ids,
	string_agg(p.name, ',') order_product_names
from orders o join products p
on o.product_id = p.id
group by order_id
order by 1;


-- Join the Order table to itself to get each sold product combo
select
	o1.order_id,
	o1.product_id,
	o2.product_id
from orders o1 join orders o2
on o1.order_id = o2.order_id;

-- Remove duplicated rows and keep only one sold product combo
select
	o1.order_id,
	o1.product_id,
	o2.product_id
from orders o1 join orders o2
on o1.order_id = o2.order_id
where 1 = 1 
-- and o1.product_id = o2.product_id -- Will remove exact duplicates
and o1.product_id < o2.product_id;    -- Keep only distinct sold product combo


-- Join the Product table to get the product details for product1 and product2
select
	o1.order_id,
	o1.product_id,
	o2.product_id,
	p1.name product_1,
	p2.name product_2
from orders o1 join orders o2
on o1.order_id = o2.order_id
join products p1 
on p1.id = o1.product_id
join products p2 
on p2.id = o2.product_id
where 1 = 1 
and o1.product_id < o2.product_id
order by order_id;


-- Get the frequency of products sold in combination/together 
select
	concat(p1.name , ' | ', p2.name) product_bought_together, count(*) frequency
from orders o1 join orders o2
on o1.order_id = o2.order_id
join products p1 
on p1.id = o1.product_id
join products p2 
on p2.id = o2.product_id
where 1 = 1 
and o1.product_id < o2.product_id
group by concat(p1.name , ' | ', p2.name)
order by frequency desc;