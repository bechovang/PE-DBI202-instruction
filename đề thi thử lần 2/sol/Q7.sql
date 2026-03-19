-- Question 7: For each location, display products having the highest Quantity
SELECT l.LocationID, l.Name AS LocationName, pi.ProductID, p.Name AS ProductName, pi.Quantity
FROM Location l
JOIN ProductInventory pi ON l.LocationID = pi.LocationID
JOIN Product p ON pi.ProductID = p.ProductID
WHERE pi.Quantity = (
    SELECT MAX(Quantity)
    FROM ProductInventory
    WHERE LocationID = l.LocationID
)
ORDER BY l.Name ASC, p.Name DESC;
