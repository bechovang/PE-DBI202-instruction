--q3

--có thể viết bằng join on

SELECT DISTINCT 
	c.CustomerID,
	c.FullName,
	m.ItemID,
	m.ItemName

FROM 
	Customers c,
	Orders o,
	OrderDetails od,
	MenuItems m
WHERE 
	(c.CustomerID = o.CustomerID)
	AND (o.OrderID = od.OrderID)
	AND (od.ItemID = m.ItemID)
	AND (c.FullName = N'Nguyễn Hoài Phương')