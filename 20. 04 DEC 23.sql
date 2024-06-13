--1
CREATE TABLE IF NOT EXISTS countries(
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE customers(
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(25) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	gender CHAR(1) CHECK (gender IN ('M', 'F')),
	age INT CHECK (age > 0) NOT NULL,
	phone_number CHAR(10) NOT NULL,
	country_id INT REFERENCES countries ON DELETE CASCADE ON UPDATE CASCADE NOT NULL
);

CREATE TABLE products(
	id SERIAL PRIMARY KEY,
	name VARCHAR(25) NOT NULL,
	description VARCHAR(250),
	recipe TEXT,
	price NUMERIC(10, 2) CHECK(price > 0) NOT NULL
);

CREATE TABLE feedbacks(
	id SERIAL PRIMARY KEY,
	description VARCHAR(255),
	rate NUMERIC(4, 2) CHECK(rate >= 0 AND rate <= 10),
	product_id INT REFERENCES products ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	customer_id INT REFERENCES customers ON DELETE CASCADE ON UPDATE CASCADE NOT NULL
);

CREATE TABLE distributors(
	id SERIAL PRIMARY KEY,
	name VARCHAR(25) UNIQUE NOT NULL,
	address VARCHAR(30) NOT NULL,
	summary VARCHAR(200) NOT NULL,
	country_id INT REFERENCES countries ON DELETE CASCADE ON UPDATE CASCADE NOT NULL
);

CREATE TABLE ingredients(
	id SERIAL PRIMARY KEY,
	name VARCHAR(30) NOT NULL,
	description VARCHAR(200),
	country_id INT REFERENCES countries ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	distributor_id INT REFERENCES distributors ON DELETE CASCADE ON UPDATE CASCADE NOT NULL
);

CREATE TABLE products_ingredients(
	product_id INT REFERENCES products ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	ingredient_id INT REFERENCES ingredients ON DELETE CASCADE ON UPDATE CASCADE NOT NULL
);
--2
CREATE TABLE IF NOT EXISTS gift_recipients(
	id SERIAL PRIMARY KEY,
	name VARCHAR(100),
	country_id INT,
	gift_sent BOOLEAN 
);

INSERT INTO
	gift_recipients(name, country_id, gift_sent)
SELECT 
	CONCAT(first_name, ' ', last_name) AS name,
	country_id,
	CASE
 		WHEN country_id IN (7, 8, 14, 17, 26) THEN True
 	ELSE False
 END AS gift_sent
	
FROM customers 
;
--3
UPDATE products
SET price = price * 1.10
WHERE id IN (
   SELECT product_id
   FROM feedbacks
   WHERE rate > 8
);
--4
DELETE FROM ingredients
WHERE distributor_id IN (
    SELECT id
    FROM distributors
    WHERE LEFT(name, 1) = 'L'
);

DELETE FROM distributors
WHERE LEFT(name, 1) = 'L'
;
--5
SELECT
	name,
	recipe,
	price
FROM products
WHERE price BETWEEN 10 AND 20
ORDER BY price DESC;
--6
SELECT
	f.product_id,
	f.rate,
	f.description,
	f.customer_id,
	c.age,
	gender
FROM feedbacks AS f
	
JOIN customers AS c
ON c.id = f.customer_id

WHERE 
	c.gender = 'F'
		AND
	c.age > 30
		AND
	rate < 5.0
ORDER BY f.product_id DESC
	;
--7
SELECT
	p.name AS products_name,
	ROUND(AVG(p.price), 2) AS average_price,
	COUNT(f.product_id) AS total_feedbacks
FROM products AS p
JOIN feedbacks AS f
ON p.id = f.product_id
GROUP BY products_name, p.price
HAVING 
	p.price > 15.0
		AND
	COUNT(f.product_id) > 1
ORDER BY total_feedbacks, average_price DESC
	;
--8
SELECT
	i.name AS ingredient_name,
	p.name AS product_name,
	d.name AS distributor_name
	
FROM distributors AS d
JOIN ingredients AS i
ON d.id = i.distributor_id
JOIN products_ingredients AS p_i
ON i.id = p_i.ingredient_id
JOIN products AS p
ON p.id = p_i.product_id

WHERE 
	LOWER(i.name) = 'mustard'  
		AND
	d.country_id = 16
ORDER BY product_name
	;
--9
SELECT
	d.name AS distributor_name,
	i.name AS ingredient_name,
	p.name AS product_name,
	AVG(rate) AS average_rate
FROM distributors AS d
JOIN ingredients AS i
ON d.id = i.distributor_id
JOIN products_ingredients AS p_i
ON i.id = p_i.ingredient_id
JOIN products AS p
ON p.id = p_i.product_id
JOIN feedbacks AS f
ON p.id = f.product_id
GROUP BY distributor_name, ingredient_name, product_name
HAVING 
	AVG(rate) BETWEEN 5 AND 8
ORDER BY distributor_name, ingredient_name, product_name
	;
--10
CREATE OR REPLACE FUNCTION fn_feedbacks_for_product(product_name VARCHAR(25))
RETURNS TABLE (
	customer_id INT,
	customer_name VARCHAR(75),
	feedback_description VARCHAR(255),
	feedback_rate NUMERIC(4, 2) 
	) 
AS 
$$
BEGIN
	RETURN QUERY(
		SELECT 
			f.customer_id,
			c.first_name,
			f.description,
			f.rate	
		FROM feedbacks AS f
		JOIN customers AS c
		ON c.id = f.customer_id
		JOIN products AS p
		ON p.id = f.product_id
	
		WHERE 
			p.name = product_name
		ORDER BY f.customer_id
	);
END;
$$
LANGUAGE plpgsql;
--11
CREATE OR REPLACE PROCEDURE sp_customer_country_name(
	IN customer_full_name VARCHAR(50),
	OUT country_name VARCHAR(45)
	)
LANGUAGE plpgsql
AS $$
BEGIN
	SELECT
		con."name" INTO country_name
	FROM customers AS cus
	JOIN countries AS con
	ON con.id = cus.country_id
	WHERE CONCAT(cus.first_name, ' ', cus.last_name) = customer_full_name
	;

END;$$
