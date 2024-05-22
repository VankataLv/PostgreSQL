--1
CREATE VIEW 
	view_river_info
AS
SELECT
	CONCAT('The river', ' ', river_name, ' ', 'flows into the', ' ', outflow, ' ', 'and is', ' ', "length", ' ', 'kilometers long.') AS "River Information"

FROM 
rivers
ORDER BY river_name;

--2
CREATE VIEW view_continents_countries_currencies_details
AS
SELECT
	CONCAT(
		at.continent_name, ': ', at.continent_code
	) AS continent_details,
	CONCAT(
		bt.country_name, ' - ', bt.capital, ' - ', bt.area_in_sq_km, ' - ', 'km2'
	) AS country_information,
	CONCAT(
		ct.description, ' (', ct.currency_code, ')'
	) AS currencies
FROM
	continents AS at,
	countries AS bt,
	currencies AS ct
WHERE
	at.continent_code = bt.continent_code
		AND
	bt.currency_code = ct.currency_code
ORDER BY
	country_information,
	currencies;
--3
ALTER TABLE 
	countries
ADD 
	capital_code CHAR(2)
;

UPDATE 
	countries
SET
	capital_code = SUBSTRING(capital, 1, 2)
;
--4
SELECT
	SUBSTRING(description, 5) as substring
FROM 
	currencies;
--5
SELECT
	(REGEXP_MATCHES("River Information", '[0-9]{1,4}'))[1] AS river_length
FROM 
	view_river_info;
--------------------------------------------------
SELECT
	SUBSTRING("River Information", '[0-9]{1,4}') AS river_length
FROM 
	view_river_info;
--6
SELECT
	REPLACE(mountain_range, 'a', '@') AS replace_a,
	REPLACE(mountain_range, 'A', '$') AS replace_A
FROM
	mountains;
--7
SELECT
	capital,
	TRANSLATE(capital, 'áãåçéíñóú', 'aaaceinou') AS translated_name
FROM 
	countries;
--8
SELECT
	continent_name,
	TRIM(LEADING FROM continent_name) AS "trim" 
FROM 
	continents;
--9
SELECT
	continent_name,
	TRIM(TRAILING FROM continent_name) AS "trim" 
FROM 
	continents;
--10
SELECT
	LTRIM(peak_name, 'M') AS left_trim,
	RTRIM(peak_name, 'm') AS right_trim 
FROM 
	peaks;
--11
SELECT
	CONCAT(
		m.mountain_range, ' ', p.peak_name
	) AS mountain_information,
	
	LENGTH(CONCAT(
		m.mountain_range, ' ', p.peak_name
	)) AS characters_length,
	BIT_LENGTH(CONCAT(
		m.mountain_range, ' ', p.peak_name
	)) AS bits_of_a_tring
	
FROM
	mountains AS m,
	peaks AS p
WHERE
	m."id" = p.mountain_id;

