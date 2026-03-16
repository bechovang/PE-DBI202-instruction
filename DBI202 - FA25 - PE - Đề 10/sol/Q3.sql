-- q3

SELECT 
c.CustomerID, c.FullName,
m.ItemID, m.ItemName
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN MenuItems m ON od.ItemID = m.ItemID

WHERE c.FullName = N'Nguyễn Hoài Phương'

