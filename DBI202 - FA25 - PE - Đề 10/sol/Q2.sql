-- q2

-- lấy tất cả
SELECT *
-- chọn bảng
FROM Employees e
-- điều kiện
WHERE (e.Role = 'Manager' OR e.Role = 'Chef')
AND (YEAR(e.HireDate) = 2021 )







