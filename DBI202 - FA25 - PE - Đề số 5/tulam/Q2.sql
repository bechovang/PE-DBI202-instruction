--q2


SELECT *
FROM Employees e
WHERE 
	((Role = 'Manager')
		OR (Role = 'Chef'))
	AND (YEAR(HireDate) = 2021)


