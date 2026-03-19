-- Question 10: Delete from ProductInventory for location named 'Tool Crib'
DELETE FROM ProductInventory
WHERE LocationID = (SELECT LocationID FROM Location WHERE Name = 'Tool Crib');
