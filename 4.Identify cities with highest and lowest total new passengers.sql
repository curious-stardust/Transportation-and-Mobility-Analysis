with total_passengers as
	(
		select 
			c.city_name , 
            sum(new_passengers) as total_new_passengers 
		from trips_db.fact_passenger_summary p
		join trips_db.dim_city c using (city_id)
		group by c.city_id
	),
order_no as 
	(
	select 
		city_name, 
        total_new_passengers,
		row_number() over (order by total_new_passengers desc) as Top_3,
		row_number() over (order by total_new_passengers asc) as Bottom_3
	from total_passengers
    )
select 
	city_name , 
    total_new_passengers,
case
	when Top_3 <= 3 then CONCAT('Top ', Top_3)
	when Bottom_3 <= 3 then CONCAT('Bottom ', Bottom_3)
	else 'Not Ranked'
end as City_Category
from order_no
where Top_3 <= 3 or Bottom_3 <= 3
order by total_new_passengers desc;