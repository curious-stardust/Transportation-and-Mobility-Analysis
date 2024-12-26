with total_repeat_passengers as 
	(
		select 
			city_id, 
            sum(repeat_passenger_count)as total_count 
		from trips_db.dim_repeat_trip_distribution
		group by city_id
	)
select 
	c.city_name,
	sum(case when d.trip_count = "2-Trips" then round((d.repeat_passenger_count*100/t.total_count),1) else 0 end) as "2-Trips",
	sum(case when d.trip_count = "3-Trips" then round((d.repeat_passenger_count*100/t.total_count),1) else 0 end) as "3-Trips",
	sum(case when d.trip_count = "4-Trips" then round((d.repeat_passenger_count*100/t.total_count),1) else 0 end) as "4-Trips",
	sum(case when d.trip_count = "5-Trips" then round((d.repeat_passenger_count*100/t.total_count),1) else 0 end) as "5-Trips",
	sum(case when d.trip_count = "6-Trips" then round((d.repeat_passenger_count*100/t.total_count),1) else 0 end) as "6-Trips",
	sum(case when d.trip_count = "7-Trips" then round((d.repeat_passenger_count*100/t.total_count),1) else 0 end) as "7-Trips",
	sum(case when d.trip_count = "8-Trips" then round((d.repeat_passenger_count*100/t.total_count),1) else 0 end) as "8-Trips",
	sum(case when d.trip_count = "9-Trips" then round((d.repeat_passenger_count*100/t.total_count),1) else 0 end) as "9-Trips",
	sum(case when d.trip_count = "10-Trips" then round((d.repeat_passenger_count*100/t.total_count),1) else 0 end) as "10-Trips"
from total_repeat_passengers t
join trips_db.dim_city c using (city_id)
join trips_db.dim_repeat_trip_distribution d using (city_id)
group by c.city_id;