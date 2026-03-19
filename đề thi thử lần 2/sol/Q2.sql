-- Question 2: Select all product subcategories of the category 'Accessories'
SELECT SubcategoryID, Category, Name
FROM ProductSubcategory
WHERE Category = 'Accessories'
ORDER BY SubcategoryID;
