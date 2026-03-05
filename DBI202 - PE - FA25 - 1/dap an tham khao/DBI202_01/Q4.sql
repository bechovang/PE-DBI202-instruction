SELECT
ORD.order_id,
ORD.customer_id,
ORD.order_date,
ORD.store_id,
ORD.staff_id

FROM orders ORD

WHERE
ORD.order_date between '2025-08-05' and '2025-08-15'

ORDER BY
ORD.order_date asc