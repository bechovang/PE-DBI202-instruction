--q7





with f as (
	select 
		l.LocationID,
		l.Name as LocationName,
		max(pi.Quantity) as Quantity

	from Location l

	left join ProductInventory pi
		on l.LocationID = pi.LocationID

	group by 
		l.LocationID,
		l.Name 
)

select distinct
	f.LocationID,
	f.LocationName,
	p.ProductID,
	p.Name as ProductName,
	f.Quantity

from Product p

left join ProductInventory pi
	on p.ProductID = pi.ProductID
join f
	on f.LocationID = pi.LocationID

where pi.Quantity = f.Quantity

order by LocationName asc, ProductName desc

