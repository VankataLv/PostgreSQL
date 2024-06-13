--1
CREATE TABLE towns(
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL
);

CREATE TABLE stadiums(
	id SERIAL PRIMARY KEY,
	name VARCHAR(45) NOT NULL,
	capacity INT CHECK(capacity > 0) NOT NULL,
	town_id INT REFERENCES towns ON DELETE CASCADE ON UPDATE CASCADE NOT NULL
);

CREATE TABLE teams(
	id SERIAL PRIMARY KEY,
	name VARCHAR(45) NOT NULL,
	established DATE NOT NULL,
	fan_base INT DEFAULT 0 CHECK(fan_base >= 0) NOT NULL,
	stadium_id INT REFERENCES stadiums ON DELETE CASCADE ON UPDATE CASCADE NOT NULL
);

CREATE TABLE coaches(
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(10) NOT NULL,
	last_name VARCHAR(20) NOT NULL,
	salary NUMERIC(10, 2) DEFAULT 0 CHECK(salary >= 0) NOT NULL,
	coach_level INT DEFAULT 0 CHECK(coach_level >= 0) NOT NULL
);

CREATE TABLE skills_data(
	id SERIAL PRIMARY KEY,
	dribbling INT DEFAULT 0 CHECK(dribbling >= 0),
	pace INT DEFAULT 0 CHECK(pace >= 0),
	passing INT DEFAULT 0 CHECK(passing >= 0),
	shooting INT DEFAULT 0 CHECK(shooting >= 0),
	speed INT DEFAULT 0 CHECK(speed >= 0),
	strength INT DEFAULT 0 CHECK(strength >= 0)
);

CREATE TABLE players(
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(10) NOT NULL,
	last_name VARCHAR(20) NOT NULL,
	age INT DEFAULT 0 CHECK(age >= 0) NOT NULL,
	position CHAR(1) NOT NULL,
	salary NUMERIC(10, 2) DEFAULT 0 CHECK(salary >= 0) NOT NULL,
	hire_date TIMESTAMP,
	skills_data_id INT REFERENCES skills_data ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	team_id INT REFERENCES teams ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE players_coaches(
	player_id INT REFERENCES players ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	coach_id INT REFERENCES coaches ON DELETE CASCADE ON UPDATE CASCADE NOT NULL
);

--2
INSERT INTO
	coaches(first_name, last_name, salary, coach_level)
SELECT 
	first_name,
	last_name,
	salary * 2 AS salary,
	LENGTH(first_name) AS coach_level
FROM players 
WHERE hire_date < '2013-12-13 07:18:46'
;
--3
UPDATE coaches
SET salary = salary * coach_level
WHERE id IN (
    SELECT DISTINCT coach_id
    FROM players_coaches
    WHERE coach_id IS NOT NULL
) AND
	LEFT(first_name, 1) = 'C'
; 
--4
-- Delete related records from the players_coaches table
DELETE FROM players_coaches
WHERE player_id IN (
    SELECT id
    FROM players
    WHERE hire_date < '2013-12-13 07:18:46'
);

-- Delete players from the players table
DELETE FROM players
WHERE hire_date < '2013-12-13 07:18:46';

--5
SELECT 
	CONCAT(first_name, ' ', last_name) AS full_name,
	age,
	hire_date
FROM players
WHERE
	first_name LIKE 'M%'
ORDER BY age DESC, full_name;
--6
SELECT
	p.id,
	CONCAT(p.first_name, ' ', p.last_name) AS full_name,
	p.age,
	p.position,
	p.salary,
	sd.pace,
	sd.shooting
FROM players AS p
JOIN skills_data AS sd
	ON sd.id = p.skills_data_id
WHERE
	p.position = 'A'
		AND
	team_id IS NULL
		AND
	130 < sd.pace + sd.shooting
;
--7
SELECT
	t.id AS team_id,
	t.name AS team_name,
	COUNT(p.id) AS player_count,
	fan_base
FROM teams AS t
LEFT JOIN players AS p
ON t.id = p.team_id
GROUP BY t.id, t.name, t.fan_base
HAVING fan_base > 30000
ORDER BY player_count DESC, fan_base DESC
	;
--8
SELECT
	CONCAT(c.first_name, ' ', c.last_name) AS coach_full_name,
	CONCAT(p.first_name, ' ', p.last_name) AS player_full_name,
	t.name AS team_name,
	s_d.passing,
	s_d.shooting,
	s_d.speed
FROM coaches AS c
	
JOIN players_coaches AS p_c
ON c.id = p_c.coach_id
JOIN players AS p
ON p.id = p_c.player_id
JOIN skills_data AS s_d
ON s_d.id = p.skills_data_id
JOIN teams AS t
ON t.id = p.team_id

ORDER BY coach_full_name, player_full_name DESC
;
--9
CREATE OR REPLACE FUNCTION fn_stadium_team_name(stadium_name VARCHAR(30))
RETURNS TABLE (
	team_name VARCHAR(200)) 
AS 
$$
BEGIN
	RETURN QUERY(
		SELECT t.name 
		FROM teams AS t
		JOIN stadiums AS s
		ON s.id = t.stadium_id
		WHERE s."name" = stadium_name
		ORDER BY t.name
	);
END;
$$
LANGUAGE plpgsql;
--10
CREATE OR REPLACE PROCEDURE sp_players_team_name(
	IN player_name VARCHAR(50),
	OUT team_name VARCHAR(45)
	)
LANGUAGE plpgsql
AS $$
BEGIN
	SELECT
		t.name INTO team_name
	FROM players AS p
	
	LEFT JOIN teams AS t
	ON t.id = p.team_id

	WHERE 
		CONCAT(p.first_name, ' ', p.last_name) = player_name
;

	IF team_name IS NULL THEN team_name := 'The player currently has no team'; END IF;
END;$$