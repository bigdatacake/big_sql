select * from trips;
select * from users;

-- Get all trip details
select 
	t.id, 
	t.client_id,
	t.driver_id,
	t.status,
	t.request_at,
	u.banned
from trips t join users u
on t.client_id = u.users_id
order by t.id;

-- First get total trips by unbannded users
-- Secondly get all cancelled trips by unbanned users
-- Join the two CTEs to get the numbers and percentages
with 
total_trips as(
select 
	t.request_at,
	count(t.id) total_trips
from trips t join users u
on t.client_id = u.users_id
and u.banned = 'No'
group by t.request_at
),
cancelled_trips as(
select 
	t.request_at,
	count(t.id) cancelled_trips
from trips t join users u
on t.client_id = u.users_id
where 1 = 1
and t.status like 'cancelled_by_%'
and u.banned = 'No'
group by t.request_at
)
select 
	t.request_at,
	t.total_trips,
	coalesce(c.cancelled_trips, 0) cancelled_trips,
	round(coalesce(c.cancelled_trips, 0) * 1.0 / (t.total_trips * 1.0),4) * 100 cancel_percentage 
from total_trips t left join cancelled_trips c
on t.request_at = c.request_at
order by 1;

