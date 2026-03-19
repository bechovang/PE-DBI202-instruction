-- Question 6: Display ProductID, Name, TotalQuantity of products having the highest total quantity
SELECT TOP 1 WITH TIES p.ProductID, p.Name, SUM(pi.Quantity) AS TotalQuantity
FROM Product p
JOIN ProductInventory pi ON p.ProductID = pi.ProductID
GROUP BY p.ProductID, p.Name
ORDER BY TotalQuantity DESC;
