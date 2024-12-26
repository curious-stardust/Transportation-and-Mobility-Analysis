select 
	c.city_name, 
	round(avg(fare_amount/distance_travelled_km),2) 
			as avg_fare_per_km, 
	round(sum(fare_amount)/count(trip_id),2) 
			as avg_fare_per_trip,
	count(*) as total_trip,
	round((count(*)*100)/(select count(*) from trips_db.fact_trips ),2)
			as pct_contribution_to_total_trips
from trips_db.fact_trips t
join trips_db.dim_city c 
	using (city_id)
group by city_name;