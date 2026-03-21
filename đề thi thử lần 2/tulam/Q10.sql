--q10


--DELETE FROM ProductInventory 
--WHERE 
--	LocationID = (
--		SELECT LocationID 
--		FROM Location 
--		WHERE Name = 'Tool Crib'
--	)


DECLARE @locationID INT

SELECT @locationID = LocationID 
FROM Location 
WHERE Name = 'Tool Crib'

DELETE FROM ProductInventory
WHERE LocationID = @locationID



--BEGIN TRANSACTION

---- Xem trước data sẽ bị xóa
--SELECT * FROM ProductInventory
--WHERE LocationID = (SELECT LocationID FROM Location WHERE Name = 'Tool Crib')

---- Thực hiện xóa
--DELETE FROM ProductInventory
--WHERE LocationID = (SELECT LocationID FROM Location WHERE Name = 'Tool Crib')

---- Kiểm tra sau khi xóa
--SELECT * FROM ProductInventory
--WHERE LocationID = (SELECT LocationID FROM Location WHERE Name = 'Tool Crib')

--ROLLBACK  -- Hủy, không lưu thật
---- COMMIT  -- Nếu muốn lưu thật thì dùng cái này