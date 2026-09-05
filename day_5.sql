select * from emp_compensation;

-- Using Self Joins
-- Join the table itself for each salary component
select
    e.emp_id,
    s.val as salary,
    b.val as bonus,
    h.val as hike_percent
from (select distinct emp_id from emp_compensation) e
left join emp_compensation s on e.emp_id = s.emp_id and s.salary_component_type = 'salary'
left join emp_compensation b on e.emp_id = b.emp_id and b.salary_component_type = 'bonus'
left join emp_compensation h on e.emp_id = h.emp_id and h.salary_component_type = 'hike_percent';


-- For each row pivot the value into a column
select e.emp_id,
	case when e.salary_component_type='salary' then val end "salary",
	case when e.salary_component_type='bonus' then val end "bonus",
	case when e.salary_component_type='hike_percent' then val end "hike_percent"
from emp_compensation e
order by e.emp_id;


-- Collapse the rows for each employee by agrregating the values
select e.emp_id,
	sum(case when e.salary_component_type='salary' then val end) "salary",
	sum(case when e.salary_component_type='bonus' then val end) "bonus",
	sum(case when e.salary_component_type='hike_percent' then val end) "hike_percent"
from emp_compensation e
group by e.emp_id
order by e.emp_id;

-- Create a table with the pivot values
drop table emp_compensation_pivot;

select e.emp_id,
	sum(case when e.salary_component_type='salary' then val end) "salary",
	sum(case when e.salary_component_type='bonus' then val end) "bonus",
	sum(case when e.salary_component_type='hike_percent' then val end) "hike_percent"
into emp_compensation_pivot
from emp_compensation e
group by e.emp_id
order by e.emp_id;

select * from emp_compensation_pivot;

-- Unpivot the values
select emp_id, 'salary' salary_component_type, salary from emp_compensation_pivot
union 
select emp_id, 'bonus' salary_component_type, bonus from emp_compensation_pivot
union
select emp_id, 'hike_percent' salary_component_type, hike_percent from emp_compensation_pivot
order by 1;
