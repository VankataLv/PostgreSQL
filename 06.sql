-- 1
SELECT * FROM cities;
-- 2
SELECT 
	CONCAT(name, ' ', state) AS "cities_information",
	area AS "area_km2"
FROM cities;
--3
SELECT 
	DISTINCT name,
	area AS "area_km2"
FROM cities ORDER BY name DESC;
--4
SELECT 
	id,
	CONCAT("first_name", ' ', "last_name") AS "full_name",
	job_title
FROM employees ORDER BY first_name ASC LIMIT 50;
--5
SELECT
	id AS "id",
	CONCAT_WS(' ', 
				first_name,
				middle_name,
				last_name) AS full_name,
	hire_date
FROM employees ORDER BY hire_date ASC OFFSET 9;
--6
SELECT 
	id,
	CONCAT_WS(' ',
			  number,
			  street
	) AS "address",
	city_id
FROM addresses
WHERE id >= 20;
--7
SELECT
	CONCAT(number, ' ', street) AS "address",
	city_id
FROM addresses
WHERE city_id > 0 AND city_id % 2 = 0
ORDER BY city_id
	;
--8
SELECT
	name, 
	start_date, 
	end_date
FROM projects
WHERE 
	start_date >= '2016-06-01 07:00:00' 
	AND
	end_date < '2023-06-04 00:00:00'
ORDER BY start_date ASC;
-- 9
SELECT
	number,
	street
FROM addresses
WHERE 
	id BETWEEN 50 AND 100
	OR
	number < 1000
;
-- 10
SELECT
	employee_id,
	project_id
FROM employees_projects
WHERE
	employee_id IN (200, 250)
	AND
	project_id NOT IN (50, 100)
;
-- 11
SELECT
	name,
	start_date
FROM projects
WHERE 
	name IN ('Mountain', 'Road', 'Touring')
LIMIT 20;
-- 12
SELECT 
	CONCAT(first_name, ' ', last_name) AS "full_name",
	job_title,
	salary
FROM employees
WHERE salary IN (12500, 14000, 23600, 25000)
ORDER BY salary DESC
--13
SELECT
	id, 
	first_name,
	last_name
FROM employees
WHERE middle_name IS NULL
LIMIT 3
;
-- 14
INSERT INTO departments (department, manager_id)
VALUES 
	('Finance', 3),
	('Information Services', 42),
	('Document Control', 90),
	('Quality Assurance', 274),
	('Facilities and Maintenance', 218),
	('Shipping and Receiving', 85),
	('Executive', 109)
;
--15
CREATE TABLE company_chart 
AS
SELECT
	CONCAT(first_name, ' ', last_name) AS "full_name",
	job_title,
	department_id,
	manager_id
FROM employees
;
--16
UPDATE 
	projects
SET
	end_date = start_date + INTERVAL '5 months'
WHERE
	end_date is NULL
--RETURNING *;

--17
UPDATE 
	employees
SET 
	salary = salary + 1500,
	job_title = 'Senior ' || job_title
WHERE 
	hire_date BETWEEN 
	'1998-01-01' 
	AND
	'2000-01-05'
;
--18
DELETE FROM addresses
WHERE city_id IN (5, 17, 20, 30)
RETURNING *;
--19
CREATE VIEW view_company_chart AS
SELECT 
	full_name,
	job_title
FROM company_chart
WHERE 
	manager_id = 184;
--20
CREATE VIEW 
	view_addresses AS
SELECT
	CONCAT(e.first_name, ' ', e.last_name) AS full_name,
	department_id,
	CONCAT(a.number, ' ', a.street) AS address
FROM employees AS e, addresses as a
WHERE 
	a.id = e.address_id
ORDER BY address;
--21
ALTER VIEW view_addresses RENAME TO view_employee_addresses_info;
--22
UPDATE projects
SET 
	name = UPPER("name")
;
--22
CREATE VIEW view_initials AS
SELECT
	SUBSTRING(first_name, 1, 2) AS initial,
	last_name
FROM employees
ORDER BY last_name;
--23
SELECT 
	name,
	start_date
FROM projects
WHERE 
	name LIKE 'MOUNT%';