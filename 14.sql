--1
SELECT
	CONCAT (a.address, ' ', a.address_2) AS apartment_address,
	b.booked_for AS nights
FROM apartments AS a
JOIN bookings AS b
USING (booking_id)
ORDER BY a.apartment_id
;

--2
SELECT
	a.name,
	a.country,
	b.booked_at :: DATE
FROM apartments AS a
LEFT JOIN bookings AS b
USING (booking_id)
LIMIT 10
;

--3
SELECT
	b.booking_id,
	b.starts_at :: DATE,
	b.apartment_id,
	CONCAT (c.first_name, ' ', c.last_name) AS customer_name
FROM bookings AS b
RIGHT JOIN customers AS c
USING(customer_id)
ORDER BY customer_name
LIMIT 10
;

--4
SELECT 
	b.booking_id,
	a.name AS apartment_owner,
	a.apartment_id,
	CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM 
	bookings AS b
FULL JOIN apartments AS a
	USING (booking_id)
FULL JOIN customers AS c
	USING (customer_id)
ORDER BY booking_id, apartment_owner, customer_name
	;

--5
SELECT
	b.booking_id,
	c.first_name AS customer_name
FROM bookings AS b
CROSS JOIN customers AS c
ORDER BY customer_name
;

--6
SELECT
	b.booking_id,
	b.apartment_id,
	c.companion_full_name
	
FROM bookings AS b
JOIN customers AS c
USING (customer_id)
WHERE b.apartment_id IS NULL
;
--7
SELECT
	b.apartment_id,
	b.booked_for,
	c.first_name,
	c.country
FROM bookings AS b
INNER JOIN customers AS c
USING (customer_id)
WHERE c.job_type = 'Lead'
;

--8
SELECT
	COUNT(b.booking_id)
FROM bookings AS b
JOIN customers AS c
	USING(customer_id)
WHERE c.last_name = 'Hahn'
;
--9
SELECT
	a.name,
	SUM(b.booked_for) AS "sum"
FROM bookings AS b
JOIN apartments AS a
	USING(apartment_id)
GROUP BY a.name
ORDER BY a.name
;
--10
SELECT
	a.country,
	COUNT(b.booking_id) AS booking_count
FROM bookings AS b
	JOIN apartments as A
USING(apartment_id)
WHERE 
	b.booked_at > '2021-05-18 07:52:09.904+03' 
	AND
	b.booked_at < '2021-09-17 19:48:02.147+03' 
GROUP BY country
ORDER BY booking_count DESC
;
--11
SELECT 
	m_c.country_code,
	m.mountain_range,
	p.peak_name,
	p.elevation
FROM mountains AS m
INNER JOIN peaks AS p
	ON m.id = p.mountain_id
INNER JOIN mountains_countries AS m_c
	ON m.id = m_c.mountain_id
WHERE m_c.country_code = 'BG'
	AND
	p.elevation > 2835
ORDER BY p.elevation DESC
	;
--12
SELECT 
	m_c.country_code,
	COUNT(m.mountain_range)
FROM mountains_countries AS m_c
JOIN mountains AS m
ON m.id = m_c.mountain_id
WHERE m_c.country_code IN ('RU', 'BG', 'US')
GROUP BY m_c.country_code
ORDER BY m_c.country_code
    ;
--13
SELECT
	c.country_name,
	r.river_name
FROM countries AS c
LEFT JOIN countries_rivers AS c_r
USING (country_code)
LEFT JOIN rivers AS r
ON r.id = c_r.river_id
WHERE c.continent_code = 'AF'
ORDER BY c.country_name
LIMIT 5
	;
--14
SELECT
	MIN(average_area) AS min_average_area
FROM ( 
	SELECT
		AVG (c.area_in_sq_km) AS average_area
	FROM countries AS c
	GROUP BY c.continent_code)
	AS min_average_area
	;
--15
SELECT
	COUNT(*) AS countries_without_mountains
FROM countries AS c
LEFT JOIN mountains_countries AS m_r
USING (country_code)
WHERE m_r.mountain_id IS NULL
;
--16
CREATE TABLE IF NOT EXISTS monasteries (
	id SERIAL PRIMARY KEY,
	monastery_name VARCHAR(255),
	country_code CHAR(2)
);

INSERT INTO 
	monasteries (monastery_name, country_code)
VALUES
  ('Rila Monastery "St. Ivan of Rila"', 'BG'),
  ('Bachkovo Monastery "Virgin Mary"', 'BG'),
  ('Troyan Monastery "Holy Mother''s Assumption"', 'BG'),
  ('Kopan Monastery', 'NP'),
  ('Thrangu Tashi Yangtse Monastery', 'NP'),
  ('Shechen Tennyi Dargyeling Monastery', 'NP'),
  ('Benchen Monastery', 'NP'),
  ('Southern Shaolin Monastery', 'CN'),
  ('Dabei Monastery', 'CN'),
  ('Wa Sau Toi', 'CN'),
  ('Lhunshigyia Monastery', 'CN'),
  ('Rakya Monastery', 'CN'),
  ('Monasteries of Meteora', 'GR'),
  ('The Holy Monastery of Stavronikita', 'GR'),
  ('Taung Kalat Monastery', 'MM'),
  ('Pa-Auk Forest Monastery', 'MM'),
  ('Taktsang Palphug Monastery', 'BT'),
  ('Sümela Monastery', 'TR');

ALTER TABLE 
	countries
ADD COLUMN 
	three_rivers BOOLEAN DEFAULT FALSE;

UPDATE
	countries
SET three_rivers = (
	SELECT
		COUNT(*) >= 3
	FROM 
		countries_rivers AS cr
	WHERE 
		cr.country_code = countries.country_code
);

SELECT 
	m.monastery_name,
	c.country_name
FROM
	monasteries AS m
JOIN 
	countries AS c
USING
	(country_code)
WHERE 
	NOT three_rivers
ORDER BY
	monastery_name;