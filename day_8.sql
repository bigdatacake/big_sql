select * from person p;
select * from friend f;

-- Write a query to list 
-- personid, name, number of friends, sum of marks (friends')
-- where the person's  friends total score greater than 100

-- Person and their friends
select 
	p.personid person_id,
	p.name person_name, 
	f.fid friend_id, 
	pf.name friend_name
from person p join friend f
on p.personid = f.pid
join person pf
on pf.personid = f.fid
order by 1;


-- Number of Friends per person
-- Total score of friends
select 
	p.personid person_id,
	p.name person_name, 
	count(f.fid) num_of_friends,
	sum(pf.score) friend_score
from person p join friend f
on p.personid = f.pid
join person pf
on pf.personid = f.fid
group by p.personid, p.name
order by 1;


-- Person's whose friends total score is more than 100
select 
	p.personid person_id,
	p.name person_name, 
	count(f.fid) num_of_friends,
	sum(pf.score) friend_score
from person p join friend f
on p.personid = f.pid
join person pf
on pf.personid = f.fid
group by p.personid, p.name
having sum(pf.score) > 100 
order by 1;