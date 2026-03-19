--q7

with func2024 as(
	SELECT	
		c.CustomerID,
		c.FullName,
		o.OrderTime,
		avg(o.TotalAmount) as total

	FROM Customers c
	LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
	WHERE year(o.OrderTime) = 2024
	group by c.CustomerID, c.FullName, o.OrderTime -- phải có đủ các cái của select
	
	
)



SELECT 
	c.CustomerID,
	c.FullName,
	func2024.total,
	func2024.OrderTime
FROM Customers c
JOIN func2024 on c.CustomerID = func2024.CustomerID