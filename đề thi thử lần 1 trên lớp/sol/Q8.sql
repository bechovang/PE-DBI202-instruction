--q8
CREATE PROCEDURE proc_university_year
	@year int,
	@pct_international_students int,
	@nbUniversity int OUTPUT
AS
BEGIN
	SELECT @nbUniversity = COUNT(*)
	FROM university_year
	WHERE year = @year AND pct_international_students > @pct_international_students
END
