-- Question 9: Create trigger tr_insert_Product
CREATE TRIGGER tr_insert_Product
ON Product
AFTER INSERT
AS
BEGIN
    SELECT i.ProductID, i.Name AS ProductName, i.ModelID, pm.Name AS ModelName
    FROM inserted i
    LEFT JOIN ProductModel pm ON i.ModelID = pm.ModelID;
END;
