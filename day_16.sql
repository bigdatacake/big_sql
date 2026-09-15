drop table if exists users;
drop table if exists events;
create table users
(
user_id integer,
name varchar(20),
join_date date
);
insert into users
values
(1, 'Jon', CAST('2020-02-14' as date)), 
(2, 'Jane', CAST('2020-02-14' AS date)), 
(3, 'Jill', CAST('2020-02-15' AS date)), 
(4, 'Josh', CAST('2020-02-15' AS date)), 
(5, 'Jean', CAST('2020-02-16' AS date)), 
(6, 'Justin', CAST('2020-02-17' AS date)),
(7, 'Jeremy', CAST('2020-02-18' AS date));

create table events
(
user_id integer,
type varchar(10),
access_date date
);

insert into events values
(1, 'Pay', CAST('2020-03-01' AS date)), 
(2, 'Music', CAST('2020-03-02' AS date)), 
(2, 'P', CAST('2020-03-12' AS date)),
(3, 'Music', CAST('2020-03-15' AS date)), 
(4, 'Music', CAST('2020-03-15' AS date)), 
(1, 'P', CAST('2020-03-16' AS date)), 
(3, 'P', CAST('2020-03-22' AS date));

select * from users;
select * from events;

-- First, find all users who accessed Music
-- Second, find all users who subscribed/accessed Prime within 30 days of joining
-- Count of prime subscribers / total users who accessed Music
with 
music_users as(
select 
	u.user_id, u.name, u.join_date, 
	e.type, e.access_date
from users u join events e
on u.user_id = e.user_id
where e.type = 'Music'
),
prime_users as(
select
	m.user_id, m.name, m.join_date join_date,
	e.type, e.access_date prime_access_date, 
	(e.access_date-m.join_date) prime_in_30_days 
from events e join music_users m
on e.user_id = m.user_id
where 1 = 1
and e.type = 'P'
and (e.access_date-m.join_date)<= 30
)
select
	round((count(prime_in_30_days)* 1.0) / (select count(*) from music_users), 4)*100 conversion_rate
from
	prime_users;