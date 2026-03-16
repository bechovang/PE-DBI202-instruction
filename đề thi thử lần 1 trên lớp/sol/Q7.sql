--q7
SELECT u.id AS university_id, u.university_name, rc.id AS ranking_criteria_id, rc.criteria_name, ury.year, ury.score
FROM university u
JOIN university_ranking_year ury ON u.id = ury.university_id
JOIN ranking_criteria rc ON ury.ranking_criteria_id = rc.id
WHERE ury.year = 2016 AND rc.criteria_name = 'Teaching'
AND ury.score IN (
	SELECT ury2.score
	FROM university_ranking_year ury2
	WHERE ury2.year = 2016 AND ury2.ranking_criteria_id = 1
	GROUP BY ury2.score
	HAVING COUNT(*) > 1
)
ORDER BY ury.score DESC
