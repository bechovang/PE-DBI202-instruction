-- q8

IF OBJECT_ID('proc_product_quantity', 'P') IS NOT NULL
    DROP PROCEDURE proc_product_quantity
GO



--------------------------------------


CREATE PROCEDURE proc_product_quantity
    @productID INT,                    -- Tham số đầu vào
    @totalQuantity INT OUTPUT -- Tham số đầu ra (Bắt buộc có chữ OUTPUT)
AS
BEGIN
	select
		@totalQuantity = sum(Quantity)
	from ProductInventory pi
	where pi.ProductID = @productID
	




END;

-----------------------------


GO



DECLARE @id INT;
DECLARE @soluong INT;

EXEC proc_product_quantity 
    @productID = 1,                        
    @totalQuantity = @soluong OUTPUT;

SELECT @soluong ;

