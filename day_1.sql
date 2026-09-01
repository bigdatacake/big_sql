select * from icc_world_cup iwc;

-- All teams that played
select t1.team_1 team_name from icc_world_cup t1 
full join icc_world_cup t2 on t1.team_1 = t2.team_2
union
select t1.team_2 team_name from icc_world_cup t1 
full join icc_world_cup t2 on t1.team_2 = t2.team_1;

-- Winning teams and no. of wins
select winner winning_team, count(winner) total_wins
from icc_world_cup
group by winner 
order by 2 desc;

-- All teams and wins
with
teams as(
	select t1.team_1 team_name from icc_world_cup t1 
	full join icc_world_cup t2 on t1.team_1 = t2.team_2
	union
	select t1.team_2 team_name from icc_world_cup t1 
	full join icc_world_cup t2 on t1.team_2 = t2.team_1
),
winners as(
	select winner winning_team, count(winner) total_wins
	from icc_world_cup
	group by winner
)
select t.team_name, coalesce(w.total_wins, 0) total_wins
from teams t
left outer join winners w
on t.team_name = w.winning_team
where t.team_name is not null
order by 2 desc;

-- Team Standings - 1
with 
teams as( 
	select
	team_1 team,
	case 
		when team_1 = winner then 1 else 0
	end win
	from icc_world_cup
	union all 
	select
	team_2 team,
	case 
		when team_2 = winner then 1 else 0
	end win
	from icc_world_cup
)
select
	team,
	count(team) played,
	sum(win) won,
	count(team) - sum(win) lost,
	sum(win) * 2 points
from
	teams
group by
	team
order by
	points desc

-- Team Standings -2
with team_union as ( 
select Team_1 as Team, Winner from icc_world_cup
union all
select Team_2 as Team, Winner from icc_world_cup
)
select 
team as team_name, 
count(team) as match_played,
sum(case when Winner = team then 1 else 0 end) as no_of_wins,
sum(case when Winner != team then 1 else 0 end) as no_of_loss,
sum(case when Winner = team then 2 else 0 end) as no_of_points
from team_union
group by team;