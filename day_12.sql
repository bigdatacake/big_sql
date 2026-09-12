select * from players;
select * from matches;

-- Player and their match scores
select
	m.first_player player_id,
	m.first_score score
from
	matches m
union all
select
	m.second_player player_id,
	m.second_score score
from
	matches m
order by 1;

-- Players and total scores
-- Rank the data based on
-- First by high ccore within the group and then by player_id asc
-- Highest score is ranked first, if tie then lowest player_id is ranked first 
with 
all_matches as(
select
  m.first_player player_id,
  m.first_score score
from matches m
union all
select
  m.second_player player_id,
  m.second_score score
from matches m
),
player_ranking as(
select 
	p.group_id,
	m.player_id, 
	sum(m.score) total_score,
	rank() over(partition by p.group_id order by sum(m.score) desc, m.player_id asc) player_rank
from all_matches m join players p
on m.player_id = p.player_id
group by m.player_id, p.group_id
)
select 
	group_id,
	player_id,
	total_score,
	player_rank
from player_ranking
where player_rank = 1;