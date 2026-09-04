select * from entries e;

-- Total Visits by name
select name, count(name) visits
from entries
group by name;


-- Total Visits by floor 
select name, floor, count(name) visits
from entries
group by name, floor
order by visits desc, floor;


-- Total visits and resources used
select name, count(name) total_visits, string_agg(resources, ', ') 
from entries
group by name;


-- With distinct keyword for resources
-- Rank Floor vitis and take the top 1 row only for each person (Rank = 1)
-- Aggregate the resources used
with
floor_visits as (
	select 	name, count(name) visits, floor, rank() over(partition by name order by count(name) desc) as rnk
	from entries
	group by name, floor
),
resources_used as(
	select name, count(name) total_visits, string_agg(distinct resources, ', ') resources
	from entries
	group by name
)
select f.name, r.total_visits, f.floor most_visited_floor, r.resources resources_used
from floor_visits f join resources_used r
on f.name = r.name
where f.rnk = 1
order by f.name;


-- Without the distinct keyword for resources
-- Select only distinct name and resources used
-- Aggregate the resources used
-- Get the total visits by each person
-- Rank Floor vitis and take the top 1 row only for each person (Rank = 1)
with
unique_resources as(
	select distinct name, resources
	from entries
),
resources_used as(
	select name, string_agg(resources, ', ') resources 
	from unique_resources 
	group by name
),
total_visits as(
	select name, count(name) total_visits
	from entries
	group by name
),
floor_visits as (
	select name, count(name) visits, floor, rank() over(partition by name order by count(name) desc) as rnk
	from entries
	group by name, floor
)
select f.name, t.total_visits, f.floor most_visited_floor, r.resources resources_used
from floor_visits f join total_visits t
on f.name = t.name
join resources_used r
on f.name = r.name
where rnk = 1
order by f.name;