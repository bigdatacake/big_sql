drop table public.emp;

CREATE TABLE public.emp (
	emp_id int4 NULL,
	emp_name varchar(10) NULL,
	salary int4 NULL,
	manager_id int4 NULL,
	department_id int4 NULL
);

INSERT INTO public.emp (emp_id,emp_name,salary,manager_id,department_id) VALUES
	 (1,'Ankit',10000,4,100),
	 (2,'Mohit',15000,5,100),
	 (3,'Vikas',10000,4,100),
	 (4,'Rohit',5000,2,100),
	 (5,'Mudit',12000,6,200),
	 (6,'Agam',12000,2,200),
	 (7,'Sanjay',9000,2,200),
	 (8,'Ashish',5000,2,200);


select * from emp;

select * 
from emp 
where salary > 10000;


select e.department_id, avg(e.salary) avg_dept_sal
from emp e
group by e.department_id;


select e.department_id, avg(e.salary) avg_dept_sal
from emp e
group by e.department_id
having avg(e.salary) > 9500;


select e.department_id, avg(e.salary) avg_dept_sal
from emp e
where e.salary > 10000
group by e.department_id
having avg(e.salary) > 12000;
