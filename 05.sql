-- 01
SELECT 
	id,
	first_name || ' ' || last_name AS "Full Name",
	job_title AS "Job Title"
FROM employees;

-- 02
SELECT
	id,
	CONCAT(first_name, ' ', last_name) AS full_name,
	job_title,
	salary
FROM 
	employees
WHERE 
	salary > 1000.00
ORDER BY id;

-- 03
SELECT 
	id, 
	first_name,
	last_name,
	job_title, 
	department_id,
	salary
FROM employees
WHERE department_id = 4 AND
	  salary >= 1000
ORDER BY id;

-- 04
INSERT INTO employees(first_name, last_name, job_title, department_id, salary)
	VALUES(
	'Samantha', 'Young', 'Housekeeping', 4, 900),
	('Roger', 'Palmer', 'Waiter', 3, 928.33);

SELECT * FROM employees;
-- 05
UPDATE employees
SET salary = salary + 100
WHERE job_title = 'Manager';

SELECT *
FROM employees
WHERE job_title = 'Manager';

-- 06
DELETE FROM employees
	WHERE department_id = 1 OR department_id = 2;

SELECT * FROM employees;

-- 07
CREATE VIEW top_paid_employee AS
SELECT * FROM employees
ORDER BY salary DESC LIMIT 1;
