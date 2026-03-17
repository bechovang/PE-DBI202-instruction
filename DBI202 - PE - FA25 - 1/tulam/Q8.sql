--q8
---- 1. Xóa Procedure nếu nó đã tồn tại
--IF OBJECT_ID('proc_SumQuantityProduct', 'P') IS NOT NULL
--    DROP PROCEDURE proc_SumQuantityProduct
--GO

-- 2. Tạo mới hoàn toàn
CREATE PROCEDURE proc_SumQuantityProduct
    @Store_id INT, 
    @SumQuantity DECIMAL(10,2) OUTPUT
AS
BEGIN
    -- Tính toán tổng
    SELECT @SumQuantity = SUM(st.quantity)
    FROM stocks st
    WHERE st.store_id = @Store_id
END


---- Chạy thử cho Store_id = 2
--SELECT SUM(quantity) 
--FROM stocks 
--WHERE store_id = 2;
---- Ghi nhớ con số này (Ví dụ: 500.00)