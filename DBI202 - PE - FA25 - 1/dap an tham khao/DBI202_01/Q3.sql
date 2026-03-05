SELECT
PRO.product_id,
PRO.product_name,
PRO.list_price

FROM products PRO

WHERE
PRO.product_name LIKE '%City%'

ORDER BY
PRO.product_name asc