--q4

SELECT 
	u.id,
	u.university_name,
	uy.[year],
	uy.num_students,
	uy.pct_international_students,
	u.country_id
FROM university u
-- thường sẽ là ON  Pk = FK
JOIN university_year uy ON u.id = uy.university_id
	
WHERE (uy.[year] = 2016)
	AND (pct_international_students > 30)
ORDER BY u.university_name ASC