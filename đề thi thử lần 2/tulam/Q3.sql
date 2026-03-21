--q3


select 
	pi.ProductID,
	pi.LocationID,
	pi.Quantity
from ProductInventory pi 
where pi.LocationID = 7
	and pi.Quantity > 250
order by pi.Quantity desc