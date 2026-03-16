--q2
SELECT rc.id, rc.ranking_system_id, rc.criteria_name
FROM ranking_criteria rc
ORDER BY rc.ranking_system_id, rc.id
