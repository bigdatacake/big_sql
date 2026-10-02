DROP TABLE IF EXISTS matches;
CREATE TABLE matches (
    match_id INT PRIMARY KEY,
    winning_team_id INT,
    losing_team_id INT,
    goals_won INT
);

TRUNCATE TABLE matches;
INSERT INTO matches (match_id, winning_team_id, losing_team_id, goals_won) VALUES
(1, 1001, 1007, 1),
(2, 1007, 1001, 2),
(3, 1006, 1003, 3),
(4, 1001, 1003, 1),
(5, 1007, 1001, 1),
(6, 1006, 1003, 2),
(7, 1006, 1001, 3),
(8, 1007, 1003, 5),
(9, 1001, 1003, 1),
(10, 1007, 1006, 2),
(11, 1006, 1003, 3),
(12, 1001, 1003, 4),
(13, 1001, 1006, 2),
(14, 1007, 1001, 4),
(15, 1006, 1007, 3),
(16, 1001, 1003, 3),
(17, 1001, 1007, 3),
(18, 1006, 1007, 2),
(19, 1003, 1001, 1);

select * from matches;

-- Assign 1 point for each win
select
    winning_team_id,
    goals_won,
    1 as points
from matches;

-- Assign -1 point for each loss and goals_won is 0 when lost
select
    losing_team_id,
    0 as goals_won,
    -1 as points
from matches;

-- Rank the teams by total points high to low
with
team_tally as (
select winning_team_id as team_id, goals_won, 1 as points from matches
union all
select losing_team_id as team_id, 0 as goals_won, -1 as points from matches
),
team_standing as (
select
    team_id,
     sum(goals_won) total_goals,
     sum(points)    total_points
from team_tally
group by team_id
)
select
    *,
    rank() over(order by total_points desc) team_rank
from team_standing;


-- If two teams have same points, the team with most goals should be ranked higher
insert into matches values
(20, 1001, 1007, 3),
(21, 1001, 1003, 3);
;

with
team_tally as (
select winning_team_id as team_id, goals_won, 1 as points from matches
union all
select losing_team_id as team_id, 0 as goals_won, -1 as points from matches
),
team_standing as (
select
    team_id,
     sum(goals_won) total_goals,
     sum(points)    total_points
from team_tally
group by team_id
)
select
    *,
    rank() over(order by total_points desc, total_goals desc) team_rank
from team_standing;