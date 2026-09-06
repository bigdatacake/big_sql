-- Postgres SQL


-- Current time stamp
select now();

-- Cast to date
-- Use any of the two methods
select now()::date;
select date '2026-09-04' as todays_date, 3 as n;


-- date_part function extracts a specified subfield (such as year, month, day, or hour) from a given timestamp or date.
 
-- 0 - Sunday
-- 1 - Monday
-- ...
-- 6 - Saturday

select date_part('dow', now()::date);
select date_part('dow', '2026-09-07'::date);

-- Find the first Sunday based on the input date
-- Next find the nth upcoming Sunday
with input_info as (
    select now()::date as todays_date, 3 as n
    
),
first_sunday as (
    select 
        case 
            when date_part('dow', todays_date)::int = 0 then todays_date
            else todays_date + (7 - date_part('dow', todays_date)::int)
        end 
        sunday_date
    from input_info
)
select todays_date, n as next_nth, sunday_date + (7 * (n - 1)) as upcoming_sunday
from first_sunday, input_info;

