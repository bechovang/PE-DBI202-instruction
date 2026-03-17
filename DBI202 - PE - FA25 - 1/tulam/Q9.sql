-- q9

--Nếu bạn chỉ JOIN mà không có DISTINCT:
--Kết quả SELECT sẽ hiện ra:

--11 | Minh | Đặng (cho đơn hàng 101)
--11 | Minh | Đặng (cho đơn hàng 105)

--=> Tên nhân viên bị lặp lại. Đề bài yêu cầu 
--"Liệt kê các nhân viên" (List the staffs), nghĩa là 
--họ chỉ muốn thấy mỗi cái tên xuất hiện 1 lần duy nhất.


SELECT DISTINCT
	s.staff_id,
	s.first_name,
	s.last_name
FROM staffs s
JOIN orders o
	ON o.staff_id = s.staff_id
JOIN
	customers c
	ON c.customer_id = o.customer_id

WHERE c.state = 'CA'