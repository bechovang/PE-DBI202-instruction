--q5

SELECT 
	p.product_id,
	p.product_name,
	p.list_price
FROM products p
WHERE
	p.list_price 
	= (SELECT MIN(list_price) FROM products)
