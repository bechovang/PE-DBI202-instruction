SELECT
    product_id,
    product_name,
    list_price
FROM products
WHERE list_price = (
    SELECT MIN(list_price) FROM products
);