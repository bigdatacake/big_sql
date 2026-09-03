select * from customer_orders co;

-- Total customers by order date
select order_date, count(customer_id) total_customers
from customer_orders
group by order_date;


-- First visit by every customer
select customer_id, min(order_date) first_visit
from customer_orders
group by customer_id
order by 1;


-- Flag first (F) and repeat (R) visit by each customer
with
first_order as(
	select customer_id, min(order_date) first_visit
	from customer_orders
	group by customer_id
)
select c.customer_id, c.order_date, f.first_visit,
	case 
		when c.order_date = f.first_visit then 'F' else 'R' 
	end repeat_customer
from customer_orders c join first_order f  
on c.customer_id = f.customer_id
order by c.order_date;


-- Count Flags for first (F) and repeat (R) visit by each customer
-- Sort by order date
with
first_order as(
	select customer_id, min(order_date) first_visit
	from customer_orders
	group by customer_id
)
select c.order_date,
count(
	case 
		when c.order_date = f.first_visit then 'F' 
	end
) new_customer,
count(
	case 
		when c.order_date != f.first_visit then 'R' 
	end
) repeat_customer
from customer_orders c join first_order f  
on c.customer_id = f.customer_id
group by c.order_date 
order by c.order_date;