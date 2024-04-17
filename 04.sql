-- 01
CREATE TABLE minions (
	id SERIAL PRIMARY KEY,
	name VARCHAR (30),
	age int
);
-- 02
ALTER TABLE minions RENAME TO minions_info; 
-- 03
ALTER TABLE minions_info 
	ADD code CHAR(4),
	ADD task TEXT,
	ADD salary NUMERIC(8, 3);
-- 04
ALTER TABLE minions_info RENAME salary TO banana;
-- 05
ALTER TABLE minions_info
	ADD email VARCHAR(20),
	ADD equipped BOOLEAN NOT NULL;

-- 06
CREATE TYPE type_mood
AS ENUM (
	'happy',
	'relaxed',
	'stressed',
	'sad'
);

ALTER TABLE minions_info 
	ADD COLUMN mood type_mood; 

-- 07
ALTER TABLE minions_info 

ALTER COLUMN age SET DEFAULT 0,
ALTER COLUMN "name" SET DEFAULT '',
ALTER COLUMN "code" SET DEFAULT '';

-- 08
ALTER TABLE minions_info 

ADD CONSTRAINT unique_containt
UNIQUE (id, email),

ADD CONSTRAINT banana_check
CHECK (banana > 0);

--09
ALTER TABLE minions_info
ALTER COLUMN task TYPE VARCHAR(150);

--10
ALTER TABLE minions_info
ALTER COLUMN equipped DROP NOT NULL;

--11
ALTER TABLE minions_info
DROP COLUMN age;
--12
CREATE TABLE minions_birthdays(
	id SERIAL UNIQUE NOT NULL,
	name VARCHAR(50),
	date_of_birth DATE,
	age INTEGER,
	present VARCHAR(100),
	party TIMESTAMPTZ
)
--13
INSERT INTO minions_info(name, code, task, banana, email, equipped, mood)
	VALUES 
	('Mark', 'GKYA', 'Graphing Points', 3265.265, 'mark@minion.com', false, 'happy'),
	('Mel', 'HSK', 'Science Investigation', 54784.996, 'mel@minion.com', true, 'stressed'),
	('Bob', 'HF', 'Painting', 35.652, 'bob@minion.com', true, 'happy'),
	('Darwin', 'EHND', 'Create a Digital Greeting', 321.958, 'darwin@minion.com', false, 'relaxed'),
	('Kevin', 'KMHD', 'Construct with Virtual Blocks', 35214.789, 'kevin@minion.com', false, 'happy'),
	('Norbert', 'FEWB', 'Testing', 3265.500, 'norbert@minion.com', true, 'sad'),
	('Donny', 'L', 'Make a Map', 8.452, 'donny@minion.com', true, 'happy');
--14
SELECT
	name,
	task,
	email,
	banana
FROM minions_info;
--15
TRUNCATE TABLE minions_info;
--16
DROP TABLE minions_birthdays;
--17
DROP DATABASE minions_db WITH (FORCE);
--BONUS

CREATE TYPE address AS (
	street TEXT,
	city TEXT,
	postalCode CHAR(4)
);

CREATE TABLE customers (
	id SERIAL PRIMARY KEY,
	customer_name TEXT,
	customer_address address
);


INSERT INTO 
	customers (customer_name, customer_address) 
VALUES ('Diyan', ('some street', 'sofia', '1616'));