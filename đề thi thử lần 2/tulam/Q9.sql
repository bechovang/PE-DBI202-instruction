-- q9
IF OBJECT_ID('tr_insert_Product', 'TR') IS NOT NULL
    DROP TRIGGER tr_insert_Product
GO



----------------------------
CREATE TRIGGER tr_insert_Product
ON Product
AFTER INSERT
AS
BEGIN
    SELECT 
		i.ProductID,
		i.Name as ProductName,
		pm.ModelID,
		pm.name as ModelName
	from inserted i
	join ProductModel pm
		on pm.ModelID = i.ModelID


END


----------------------------------
GO


INSERT INTO Product (ProductID, Name, Color, Cost, Price, ModelID, SellStartDate)
VALUES (9992, N'Test Product', N'Red', 100, 200, 1, GETDATE())