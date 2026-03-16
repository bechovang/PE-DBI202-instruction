--q5
SELECT rs.id AS system_id, rs.system_name, COUNT(rc.id) AS numberOfCriteria
FROM ranking_system rs
LEFT JOIN ranking_criteria rc ON rs.id = rc.ranking_system_id
GROUP BY rs.id, rs.system_name
ORDER BY numberOfCriteria DESC
