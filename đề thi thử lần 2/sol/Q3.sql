-- Question 3: Select ProductID, LocationID, Quantity for location 7 and quantity > 250
SELECT ProductID, LocationID, Quantity
FROM ProductInventory
WHERE LocationID = 7 AND Quantity > 250
ORDER BY Quantity DESC;
