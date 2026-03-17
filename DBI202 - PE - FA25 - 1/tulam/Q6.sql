--q6
SELECT 
	s.store_id,
	store_name,
	SUM(st.quantity) 
		AS total_qty_in_stock 
FROM stocks st, stores s
WHERE st.store_id = s.store_id
GROUP BY s.store_id, store_name
ORDER BY total_qty_in_stock DESC,
	s.store_id ASC