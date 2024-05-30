--1
CREATE TABLE mountains(
	id serial PRIMARY KEY,
	name VARCHAR(50)
);

CREATE TABLE peaks(
	id serial PRIMARY KEY,
	name VARCHAR(50),
	mountain_id INT,
	CONSTRAINT fk_peaks_mountains
		FOREIGN KEY (mountain_id)
		REFERENCES mountains(id)
);
--2
SELECT 
	v.driver_id,
	v.vehicle_type,
	CONCAT (c.first_name, ' ', c.last_name) AS driver_name
	FROM 
	vehicles AS v
	JOIN campers AS c
	ON c.id = v.driver_id;  
--3
SELECT 
	r.start_point,
	r.end_point,
	r.leader_id,
	CONCAT(c.first_name, ' ', c.last_name) AS leader_name
FROM 
	campers AS c
	JOIN 
	routes AS r
		ON c.id = r.leader_id
;
--4
CREATE TABLE mountains(
 id SERIAL PRIMARY KEY,
 name VARCHAR(50) NOT NULL
);

CREATE TABLE peaks(
 id SERIAL PRIMARY KEY,
 name VARCHAR(50) NOT NULL,
 mountain_id INT,
 CONSTRAINT fk_mountain_id 
 FOREIGN KEY(mountain_id)
 REFERENCES mountains(id)
 ON DELETE CASCADE
);
--5