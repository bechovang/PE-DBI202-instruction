-- q3

SELECT 
	p.product_id,
	p.product_name,
	p.list_price
FROM products p
WHERE p.product_name LIKE '%City%'
ORDER BY p.product_name ASC