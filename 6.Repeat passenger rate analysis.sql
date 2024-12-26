# if the error occurs:(Error Code: 1055. Expression #4 of SELECT list is not in GROUP BY clause and contains nonaggregated column 'trips_db.p.total_passengers' which is not functionally dependent on columns in GROUP BY clause; this is incompatible with sql_mode=only_full_group_by)
#run the below code first

SET sql_mode = (SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));

# CITY-WIDE REPEAT PASSENGER RATE

with repeat_table as
	(
	select 
		p.city_id,
		c.city_name, 
        d.month_name as month , 
        p.total_passengers, 
        p.repeat_passengers,
        round((repeat_passengers/total_passengers)*100,2) as monthly_repeat_passenger_Rate
	from 
		trips_db.fact_passenger_summary p
	join 
		trips_db.dim_date d on (d.date=p.month)
	join 
		trips_db.dim_city c using (city_id)
	group by 
		city_id, month_name
	order by 
		city_id
    ),
   city_total as 
   (
	select 
		city_id, 
        sum(repeat_passengers) as total_repeat_passengers_per_city 
	from 
		fact_passenger_summary
	group by city_id
    )
select 
	r.city_name,
    r.month,
    r.total_passengers,
    r.repeat_passengers,
    r.monthly_repeat_passenger_rate,
    round((r.repeat_passengers*100/y.total_repeat_passengers_per_city),2) as city_repeat_passenger_rate 
from 
	repeat_table r
join city_total y using (city_id);

# CITY-WIDE REPEAT PASSENGER RATE

select
    city_name,
    ROUND(SUM(repeat_passengers) / SUM(total_passengers) * 100,2) as overall_city_repeat_passenger_rate
from
    fact_passenger_summary f
join
    dim_city d using (city_id)
group by 
	f.city_id
order by 
	overall_city_repeat_passenger_rate desc;


