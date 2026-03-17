-- q7

-- 2 select long nhau
--	select de gom thong
--  1 select de kiem max
SELECT
	p.category_name,
	p.product_id,
	p.product_name,
	p.list_price
FROM products p
WHERE p.list_price =(
	SELECT MAX(p2.list_price)
	FROM products p2
	-- lien ket
	WHERE p2.category_name 
		= p.category_name  
)
ORDER BY p.category_name ASC,
	p.product_id ASC

