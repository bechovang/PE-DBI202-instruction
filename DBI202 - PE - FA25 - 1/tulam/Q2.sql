-- q2 

SELECT 
	c.customer_id,
	c.first_name,
	c.last_name,
	c.email
FROM customers c
WHERE c.city = 'New York'
ORDER BY 
	c.last_name ASC,
	c.first_name ASC