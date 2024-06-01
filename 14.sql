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

--12

--13
--14
--15
--16
--17
--18
--19
--20
--
--
--