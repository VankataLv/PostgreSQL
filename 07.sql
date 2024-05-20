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

--4
--5
--6
--7
