-- q5

-- show system_id, system_name, numberOfCriteria 
-- numberOfCriteria = the number of criteria 
--	corresponding to the rankingsystem
-- = so rc noi rs


SELECT *
FROM ranking_criteria rc
JOIN ranking_system rs ON rc.ranking_system_id = rs.