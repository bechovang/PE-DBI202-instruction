---- q8

--IF OBJECT_ID('MonthlySalesSummary', 'P') IS NOT NULL
--    DROP PROCEDURE MonthlySalesSummary
--GO


-------------------------------
CREATE PROCEDURE MonthlySalesSummary
    @year INT -- inp/tham số
AS
BEGIN
	WITH ListMonths AS (
		SELECT 1 AS MonthNum UNION ALL
		SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL
		SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL
		SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10 UNION ALL
		SELECT 11 UNION ALL SELECT 12 
	),

	trung_gian AS (
		SELECT DISTINCT
		
			lm.MonthNum as thang, -- không có tên tự động phải đặt tên
			@year as nam,  --  o.OrderID là có , MONTH(o.OrderTime)  là ko
			CASE
				WHEN sum(o.TotalAmount)>0 THEN count(o.OrderID)
				ELSE 0
			END as sl_don,
			sum(o.TotalAmount) as tong_Tien

		FROM ListMonths lm
		left JOIN orders o 
			ON year(o.OrderTime) = @year
			AND month(o.OrderTime) = lm.MonthNum 
		GROUP BY lm.MonthNum
	)

	SELECT 
		CONCAT(
			thang,
			'/',
			nam
		),
		sl_don as NumberOfOrders,
		isnull(tong_Tien,0) as TotalRevenue

	FROM trung_gian
	



END


-------------------------------
--GO


--DECLARE @ThangKetQua nvarchar(50);

--EXEC MonthlySalesSummary 2023                   
