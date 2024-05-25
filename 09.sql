--1
SELECT 
	department_id, 
 	COUNT(department_id) AS employee_count
FROM employees
GROUP BY 
	department_id
ORDER BY 
	department_id;
--2
SELECT 
	department_id, 
 	COUNT(salary) AS employee_count
FROM employees
GROUP BY 
	department_id
ORDER BY 
	department_id;
--3
SELECT 
	department_id, 
 	SUM(salary) AS total_salaries
FROM employees
GROUP BY 
	department_id
ORDER BY 
	department_id;
--4
SELECT 
	department_id, 
 	MAX(salary) AS max_salary
FROM employees
GROUP BY 
	department_id
ORDER BY 
	department_id;
--5
SELECT 
	department_id, 
 	MIN(salary) AS min_salary
FROM employees
GROUP BY 
	department_id
ORDER BY 
	department_id;
--6
SELECT 
	department_id, 
 	AVG(salary) AS avg_salary
FROM employees
GROUP BY 
	department_id
ORDER BY 
	department_id;
--7
SELECT 
	department_id, 
 	SUM(salary) AS "Total Salary"
FROM employees
GROUP BY 
	department_id
HAVING SUM(salary) < 4200
ORDER BY 
	department_id;
--8
SELECT 
	id,
	first_name,
	last_name,
	ROUND(salary, 2) as salary,
	department_id,
	CASE department_id
		WHEN 1 THEN 'Management'
		WHEN 2 THEN 'Kitchen Staff'
		WHEN 3 THEN 'Service Staff'
	ELSE 'Other'
	END AS department_name
FROM employees
;