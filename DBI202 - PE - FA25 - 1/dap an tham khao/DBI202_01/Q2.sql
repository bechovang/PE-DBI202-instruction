SELECT
CUS.customer_id,
CUS.first_name,
CUS.last_name,
CUS.email

FROM customers CUS

ORDER BY CUS.last_name asc, CUS.first_name asc