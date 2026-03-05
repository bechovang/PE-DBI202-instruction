DELETE pi
FROM stocks pi
INNER JOIN products l ON pi.product_id = l.product_id
WHERE l.category_name = 'Mountain'