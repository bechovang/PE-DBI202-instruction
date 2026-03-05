select
PRO.category_name,
PRO.product_id,
PRO.product_name,
PRO.list_price

from
products PRO
WHERE PRO.list_price = (
    SELECT MAX(pro2.list_price)
    FROM products pro2
    WHERE pro2.category_name = PRO.category_name
)
ORDER BY PRO.category_name asc, PRO.product_id asc