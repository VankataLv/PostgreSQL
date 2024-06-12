--1
CREATE TABLE owners(
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	phone_number VARCHAR(15) NOT NULL,
	address VARCHAR(50)
);

CREATE TABLE animal_types(
	id SERIAL PRIMARY KEY,
	animal_type VARCHAR(30) NOT NULL
);

CREATE TABLE cages(
	id SERIAL PRIMARY KEY,
	animal_type_id INTEGER REFERENCES animal_types ON DELETE CASCADE ON UPDATE CASCADE NOT NULL
);

CREATE TABLE animals(
	id SERIAL PRIMARY KEY,
	name VARCHAR(30) NOT NULL,
	birthdate DATE NOT NULL,
	owner_id INT REFERENCES owners ON DELETE CASCADE ON UPDATE CASCADE,
	animal_type_id INT REFERENCES animal_types ON DELETE CASCADE ON UPDATE CASCADE NOT NULL
);

CREATE TABLE volunteers_departments(
	id SERIAL PRIMARY KEY,
	department_name VARCHAR(30) NOT NULL
);

CREATE TABLE volunteers(
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	phone_number VARCHAR(15) NOT NULL,
	address VARCHAR(50),
	animal_id INT REFERENCES animals ON DELETE CASCADE ON UPDATE CASCADE,
	department_id INT REFERENCES volunteers_departments ON DELETE CASCADE ON UPDATE CASCADE NOT NULL
);

CREATE TABLE animals_cages(
	cage_id INT REFERENCES cages ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	animal_id INT REFERENCES animals ON DELETE CASCADE ON UPDATE CASCADE NOT NULL
);

--2.2
INSERT INTO volunteers (
	"name", phone_number, address, animal_id, department_id
) 
VALUES 
	('Anita Kostova', '0896365412', 'Sofia, 5 Rosa str.', 15, 1),
	('Dimitur Stoev', '0877564223', NULL, 42, 4),
	('Kalina Evtimova', '0896321112', 'Silistra, 21 Breza str.', 9, 7),
	('Stoyan Tomov', '0898564100', 'Montana, 1 Bor str.', 18, 8),
	('Boryana Mileva', '0888112233', NULL, 31, 5)
	;

INSERT INTO animals (
	"name", birthdate, owner_id, animal_type_id
) 
VALUES 	
	('Giraffe', '2018-09-21', 21, 1),
	('Harpy Eagle', '2015-04-17', 15, 3),
	('Hamadryas Baboon', '2017-11-02', NULL, 1),
	('Tuatara', '2021-06-30', 2, 4)
	;
--2.3
UPDATE animals
SET owner_id = 4
WHERE owner_id IS NULL;
--2.4
DELETE FROM volunteers_departments
WHERE department_name = 'Education program assistant';
--3 OPTIONAL
DROP TABLE animal_types, animals, animals_cages, cages, owners, volunteers, volunteers_departments;
--3.5
SELECT 
	"name",
	"phone_number",
	"address",
	animal_id,
	department_id
FROM volunteers
ORDER BY "name", animal_id, department_id
;
--3.6
SELECT 
	a.name,
	a_t.animal_type,
	TO_CHAR(a.birthdate, 'DD.MM.YYYY') AS birthdate
FROM animals AS a
INNER JOIN animal_types AS a_t
	ON a_t.id = a.animal_type_id
ORDER BY a.name
	;
--3.7
SELECT
	o.name AS owner,
	COUNT(a.owner_id) AS count_of_animals
FROM owners AS o
INNER JOIN animals AS a
ON a.owner_id = o.id
GROUP BY o."name"
ORDER BY count_of_animals DESC, owner
LIMIT 5
	;
--3.8
SELECT 
	CONCAT(o.name, ' - ', a.name) AS owners_animals,
	o.phone_number,
	c.id
FROM owners AS o
	
INNER JOIN animals as a
ON o.id = a.owner_id

INNER JOIN animals_cages as a_c
ON a.id = a_c.animal_id

INNER JOIN cages as c
ON a_c.cage_id = c.id
	
WHERE c.animal_type_id = 1
ORDER BY o.name, a.name DESC
;
--3.9
SELECT 
	v.name AS "volunteers",
	v.phone_number,
	TRIM(LEADING 'Sofia, ' FROM v.address) AS address
FROM volunteers AS v
	
INNER JOIN volunteers_departments AS v_d
ON v_d.id = v.department_id

WHERE v_d.department_name = 'Education program assistant'
	AND
	v.address LIKE '%Sofia%'
ORDER BY volunteers
;
--3.10
SELECT 
	a.name,
	EXTRACT(year FROM a.birthdate) AS birth_year,
	a_t.animal_type
FROM animals as a
INNER JOIN animal_types as a_t
ON a_t.id = a.animal_type_id

WHERE a_t.animal_type != 'Birds'
	AND
	AGE('2022-01-01', a.birthdate) < '5 years'
	AND
	a.owner_id IS NULL
ORDER BY name
;
--4.11
CREATE FUNCTION fn_get_volunteers_count_from_department(searched_volunteers_department VARCHAR(30))
RETURNS INT
AS 
$$
	DECLARE output INT;
	BEGIN
		SELECT 
		COUNT (v.id) INTO output
		FROM volunteers AS v
		INNER JOIN volunteers_departments AS v_d
		ON v_d.id = v.department_id
		WHERE v_d.department_name = searched_volunteers_department;
	RETURN output;
	END;
$$
LANGUAGE plpgsql;
--4.12
CREATE PROCEDURE sp_animals_with_owners_or_not(
	IN animal_name VARCHAR(30),
	OUT result VARCHAR(30)
	)
LANGUAGE plpgsql
AS $$
BEGIN
	SELECT o.name
	INTO result
	FROM owners as o
	INNER JOIN animals as a
	ON a.owner_id = o.id
	WHERE a.name = animal_name;

	IF result IS NULL THEN result := 'For adoption'; END IF;
END;$$