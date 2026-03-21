-- q4

SELECT 
	p.ProductID, 
	p.Name AS ProductName,
	p.Color,
	p.Cost,
	p.Price,
	pi.LocationID,
	l.Name as LocationName,
	pi.Shelf,
	pi.Bin,
	pi.Quantity

	
FROM Product p
left join ProductInventory pi
	on p.ProductID = pi.ProductID
left join Location l
	on l.LocationID = pi.LocationID
where p.Color = 'Yellow'
	and p.Cost < 400