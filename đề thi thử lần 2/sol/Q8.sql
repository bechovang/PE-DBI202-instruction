-- Question 8: Create stored procedure proc_product_quantity
CREATE PROCEDURE proc_product_quantity
    @productID int,
    @totalQuantity int OUTPUT
AS
BEGIN
    SELECT @totalQuantity = SUM(Quantity)
    FROM ProductInventory
    WHERE ProductID = @productID;
END;
