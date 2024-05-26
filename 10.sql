--1
SELECT 
	COUNT(id)
FROM 
    wizard_deposits;
--2
SELECT 
	SUM(deposit_amount) AS total_amount
FROM wizard_deposits;
--3
SELECT
	ROUND(
		AVG(magic_wand_size),
	3) AS average_magic_wand_size
FROM 
	wizard_deposits;
--4
SELECT
	MIN(deposit_charge)
	AS minimum_deposit_charge
FROM 
	wizard_deposits;
--5
SELECT
	MAX(age)
	AS maximum_age
FROM 
	wizard_deposits;
--6
SELECT
	deposit_group,
	SUM(deposit_interest) AS total_interest
FROM 
	wizard_deposits
GROUP BY deposit_group
ORDER BY total_interest DESC
;
--7
SELECT
	magic_wand_creator,
	MIN(magic_wand_size) AS minimum_wand_size
FROM 
	wizard_deposits
GROUP BY magic_wand_creator
ORDER BY minimum_wand_size ASC
LIMIT 5
;
--8
SELECT
	deposit_group,
	is_deposit_expired,
	FLOOR(AVG(deposit_interest)) AS deposit_interest
FROM 
	wizard_deposits
WHERE 
	deposit_start_date > '1985-01-01'
GROUP BY 
	deposit_group, is_deposit_expired
ORDER BY 
	deposit_group DESC,
	is_deposit_expired ASC
;
--9
SELECT
	last_name,
	COUNT(notes) AS notes_with_dumbledore
FROM wizard_deposits
WHERE notes LIKE '%Dumbledore%'
GROUP BY last_name
;
--10
CREATE VIEW "view_wizard_deposits_with_expiration_date_before_1983_08_17" 
AS
SELECT
	CONCAT(first_name, ' ', last_name) AS wizard_name,
	deposit_start_date AS start_date,
	deposit_expiration_date AS expiration_date,
	deposit_amount AS amount
FROM wizard_deposits
WHERE deposit_expiration_date <= '1983-08-17'
GROUP BY wizard_name, start_date, expiration_date, amount 
ORDER BY expiration_date 
;
--11
SELECT
	magic_wand_creator,
	MAX(deposit_amount) AS max_deposit_amount
FROM wizard_deposits
WHERE deposit_amount NOT BETWEEN 20000 AND 40000
GROUP BY magic_wand_creator
ORDER BY max_deposit_amount DESC
LIMIT 3
;
--12
SELECT
	CASE 
		WHEN age BETWEEN 0 AND 10 THEN '[0-10]'
		WHEN age BETWEEN 11 AND 20 THEN '[11-20]'
		WHEN age BETWEEN 21 AND 30 THEN '[21-30]'
		WHEN age BETWEEN 31 AND 40 THEN '[31-40]'
		WHEN age BETWEEN 41 AND 50 THEN '[41-50]'
		WHEN age BETWEEN 51 AND 60 THEN '[51-60]'
		ELSE '[61+]'
	END age_group,
	COUNT(age)
FROM wizard_deposits
GROUP BY age_group
ORDER BY age_group
;
--13
SELECT
	COUNT(CASE department_id WHEN 1 THEN 1 END) "Engineering",
	COUNT(CASE department_id WHEN 2 THEN 2 END) "Tool Design",
	COUNT(CASE department_id WHEN 3 THEN 3 END) "Sales",
	COUNT(CASE department_id WHEN 4 THEN 4 END) "Marketing",
	COUNT(CASE department_id WHEN 5 THEN 5 END) "Purchasing",
	COUNT(CASE department_id WHEN 6 THEN 6 END) "Research and Development",
	COUNT(CASE department_id WHEN 7 THEN 7 END) "Production"
FROM employees;
--14
UPDATE employees
SET
	salary = CASE
				WHEN hire_date < '2015-01-16' THEN salary + 2500
				WHEN hire_date < '2020-03-04' THEN salary + 1500
				ELSE salary
				END,
	job_title = CASE
				WHEN hire_date < '2015-01-16' THEN CONCAT('Senior ', job_title)
				WHEN hire_date < '2020-03-04' THEN CONCAT('Mid-', job_title)
				ELSE job_title
				END
;
--15
SELECT
	job_title,
	CASE 
		WHEN AVG(salary) > 45800 THEN 'Good'
		WHEN AVG(salary) BETWEEN 27500 AND 45800 THEN 'Medium'
		ELSE 'Need Improvement'
	END AS category
FROM employees
GROUP BY job_title
ORDER BY 
	category, 
	job_title 
;
--16
SELECT
	project_name,
	CASE
		WHEN start_date IS NULL AND end_date IS NULL THEN 'Ready for development'
		WHEN start_date IS NOT NULL AND end_date IS NULL THEN 'In Progress'
		ELSE 'Done'
	END AS project_status
FROM projects
WHERE project_name LIKE '%Mountain%'
;
--17
SELECT 
	department_id,
	COUNT(id) as num_employees,
	CASE 
		WHEN AVG(salary) > 50000 THEN 'Above average'
		WHEN AVG(salary) <= 50000 THEN 'Below average'
	END
FROM employees
GROUP BY department_id
HAVING AVG(salary) > 30000
ORDER BY department_id
;
--18
--19
--20
