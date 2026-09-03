select * from emp;

-- Employees and their Managers
select
	e.emp_id,
	e.emp_name,
	e.salary,
	e.manager_id,
	m.emp_name manager_name,
	m.salary
from
	emp e
join emp m
on
	e.manager_id = m.emp_id
order by
	1; 

-- Employees whose salary is more than their Managers
select
	e.emp_id,
	e.emp_name,
	e.salary,
	e.manager_id,
	m.emp_name manager_name,
	m.salary manager_salary
from
	emp e
join emp m
on
	e.manager_id = m.emp_id
where
	e.salary > m.salary
order by
	1;
