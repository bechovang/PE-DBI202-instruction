-- q6


select top 1
	p.ProductID,
	p.Name,
	sum(pi.Quantity) as TotalQuantity

from Product p

left join ProductInventory pi
	on p.ProductID = pi.ProductID

group by p.ProductID, p.Name
order by TotalQuantity desc