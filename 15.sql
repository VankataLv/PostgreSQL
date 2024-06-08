--1
CREATE OR REPLACE FUNCTION fn_count_employees_by_town(town_name_searched VARCHAR(20))
RETURNS INT
	AS
	$$
	DECLARE town_count INT;
	BEGIN
		SELECT COUNT(*) INTO town_count
		FROM employees AS e
			INNER JOIN addresses AS a
			USING (address_id)
			INNER JOIN towns AS t
			USING (town_id)
		WHERE t.name = town_name_searched;
		RETURN town_count;
	END;
	$$
LANGUAGE plpgsql
	;
--2
CREATE PROCEDURE sp_increase_salaries(department_name varchar(50))
LANGUAGE plpgsql
AS $$
BEGIN

UPDATE employees
SET salary = salary * 1.05
WHERE department_id = 
	(
	SELECT department_id 
	FROM departments AS d 
	WHERE d.name = department_name);
END; 
$$; 
-------
CALL sp_increase_salaries('Finance');

SELECT *
FROM employees
WHERE department_id = 
	(
	SELECT department_id 
	FROM departments AS d 
	WHERE d.name = 'Finance');
--------

--3
CREATE PROCEDURE sp_increase_salary_by_id(id INT)
LANGUAGE plpgsql
AS $$
BEGIN
IF (SELECT COUNT(employee_id) FROM employees WHERE employee_id = id) != 1 THEN
ROLLBACK;
ELSE
UPDATE employees SET salary = salary * 1.05 WHERE employee_id = id;
END IF;
COMMIT;
END; $$;

--4
CREATE FUNCTION trigger_fn_on_employee_delete() 
 RETURNS TRIGGER 
 LANGUAGE PLPGSQL
AS $$
BEGIN
 INSERT INTO deleted_employees (first_name,last_name,
middle_name,job_title,department_id,salary)
VALUES(OLD.first_name,OLD.last_name,OLD.middle_name,
OLD.job_title,OLD.department_id,OLD.salary);
 RETURN NULL;
END;$$;

