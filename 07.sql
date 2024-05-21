--1
SELECT 
	title
FROM 
	books
WHERE 
	SUBSTRING(title, 1, 3) = 'The';
--2
SELECT 
	replace(title, 'The', '***')
FROM 
	books
WHERE 
	SUBSTRING(title, 1, 3) = 'The'
ORDER BY id;
--3
SELECT 
	id,
	(side * height) / 2 AS area
FROM 
	triangles;
--4
SELECT 
	title,
	TRUNC(cost, 3) AS modified_price
FROM 
	books
ORDER BY id;
--5
SELECT 
	first_name,
	last_name,
	EXTRACT(year FROM born) AS year
FROM 
	authors
;
--6
SELECT 
	last_name AS "Last Name",
	TO_CHAR(born, 'DD (Dy) Mon YYYY') AS "Date of Birth"
FROM 
	authors
;
--7
SELECT 
	title
FROM 
	books
WHERE title LIKE 'Harry Potter%'
ORDER BY id;