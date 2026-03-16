-- q3
SELECT rc.ranking_system_id, rc.criteria_name
FROM ranking_criteria rc
WHERE rc.ranking_system_id IN (1, 2)
ORDER BY rc.ranking_system_id ASC, rc.criteria_name ASC
