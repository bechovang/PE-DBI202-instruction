-- Q4

-- đề có NULL => dùng left join

--là liêt kê full món chính ở menu 
--rồi add thêm phần khách hàng cho nó,
--cái nào ko có khách thì để null

--không dùng left join bình thường được 

-- VÌ: 
--Tự hỏi trước khi JOIN

--"Bảng mình sắp JOIN vào có thể có nhiều dòng khớp 
--với 1 dòng bên trái không?"

--Nếu CÓ → phải xử lý trước!

--=> Dùng subquery lọc trước

--MenuItems ──< OrderDetails >── Orders ──> Customers
--(món ăn)      (chi tiết đơn)  (đơn hàng)  (khách hàng)



SELECT DISTINCT
    m.Category,
    m.ItemID,
    m.ItemName,
	t.CustomerID,
	t.FullName
FROM MenuItems m
LEFT JOIN (
	SELECT 
		c.CustomerID,
		c.FullName,
		od.ItemID
	FROM OrderDetails od
	JOIN Orders o 
		ON od.OrderID = o.OrderID
	JOIN Customers c
		ON c.CustomerID = o.CustomerID
	WHERE	
		YEAR(o.OrderTime) = 2025
		AND MONTH(o.OrderTime) = 8
) t ON m.ItemID = t.ItemID -- phải có alias	

WHERE
	m.Category = N'Món chính'

ORDER BY m.ItemName ASC, t.CustomerID ASC;