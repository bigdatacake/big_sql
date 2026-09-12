select * from users;
select * from orders;
select * from items;

-- All items sold by sellers on all dates
select o.order_date, o.seller_id, o.item_id, i.item_brand
from orders o join items i
on o.item_id = i.item_id
order by o.seller_id, o.order_date;


-- First, get all items sold by sellers on all dates
-- Second, Check if item sold is favorite item
-- Third, Rank the items sold on each date by desc, so second item is on top (rank 1)
-- Fourth, Also join the Users table to get sellers who have not sold items
-- Fifth, While listing, use the user_id as seller_id so all sellers are listed 
with 
sales as(
	select o.order_date, o.seller_id, o.item_id, i.item_brand
	from orders o join items i
	on o.item_id = i.item_id
	order by o.seller_id, o.order_date
),
fav_brank_rank as(
select 
	u.user_id,
	s.order_date,
	s.seller_id,
	s.item_id,
	s.item_brand,
	u.favorite_brand,
	case 
		when s.item_brand = u.favorite_brand then 'Yes' else 'No'	
	end fav_brand_match,	
	rank() over(partition by seller_id order by order_date desc) as item_rank
from sales s right join users u
on s.seller_id = u.user_id)
select f.user_id seller_id, f.fav_brand_match, f.item_brand item_sold, f.favorite_brand
from fav_brank_rank f
where item_rank = 1
order by 1;