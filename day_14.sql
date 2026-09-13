select * from spending;

-- Maximum on a string field returns higher alphabet order
select max(platform) from spending;

select spend_date, user_id, max(platform) platform, sum(amount) amount_spend
from spending
group by spend_date, user_id
having count(distinct platform) = 1 
order by spend_date, user_id;


with 
total_spend as (
select spend_date, user_id, max(platform) platform, sum(amount) amount_spend
from spending
group by spend_date, user_id
having count(distinct platform) = 1 
union all
select spend_date, user_id, 'Both' platform, sum(amount) amount_spend
from spending
group by spend_date, user_id
having count(distinct platform) = 2
union all
select distinct spend_date, NULL as user_id, 'Both' platform, 0 amount_spend
from spending
)
select spend_date, platform, sum(amount_spend), count(distinct user_id) as users 
from total_spend
group by spend_date, platform
order by spend_date, platform;