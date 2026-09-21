drop table if exists UserActivity;

create table UserActivity
(
username      varchar(20) ,
activity      varchar(20),
startDate     Date   ,
endDate      Date
);

insert into UserActivity values 
('Alice','Travel','2020-02-12','2020-02-20')
,('Alice','Dancing','2020-02-21','2020-02-23')
,('Alice','Travel','2020-02-24','2020-02-28')
,('Bob','Travel','2020-02-11','2020-02-18');


select * from UserActivity;

-- Second most recent activity if multiple activities else most recent
-- Count the total activities
-- Rank the activities in descending order
with 
all_activities as(
select 
	username, activity, startdate, enddate,
	rank() over(partition by username order by enddate desc) activity_rank,
	count(*) over(partition by username) as activity_count
from UserActivity
)
select * 
from all_activities
where activity_rank = 2 or activity_count = 1;