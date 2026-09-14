create table sales ( product_id int, period_start date, period_end date, average_daily_sales int ); 
insert into sales values(1,'2019-01-25','2019-02-28',100),(2,'2018-12-01','2020-01-01',10),(3,'2019-12-01','2020-01-31',1);

select * from sales;

with RECURSIVE
cte_numbers as(
	select 1 as num		-- Anchor query runs only once
	union all
	select num + 1		-- Recursive query
	from cte_numbers
	where num < 10		-- end when condition is false 
)
select num
from cte_numbers;


select 
	product_id, 
	period_start, 
	period_end, 
	average_daily_sales, 
	(period_end-period_start)+1 days_between, 
	((period_end-period_start)+1) * average_daily_sales total_sales  
from sales;


with recursive
total_sales as(
	select min(period_start) min_date, max(period_end) max_date
	from sales
	union all
	select (min_date + 1) min_date, max_date as max_date
	from total_sales
	where min_date < max_date
)
select s.product_id, date_part('year', t.min_date) report_year, sum(average_daily_sales) total_amount
from total_sales t join sales s
on t.min_date between s.period_start and s.period_end
group by report_year, s.product_id
order by s.product_id, report_year;

