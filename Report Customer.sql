create view gold.report_customer as 

with 
-- data colection CTE --
customer_data as (

select 
s.order_date,
s.order_number,
s.product_key,
s.sales_amount as sales,
s.quantity,
c.customer_id,
DATEDIFF(year,c.birthdate,getdate()) as age,
concat(c.first_name,'  ',c.last_name) as customer_name
from gold.fact_sales s 
left join 
gold.dim_customers c 
on s.customer_key = c.customer_key 
where s.order_date is not null
)

--calculation CTE --
,customer_agreggate as (

select customer_name,age,customer_id ,
sum (sales)as total_sales,
sum (quantity) as total_quantity,
count(distinct order_number) as total_order,
DATEDIFF(month,min (order_date),max(order_date)) as lifespen,
min (order_date)as first_order,
max(order_date)as last_order_date

from customer_data
group by customer_name,age,customer_id 
)
select customer_name,age,customer_id ,
total_sales,
 total_quantity,
 total_order,
 lifespen,
 first_order,
last_order_date,
--segment customer by total sales --
case 
when lifespen >= 12 and total_sales > 5000 then 'vip'
when lifespen >= 12 and total_sales < 5000 then 'regular'
else 'new'
end customer_segment,
--segment customer by age--
case 
when age < 20 then 'under 20'
when age between 20 and 29 then ' 20 - 29'
when age between 29 and 39 then ' 29 - 39'
when age between 39 and 49 then ' 39 - 49'
else '50 above' 
end age_group,
--compuate averege --
case 
when total_sales =0 then 0 
else total_sales / total_order 
end avg_order_value
from customer_agreggate


 
 