--q6

--KO dùng o.TotalAmount Vì:
--o.TotalAmount (nằm ở bảng Orders) là tổng tiền của CẢ MỘT HÓA ĐƠN (bao gồm rất nhiều món).
--od.Quantity * od.Price (nằm ở bảng OrderDetails) là tiền của RIÊNG MÓN ĐÓ trong hóa đơn.



WITH ItemSales AS (
    SELECT 
        m.ItemID,
        m.ItemName,
        m.Category,
        SUM(  -- case when ở đây, ko ở where vì để ở where mất sl để tính  avg
            CASE 
                WHEN o.Status = 'Completed'
                     AND YEAR(o.OrderTime) = 2023
                THEN od.Quantity * od.Price
                ELSE 0
            END
        ) AS TotalAmount
    FROM MenuItems m
    LEFT JOIN OrderDetails od  -- left join để tính avg ko sót
        ON m.ItemID = od.ItemID
    LEFT JOIN Orders o 
        ON od.OrderID = o.OrderID
    GROUP BY m.ItemID, m.ItemName, m.Category -- tất cả select phải ở trong group by
)
SELECT ItemID, ItemName, Category, TotalAmount
FROM ItemSales
WHERE TotalAmount < (
    SELECT AVG(TotalAmount) 
    FROM ItemSales
)
ORDER BY TotalAmount ASC, ItemID ASC;