drop table if exists transactions;

create table transactions(
order_id int,
cust_id int,
order_date date,
amount int
);

delete from transactions;
insert into transactions values 
(1,1,'2020-01-15',150)
,(2,1,'2020-02-10',150)
,(3,2,'2020-01-16',150)
,(4,2,'2020-02-25',150)
,(5,3,'2020-01-10',150)
,(6,3,'2020-02-20',150)
,(7,4,'2020-01-20',150)
,(8,5,'2020-02-20',150)
;

select * from transactions;


-- Self Join the table
-- List customers with previous month order and current month order
select 
	pm.cust_id, pm.order_date previous_order,
	cm.cust_id, cm.order_date current_order
from transactions pm left join transactions cm
on pm.cust_id = cm.cust_id and (date_part('month', cm.order_date) - date_part('month', pm.order_date) = 1)
where 1 = 1
and date_part('month', pm.order_date) = 1;


-- Group by month
-- Get customers who purchased previous month also
select 
	date_part('month', pm.order_date) current_month,
	count(distinct pm.cust_id) customers_churn
from transactions pm left join transactions cm
on cm.cust_id = pm.cust_id and (abs(date_part('month', cm.order_date) - date_part('month', pm.order_date)) = 1)
where 1 = 1
and cm.cust_id is null
group by date_part('month', pm.order_date);
