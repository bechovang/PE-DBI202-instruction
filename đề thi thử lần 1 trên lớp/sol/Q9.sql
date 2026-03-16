--q9
CREATE TRIGGER tr_insert_university_ranking
ON university_ranking_year
AFTER INSERT
AS
BEGIN
	SELECT i.university_id, u.university_name, i.ranking_criteria_id, rc.criteria_name, i.year, i.score
	FROM inserted i
	JOIN university u ON i.university_id = u.id
	JOIN ranking_criteria rc ON i.ranking_criteria_id = rc.id
END
