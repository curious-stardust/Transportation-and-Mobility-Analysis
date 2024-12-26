with CTE1 as 
		(select 
			c.city_name, 
			sum(fare_amount) as revenue,
			d.month_name 
	from trips_db.fact_trips f
	join trips_db.dim_date d using (date)
	join trips_db.dim_city c using (city_id)
	group by c.city_name, d.month_name),
CTE2 as
	(select 
		city_name, 
        month_name, 
        revenue,
	rank() over (partition by city_name order by revenue desc) as rnk
	from CTE1),
CTE3 as 
	( select 
		c.city_name, 
        sum(fare_amount) as total_revenue 
	from trips_db.fact_trips f
	join trips_db.dim_date d using (date)
	join trips_db.dim_city c using (city_id)
	group by c.city_name)
select 
		a.city_name, 
		a.month_name as highest_revenue_month,
		a.revenue, 
		round((a.revenue*100/b.total_revenue),2) as pct_contribution 
    from CTE2 a
	join CTE3 b using (city_name) 
    where rnk = 1;