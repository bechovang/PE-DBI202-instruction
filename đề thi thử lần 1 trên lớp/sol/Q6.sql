--q6
SELECT u.id AS university_id, u.university_name, uy.year, uy.student_staff_ratio
FROM university u
JOIN university_year uy ON u.id = uy.university_id
WHERE uy.year = 2015 AND uy.student_staff_ratio = (SELECT MIN(student_staff_ratio) FROM university_year WHERE year = 2015)
