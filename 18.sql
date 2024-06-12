--1.1
CREATE TABLE addresses(
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL
);

CREATE TABLE categories(
	id SERIAL PRIMARY KEY,
	name VARCHAR(10) NOT NULL
);

CREATE TABLE clients(
	id SERIAL PRIMARY KEY,
	full_name VARCHAR(50) NOT NULL,
	phone_number VARCHAR(20) NOT NULL
);

CREATE TABLE drivers(
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(30) NOT NULL,
	last_name VARCHAR(30) NOT NULL,
	age INT NOT NULL,
	rating NUMERIC(2) DEFAULT 5.5,

	CONSTRAINT ck_age_positive
		CHECK (age > 0)
);

CREATE TABLE cars(
	id SERIAL PRIMARY KEY,
	make VARCHAR(20) NOT NULL,
	model VARCHAR(20),
	year INT DEFAULT 0 NOT NULL,
	mileage INT DEFAULT 0,
	condition CHAR(1) NOT NULL,
	category_id INT REFERENCES categories ON DELETE CASCADE ON UPDATE CASCADE NOT NULL
	
	CONSTRAINT ck_year_positive
		CHECK (year > 0),
	CONSTRAINT ck_mileage_positive
		CHECK (mileage > 0)
);

CREATE TABLE courses(
	id SERIAL PRIMARY KEY,
	from_address_id INT REFERENCES addresses ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	start TIMESTAMP NOT NULL,
	bill NUMERIC(10, 2) DEFAULT 10,
	car_id INT REFERENCES cars ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	client_id INT REFERENCES clients ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,

	CONSTRAINT ck_bill_positive
		CHECK (bill > 0)
);

CREATE TABLE cars_drivers(
	car_id INT REFERENCES cars ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	driver_id INT REFERENCES drivers ON DELETE CASCADE ON UPDATE CASCADE NOT NULL
);

--2.2
INSERT INTO
	clients(full_name, phone_number)
SELECT 
	CONCAT(first_name, ' ', last_name),
	CONCAT('(088) 9999', d.id * 2)
FROM drivers as d
WHERE d.id BETWEEN 10 AND 20
	;

--2.3
UPDATE cars
SET condition = 'C'
WHERE 
	(mileage >= 800000 OR mileage IS NULL)
	AND
	year <= 2010
	AND
	make != 'Mercedes-Benz' 
	;

--2.4
DELETE FROM clients
WHERE 
	LENGTH(full_name) >= 3
	AND
	id NOT IN(
	SELECT
		client_id
	FROM 
		courses
	)
	;
--3.5
SELECT 
	make,
	model,
	condition
FROM cars
ORDER BY id
;
--3.6
SELECT
	d.first_name,
	d.last_name,
	c.make,
	c.model,
	c.mileage
FROM
	drivers AS d
INNER JOIN cars_drivers
ON d.id = cars_drivers.driver_id
INNER JOIN cars AS c
ON c.id = cars_drivers.car_id
WHERE c.mileage IS NOT NULL
ORDER BY mileage DESC, first_name
;
--3.7
SELECT
	ca.id,
	ca.make,
	ca.mileage,
	COUNT(co.id) AS count_of_courses,
	ROUND(AVG(co.bill), 2) AS average_bill
FROM cars AS ca
LEFT JOIN courses AS co
ON co.car_id = ca.id
GROUP BY ca.id
HAVING COUNT(co.id) != 2
ORDER BY count_of_courses DESC, ca.id
	;
--3.8
SELECT
	cl.full_name,
	COUNT(co.car_id) AS count_of_cars,
	SUM(co.bill) AS total_sum
FROM clients AS cl
INNER JOIN courses AS co
ON co.client_id = cl.id
GROUP BY full_name
HAVING cl.full_name LIKE '_a%'
	AND
	COUNT(co.car_id) > 1
ORDER BY full_name 
	;
--3.9
SELECT
	ad.name AS address,
	CASE 
		WHEN EXTRACT(HOUR FROM co.start) BETWEEN 6 AND 20 THEN 'Day'
		ELSE 'Night'
	END AS day_time,
	bill,
	cl.full_name,
	make,
	model,
	categories.name
FROM courses AS co
INNER JOIN clients AS cl
ON cl.id = co.client_id
INNER JOIN cars
ON cars.id = co.car_id
INNER JOIN addresses AS ad
ON ad.id = co.from_address_id
INNER JOIN categories
ON categories.id = cars.category_id
ORDER BY co.id;

--4.10
CREATE FUNCTION fn_courses_by_client(phone_num VARCHAR(20))
RETURNS INT
AS 
$$
	DECLARE output INT;
	BEGIN
		SELECT 
	COUNT(co.id) INTO output
	FROM
		courses AS co
	INNER JOIN 
		clients AS cl
	ON cl.id = co.client_id
	WHERE cl.phone_number = phone_num
	;
	RETURN output;
	END;
$$
LANGUAGE plpgsql;
--4.11
CREATE TABLE IF NOT EXISTS search_results (
    id SERIAL PRIMARY KEY,
    address_name VARCHAR(50),
    full_name VARCHAR(100),
    level_of_bill VARCHAR(20),
    make VARCHAR(30),
    condition CHAR(1),
    category_name VARCHAR(50)
);

CREATE OR REPLACE PROCEDURE sp_courses_by_address(address_name VARCHAR(100))
LANGUAGE plpgsql
AS $$
BEGIN
	TRUNCATE search_results;

	INSERT INTO search_results(address_name, full_name, level_of_bill, make, condition, category_name)

	SELECT
		address_name,
		cl.full_name,
		CASE 
			WHEN bill <= 20 THEN 'Low'
			WHEN bill <= 30 THEN 'Medium' 
			ELSE 'High'
		END AS level_of_bill,
		ca.make,
		ca.condition,
		cat.name
	FROM addresses AS a
	JOIN courses AS co
	ON a.id = co.from_address_id
	JOIN cars AS ca
	ON ca.id = co.car_id
	JOIN categories AS cat
	ON cat.id = ca.category_id
	JOIN clients AS cl
	ON cl.id = co.client_id

	WHERE address_name = a.name
	ORDER BY make, full_name;
	
END;$$