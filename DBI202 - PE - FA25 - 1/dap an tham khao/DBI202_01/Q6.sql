select
STO.store_id,
STO.store_name,
sum(QTY.quantity) as 'total_qty_in_stock'

from
stores STO
join
stocks QTY on QTY.store_id = STO.store_id

group by STO.store_id, STO.store_name

ORDER BY total_qty_in_stock desc, STO.store_id asc
