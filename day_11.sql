drop table emp;

create table emp(
emp_id int,
emp_name varchar(20),
department_id int,
salary int,
manager_id int,
emp_age int);

insert into emp
values
(1, 'Ankit', 100,10000, 4, 39),
(2, 'Mohit', 100, 15000, 5, 48),
(3, 'Vikas', 100, 10000,4,37),
(4, 'Rohit', 100, 5000, 2, 16),
(5, 'Mudit', 200, 12000, 6,55),
(6, 'Agam', 200, 12000,2, 14),
(7, 'Sanjay', 200, 9000, 2,13),
(8, 'Ashish', 200,5000,2,12),
(9, 'Mukesh',300,6000,6,51),
(10, 'Rakesh',300,7000,6,50);


select * from emp;

-- To find Median
-- When total number of items is odd, median lies in the center of the range
-- When total number of items is even, median is the average of the 2 numbers that lies in the center of the range

-- Method 1
-- When odd number of items
with 
row_nums_combined as (
select 
	e.*,
	row_number() over(order by e.emp_age asc) as r_num_asc,
	row_number() over(order by e.emp_age desc) as r_num_dsc
from emp e
where 1 = 1
and emp_id < 10 -- Odd number of items
order by e.emp_age)
select 
	avg(r.emp_age)
from row_nums_combined r
where 1 = 1
and abs((r.r_num_dsc - r.r_num_asc)) <= 1;

-- When even number of items
with 
row_nums_combined as (
select 
	e.*,
	row_number() over(order by e.emp_age asc) as r_num_asc,
	row_number() over(order by e.emp_age desc) as r_num_dsc
from emp e
order by e.emp_age)
select 
	avg(r.emp_age)
from row_nums_combined r
where 1 = 1
and abs((r.r_num_dsc - r.r_num_asc)) <= 1;


-- Method 2
select 
	PERCENTILE_CONT(0.5) within group (order by emp_age) as median_age
from emp
where emp_id<10;

select 
	department_id,
	PERCENTILE_CONT(0.5) within group (order by emp_age) as median_age
from emp
group by department_id;



-- Median Salary
select 
	department_id,
	PERCENTILE_CONT(0.5) within group (order by salary) as median_salary
from emp
group by department_id;


with 
combined_rows as(
select 
	e.*,
	row_number() over(order by e.salary asc) as r_sal_asc,
	row_number() over(order by e.salary desc) as r_sal_dsc
from emp e
order by e.salary 
)
select 
	r.department_id,
	avg(r.salary)
from combined_rows r
where 1 = 1
and abs(r.r_sal_dsc - r.r_sal_asc) <= 1
group by r.department_id;