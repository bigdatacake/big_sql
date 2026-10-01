DROP TABLE IF EXISTS subscribers;
CREATE TABLE subscribers
(
    customer_id       INT,
    subscription_date DATE,
    plan_value        INT
);

TRUNCATE TABLE subscribers;
INSERT INTO subscribers
VALUES (1, '2023-03-02', 799),
       (1, '2023-04-01', 599),
       (1, '2023-05-01', 499),
       (2, '2023-04-02', 799),
       (2, '2023-07-01', 599),
       (2, '2023-09-01', 499),
       (3, '2023-01-01', 499),
       (3, '2023-04-01', 599),
       (3, '2023-07-02', 799),
       (4, '2023-04-01', 499),
       (4, '2023-09-01', 599),
       (4, '2023-10-02', 499),
       (4, '2023-11-02', 799),
       (5, '2023-10-02', 799),
       (5, '2023-11-02', 799),
       (6, '2023-03-01', 499);

SELECT *
FROM subscribers
ORDER BY 1, 2;

-- Unique customers
select
    distinct customer_id
from subscribers
order by 1;

select
    count(distinct customer_id)
from subscribers;

-- For each customer calculate min and max spend
select
    customer_id,
    min(plan_value),
    max(plan_value)
from subscribers
group by customer_id
order by customer_id;

-- Find customers who have
-- 1. Upgraded once in their lifetime
-- 2. Downgraded once in their lifetime

-- Use Window function and partition by customer_id
-- Order by subscription date asc so we can compare to previous plan date with current plan date
-- LAG will compare with previous value for the same customer id
select
    customer_id,
    subscription_date,
    plan_value,
    LAG(plan_value, 1, plan_value) over(PARTITION BY customer_id order by subscription_date) as prev_plan_value
from subscribers;

-- Create a CTE, Compare with previous plan value and create a flag of 1 where upgrade/downgrade happened
-- Take the max value and use conditional to find Yes/No for upgrade/downgrade
with
customer_plans as(
select
    customer_id,
    subscription_date,
    plan_value,
    LAG(plan_value, 1, plan_value) over(PARTITION BY customer_id order by subscription_date) as prev_plan_value
from subscribers
),
customer_profile as(
select
    customer_id,
    subscription_date,
    plan_value,
    prev_plan_value,
    case
        when prev_plan_value > plan_value then 1
        else 0
    end downgrade_flag,
    case
        when prev_plan_value < plan_value  then 1
        else 0
    end as upgrade_flag
from customer_plans)
select
    customer_id,
    case
        when max(upgrade_flag)>=1 then 'Yes'
        else 'No'
    end as upgraded,
    case
        when max(downgrade_flag)=1 then 'Yes'
        else 'No'
    end as downgraded
from customer_profile
group by customer_id;