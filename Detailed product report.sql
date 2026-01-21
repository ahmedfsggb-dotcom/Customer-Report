

--Total Sales ,Order Quantity,and Cost by Product Name --
with Rerport_Product  as 
(
 select
p.CookieID,
p.CookieName,
p.RevenuePerCookie,
p.CostPerCookie ,
 sum (op.Quantity) as total_quantity
from [dbo].Product p
join [dbo].[Order_Product] op
on p.CookieID = op.CookieID 
group by p.CookieID,
p.CookieName ,
p.RevenuePerCookie,
p.CostPerCookie  
)
select
CookieID,
CookieName,
total_quantity,
RevenuePerCookie * total_quantity as total_sales , 
CostPerCookie * total_quantity as total_cost
from Rerport_Product;

--Total sales and cost of products on a monthly basis (January, February, and March)--
with Rerport_Product  as 
(
 select
p.CookieID,
p.CookieName,
p.RevenuePerCookie,
p.CostPerCookie ,
 sum (op.Quantity) as total_quantity,
  month(o.OrderDate) as order_dates
from [dbo].Product p
join [dbo].[Order_Product] op
on p.CookieID = op.CookieID 
join [dbo].[Orders] o 
on op.OrderID = o.OrderID
group by p.CookieID,
p.CookieName ,p.RevenuePerCookie,
p.CostPerCookie  ,month(o.OrderDate)
)
select
CookieID,
CookieName,
total_quantity,
RevenuePerCookie * total_quantity as total_sales , 
CostPerCookie * total_quantity as total_cost,
order_dates

from Rerport_Product







