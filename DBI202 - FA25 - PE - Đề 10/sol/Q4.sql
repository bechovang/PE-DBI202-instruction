-- q4

SELECT 
t.TableID, t.Capacity, t.Location,
c.CustomerID, c.FullName, c.CreatedDate
FROM Tables t
JOIN ReservationTables rt ON t.TableID = rt.TableID
JOIN Reservations r ON r.ReservationID = rt.ReservationID
JOIN Customers c ON c.CustomerID = r.CustomerID
WHERE 
((t.Location LIKE 'Khu A%')
OR (t.Location LIKE 'Khu B%')
OR (t.Location LIKE 'Khu C%'))
ORDER BY c.CreatedDate



