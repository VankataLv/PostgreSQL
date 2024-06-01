--1
SELECT 
	t.town_id,
	t.name AS town_name,
	a.address_text
FROM towns as t
INNER JOIN addresses AS a
ON a.town_id = t.town_id
WHERE t.name IN ('San Francisco', 'Sofia', 'Carnation')
ORDER BY town_id, address_id
;

--2
SELECT 
	e.employee_id,
	CONCAT (e.first_name, ' ', e.last_name) AS full_name,
	d.department_id,
	d.name AS department_name
FROM employees AS e
RIGHT JOIN departments AS d
ON d.manager_id = e.employee_id
ORDER BY e.employee_id
LIMIT 5;

--3
SELECT
	e.employee_id,
	CONCAT (e.first_name, ' ', e.last_name) AS full_name,
	p.project_id,
	p.name AS project_name
FROM employees AS e
JOIN employees_projects AS e_p
	USING(employee_id)
JOIN projects AS p
	USING(project_id)
WHERE e_p.project_id = 1
;

--4
SELECT
	COUNT(e.employee_id)
FROM 
	employees AS e
WHERE salary > (
SELECT 
	AVG(salary) AS avg_salary
FROM employees);
