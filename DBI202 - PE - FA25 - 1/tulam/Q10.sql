-- q10

--không dùng dấu =
--Nếu trong danh mục 'Mountain' có từ 
--2 sản phẩm trở lên, Subquery sẽ trả 
--về nhiều dòng. Lúc đó, toán tử = sẽ gây 
--lỗi. Bạn bắt buộc phải dùng toán tử IN.

DELETE FROM stocks
WHERE stocks.product_id IN (
	SELECT p.product_id
	FROM products p
	WHERE p.category_name = 'Mountain'
)