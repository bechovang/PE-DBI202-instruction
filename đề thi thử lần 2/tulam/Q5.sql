--q5


Select 
	pm.ModelID,
	pm.Name,
	count(p.ProductID) as NumberOfProducts

from ProductModel pm
left join Product p
	on pm.ModelID = p.ModelID
where 
	pm.Name like 'ML Mountain%'
	or pm.Name like 'Mountain%'
group by pm.ModelID, pm.Name
order by
	NumberOfProducts desc,
	pm.Name asc

