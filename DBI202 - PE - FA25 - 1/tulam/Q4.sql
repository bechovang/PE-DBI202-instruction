-- q4

SELECT
	o.order_id,
	o.customer_id,
	o.order_date,
	o.store_id,
	o.staff_id
FROM orders o
WHERE o.order_date
BETWEEN '2025-08-05' AND '2025-08-15'
ORDER BY o.order_date ASC