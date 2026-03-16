-- q5

CREATE VIEW view_Rich_Client
AS
    SELECT Clients.FirstName, Clients.LastName -- lấy tên ở client
	FROM Clients
	JOIN Accounts ON Clients.Id = Accounts.ClientId
	-- gom các thú có client giống => các acc của client đó
	-- group cả client id để ko trùng
	GROUP BY Clients.FirstName, Clients.LastName, Clients.Id
	-- having - lọc :  nhóm nào tổng > 300 thì giữ lại
	HAVING SUM(Accounts.Balance) > 300