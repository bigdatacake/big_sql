https://www.sql-practice.com/
northwind.db questions

-- Show the category_name and description from the categories table sorted by category_name.
SELECT 
	category_name, description 
FROM categories
order by category_name;

-- Show all the contact_name, address, city of all customers which are not from 'Germany', 'Mexico', 'Spain'
SELECT 
	contact_name, address, city
FROM customers
where 1 = 1
and country not in ('Germany', 'Mexico', 'Spain');

-- Show order_date, shipped_date, customer_id, Freight of all orders placed on 2018 Feb 26
SELECT 
	order_date, shipped_date, customer_id, freight
FROM orders
where 1 = 1
and order_date='2018-02-26';

-- Show the employee_id, order_id, customer_id, required_date, shipped_date from all orders shipped later than the required date
SELECT 
	employee_id, order_id, customer_id, required_date, shipped_date
FROM orders
where 1 = 1
and shipped_date>required_date;

-- Show all the even numbered Order_id from the orders table
SELECT 
	order_id
FROM orders
where 1 = 1
and order_id % 2 = 0;

-- Show the city, company_name, contact_name of all customers from cities which contains the letter 'L' in the city name, sorted by contact_name
SELECT 
	city, company_name, contact_name
FROM customers
where 1 = 1
and lower(city) like '%l%'
order by contact_name;

-- Show the company_name, contact_name, fax number of all customers that has a fax number. (not null)
SELECT 
	company_name, contact_name, fax
FROM customers
where 1 = 1
and fax is not NULL;

-- Show the first_name, last_name. hire_date of the most recently hired employee.
SELECT 
	first_name, last_name, hire_date
FROM employees
order by hire_date desc
limit 1;

SELECT 
	first_name, last_name, max(hire_date) as hire_date
FROM employees;

-- Show the average unit price rounded to 2 decimal places, the total units in stock, total discontinued products from the products table.
SELECT 
    round(avg(unit_price), 2) as average_price, 
    sum(units_in_stock) as total_stock,
    sum(discontinued) as total_discontinued
FROM products;


-- Show the ProductName, CompanyName, CategoryName from the products, suppliers, and categories table
SELECT 
	p.product_name,
    s.company_name,
    c.category_name
FROM products p join categories c
on p.category_id = c.category_id
join suppliers s
on p.supplier_id = s.supplier_id;


-- Show the category_name and the average product unit price for each category rounded to 2 decimal places.
SELECT 
    c.category_name,
    round(avg(p.unit_price),2) average_unit_price
FROM products p join categories c
on p.category_id = c.category_id
group by c.category_name;

-- Show the city, company_name, contact_name from the customers and suppliers table merged together.
-- Create a column which contains 'customers' or 'suppliers' depending on the table it came from.
SELECT 
    city,
    company_name,
    contact_name,
    'customers' as relationship
FROM customers
union all
SELECT 
    city,
    company_name,
    contact_name,
    'suppliers' as relationship
FROM suppliers;

-- Show the total amount of orders for each year/month.
SELECT 
	year(order_date) as order_year,
    month(order_date) as order_month,
    count(order_id) as no_of_orders
FROM orders
group by order_year, order_month;

-- Show the employee's first_name and last_name, a "num_orders" column with a count of the orders taken, and a column called "Shipped" that displays "On -- Time" if the order shipped_date is less or equal to the required_date, "Late" if the order shipped late, "Not Shipped" if shipped_date is null.
-- Order by employee last_name, then by first_name, and then descending by number of orders.
select 
	e.first_name,
    e.last_name,
    count(o.order_id) num_orders,
    case
    	when o.shipped_date > o.required_date then 'Late'
        when o.shipped_date <= o.required_date then 'On Time'
        ELSE 'Not Shipped'
    END as shipped
from employees e join orders o
on e.employee_id = o.employee_id
where 1 = 1
group by e.first_name, e.last_name, shipped
order by e.last_name, e.first_name, num_orders desc;


-- Show how much money the company lost due to giving discounts each year, order the years from most recent to least recent. Round to 2 decimal places
select 
    year(o.order_date) as order_year,
    round(sum((p.unit_price*d.discount) * d.quantity),2) as discount_amount
from orders o join order_details d
on o.order_id = d.order_id
join products p
on p.product_id = d.product_id
group by order_year
order by order_year desc;