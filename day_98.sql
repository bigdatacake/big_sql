drop table if exists booking_table;
create table booking_table (
    booking_id varchar(10),
    booking_date date,
    user_id varchar(10),
    line_of_business varchar(20)
);

truncate table booking_table;
insert into booking_table (booking_id, booking_date, user_id, line_of_business) values
('b1',  '2022-03-23', 'u1', 'Flight'),
('b2',  '2022-03-27', 'u2', 'Flight'),
('b3',  '2022-03-28', 'u1', 'Hotel'),
('b4',  '2022-03-31', 'u4', 'Flight'),
('b5',  '2022-04-02', 'u1', 'Hotel'),
('b6',  '2022-04-02', 'u2', 'Flight'),
('b7',  '2022-04-06', 'u5', 'Flight'),
('b8',  '2022-04-06', 'u6', 'Hotel'),
('b9',  '2022-04-06', 'u2', 'Flight'),
('b10', '2022-04-10', 'u1', 'Flight'),
('b11', '2022-04-12', 'u4', 'Flight'),
('b12', '2022-04-16', 'u1', 'Flight'),
('b13', '2022-04-19', 'u2', 'Flight'),
('b14', '2022-04-20', 'u5', 'Hotel'),
('b15', '2022-04-22', 'u6', 'Flight'),
('b16', '2022-04-26', 'u4', 'Hotel'),
('b17', '2022-04-28', 'u2', 'Hotel'),
('b18', '2022-04-30', 'u1', 'Hotel'),
('b19', '2022-05-04', 'u4', 'Hotel'),
('b20', '2022-05-06', 'u1', 'Flight');

drop table if exists user_table;
create table user_table (
    user_id varchar(10),
    segment varchar(10)
);

truncate table user_table;
insert into user_table (user_id, segment) values
('u1', 's1'),
('u2', 's1'),
('u3', 's1'),
('u4', 's2'),
('u5', 's2'),
('u6', 's3'),
('u7', 's3'),
('u8', 's3'),
('u9', 's3'),
('u10', 's3');


select * from user_table;
select * from booking_table;


-- Segment-wise total user count along with count of users who booked flights in April 2022

-- Total users by each segment
select
    u.segment,
    count(u.user_id) as total_users
from user_table u
group by u.segment;

-- Only distinct users from each segment who booked flights
-- Irrespective of how many flights
-- Total users who booked flight in April 2022
select
    u.segment,
    count(distinct u.user_id) as total_users,
    count( distinct
    case
        when (date_part('month', b.booking_date) = 04 and date_part('year', b.booking_date) = 2022) and b.line_of_business='Flight' then u.user_id -- Get user ID who booked
        else null
    end) as users_booked_flight_april_2022
from user_table u left join booking_table b
on u.user_id = b.user_id
group by u.segment;

-- Identify users whose first booking was a hotel booking
select
    user_id,
    booking_date,
    line_of_business,
    ROW_NUMBER() over(partition by user_id order by booking_date) as first_booking
from booking_table;

with
user_bookings as(
select
    user_id,
    booking_date,
    line_of_business,
    ROW_NUMBER() over(partition by user_id order by booking_date) as first_booking
from booking_table
)
select
    user_id, booking_date, line_of_business, first_booking
from user_bookings
where 1 = 1
and first_booking = 1
and line_of_business = 'Hotel';

-- Calculate the days between first and last booking of the user with id u1
select
    *
from booking_table
where 1 = 1
and user_id = 'u1'
order by booking_date;

select
    user_id,
    min(booking_date) as first_booking_date,
    max(booking_date) as last_booking_date,
    max(booking_date) - min(booking_date) as days_between
from booking_table
where 1 = 1
and user_id = 'u1'
group by user_id;


-- Count the number of flight and hotel bookings in each user segment for year 2022
select
    u.segment,
    b.line_of_business,
    count(b.line_of_business) no_of_bookings
from user_table u join booking_table b
on u.user_id = b.user_id
where 1 = 1
and date_part('YEAR', b.booking_date) = 2022
group by u.segment, b.line_of_business
order by u.segment, b.line_of_business;

select
    u.segment,
    sum(case
        when b.line_of_business = 'Flight' then 1
        else 0
    end) as flight_bookings,
    sum(case
        when b.line_of_business = 'Hotel' then 1
        else 0
    end) as hotel_bookings
from user_table u join booking_table b
on u.user_id = b.user_id
where 1 = 1
and date_part('YEAR', b.booking_date) = 2022
group by u.segment
order by u.segment;


-- Find, for each segment, the user who made the earliest booking in April 2022
-- Also, return how many total bookings that user made in April 2022

select
    u.segment,
    u.user_id,
    b.booking_id,
    b.booking_date,
    rank() over(partition by u.segment order by b.booking_date, b.booking_id) as earlist_booking
from user_table u join booking_table b
on u.user_id = b.user_id
where 1 = 1
and b.booking_date between '2022-04-01' and '2022-04-30';

with
early_booking as(
select
    u.segment,
    u.user_id,
    b.booking_id,
    b.booking_date,
    rank() over(partition by u.segment order by b.booking_date, b.booking_id) as earlist_booking
from user_table u join booking_table b
on u.user_id = b.user_id
where 1 = 1
and b.booking_date between '2022-04-01' and '2022-04-30'
)
select
    e.segment,
    e.user_id,
    e.booking_date,
    (select count(booking_date) from booking_table where user_id = e.user_id and booking_date between '2022-04-01' and '2022-04-30') as total_booking
from early_booking e join booking_table b
on e.user_id = b.user_id
where 1 = 1
and e.earlist_booking = 1
group by e.user_id, e.segment, e.booking_date, e.earlist_booking;


with
early_booking as(
select
    u.segment,
    u.user_id,
    b.booking_id,
    b.booking_date,
    rank() over(partition by u.segment order by b.booking_date, b.booking_id) as earlist_booking
from user_table u join booking_table b
on u.user_id = b.user_id
where 1 = 1
and b.booking_date between '2022-04-01' and '2022-04-30'
)
select
    e.segment,
    e.user_id,
    e.earlist_booking,
    count(b.booking_date) total_bookings
from early_booking e join booking_table b
on e.user_id = b.user_id
where 1 = 1
and e.earlist_booking = 1
and b.booking_date between '2022-04-01' and '2022-04-30'
group by e.user_id, e.segment, e.earlist_booking;


with cte as (
    select
    u.segment,
    b.user_id,
    ROW_NUMBER() over (partition by u.segment order by booking_date, booking_id) as rn,
    COUNT(*) over (partition by u.segment, u.user_id) as count_of_bookings
    from user_table u
    inner join booking_table b on u.user_id = b.user_id
    where b.booking_date between '2022-04-01' and '2022-04-30'
)
select * from cte
where rn = 1;