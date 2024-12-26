with actual_table as 
	(
		select 
			city_id, trip_id,
			count(trip_id) as actual_trips,
			monthname(date) as month_name 
		from trips_db.fact_trips 
		group by month_name, city_id
		order by city_id
	)
select  
		c.city_name, 
		a.month_name, 
		a.actual_trips , 
		t.total_target_trips as target_trips,
	if (actual_trips >= total_target_trips , "above target" , "below target") 
						as performance_status,
	round((actual_trips-total_target_trips)*100/total_target_trips,1) 
						as pct_difference
 from actual_table a
 join targets_db.monthly_target_trips t on t.city_id = a.city_id 
						and a.month_name = monthname(t.month)
 join trips_db.dim_city c on c.city_id = a.city_id
 group by a.month_name,c.city_name
 order by c.city_name;
 