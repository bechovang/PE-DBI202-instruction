--q7

with f2023 as(
	SELECT	
		c.CustomerID,
		c.FullName,
		avg(o.TotalAmount) as [avg23]

	FROM Customers c
	LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
	WHERE year(o.OrderTime) = 2023
	group by c.CustomerID, c.FullName -- phải có đủ các cái của select
),

f2024 as(
	SELECT	
		c.CustomerID,
		c.FullName,
		avg(o.TotalAmount) as [avg24]

	FROM Customers c
	LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
	WHERE year(o.OrderTime) = 2024
	group by c.CustomerID, c.FullName -- phải có đủ các cái của select
)



SELECT DISTINCT
	c.CustomerID,
	c.FullName,
	CAST(
		isnull(f2023.[avg23],0)
		AS DECIMAL(18,2) 
	) as AvgTotalOrderValue2023,
	CAST(
		isnull(f2024.[avg24],0)
		AS DECIMAL(15,2) 
	) as AvgTotalOrderValue2024,

	CONCAT(
		CAST(
			((f2024.[avg24]-f2023.[avg23]) / (f2023.[avg23]))*100
			AS DECIMAL(15,2) 
		),
		' %'
	) as percentcomp

FROM Customers c
JOIN f2024 on c.CustomerID = f2024.CustomerID
JOIN f2023 on c.CustomerID = f2023.CustomerID
WHERE
	f2024.[avg24] > 0
	AND f2023.[avg23] > 0

order by c.CustomerID