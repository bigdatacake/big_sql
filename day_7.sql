select * from orders o;

select sum(sales)
from orders; 

select count(distinct product_id), (count(distinct product_id)*.20) products_20_percent  
from orders;  -- 1862, 372

select count(product_id ) total_products 
from orders;  -- 9994

select (sum(sales) * 0.8) sales_80_percent
from orders;  -- 1837760.7771199606

select product_id, sum(sales) product_sales
from orders 
group by product_id
order by 2 desc ;


-- Total Products 1862
-- Around 413 products make up sales of 1837241.99 
-- This is close to 80% of total sales  1837760.78
with 
product_wise_sales as(
	select product_id, sum(sales) product_sales
	from orders 
	group by product_id
)
select product_id, 
product_sales,
sum(product_sales) over (order by product_sales desc rows between unbounded preceding and 0 preceding) as running_sales,
0.8 * sum(product_sales) over() as total_sales
from product_wise_sales;

select (413.0/1862.0); -- 0.22

-- List only those products that make up 80% of the total sales
with 
product_wise_sales as(
	select product_id, sum(sales) product_sales
	from orders 
	group by product_id
),
running_sales as(
	select product_id, 
	product_sales,
	sum(product_sales) over (order by product_sales desc rows between unbounded preceding and 0 preceding) as running_sales,
	0.8 * sum(product_sales) over() as total_sales
	from product_wise_sales
)
select * 
from running_sales 
where running_sales <= total_sales;