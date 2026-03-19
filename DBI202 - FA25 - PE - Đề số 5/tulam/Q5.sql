-- q5

SELECT 
	c.CustomerID,
	c.FullName,
	ISNULL(t.NumberOfOrders, 0) AS NumberOfOrders,
	ISNULL(t.TotalSpent, 0)     AS TotalAmount

FROM Customers c
LEFT JOIN (
    -- Tính sẵn số đơn + tổng tiền theo từng khách
	-- trong năm 2025
    SELECT 
        CustomerID,
        COUNT(OrderID)      AS NumberOfOrders,
        SUM(TotalAmount)    AS TotalSpent
    FROM Orders
    WHERE YEAR(PaymentTime) = 2025
    GROUP BY CustomerID
) t ON t.CustomerID = c.CustomerID


WHERE (
		(c.FullName LIKE N'Nguyễn%')
		OR (c.FullName LIKE N'BÙI%')
	)

