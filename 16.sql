--1
CREATE OR REPLACE FUNCTION fn_full_name(first_name VARCHAR(50), last_name VARCHAR(50))
RETURNS VARCHAR(101)
	AS
	$$
	DECLARE result VARCHAR(50);
	BEGIN
		result := CONCAT(INITCAP(first_name), ' ', INITCAP(last_name)) 	 
	;
		RETURN result;
	END;
	$$
LANGUAGE plpgsql
	;

SELECT * FROM fn_full_name('Ivan', 'ivanov')
--2
CREATE OR REPLACE FUNCTION fn_calculate_future_value(
	initial_sum DECIMAL,
	yearly_interest_rate DECIMAL,
	number_of_years INT
)
RETURNS DECIMAL
AS
$$
	BEGIN
	RETURN TRUNC(
	initial_sum * POWER(1 + yearly_interest_rate, number_of_years),
	4);
	END;
$$
LANGUAGE plpgsql;

SELECT * FROM fn_calculate_future_value (1000, 0.1, 5);
--3
CREATE OR REPLACE FUNCTION fn_is_word_comprised(
	set_of_letters VARCHAR(50),
	word VARCHAR(50)
)
RETURNS BOOLEAN
AS
$$
	BEGIN
	RETURN TRIM(LOWER(word), LOWER(set_of_letters)) = '';
	END;
$$
LANGUAGE plpgsql;

SELECT * FROM fn_is_word_comprised('ois tmiah%f', 'halves');
--4
CREATE OR REPLACE FUNCTION fn_is_game_over(is_game_over BOOLEAN )
RETURNS TABLE(
	name VARCHAR(50),
	game_type INT,
	is_finished BOOLEAN
)
AS
$$
BEGIN
	RETURN QUERY
	SELECT 
		g.name,
		g.game_type_id,
		g.is_finished
	FROM games AS g
	WHERE g.is_finished = is_game_over;
END;
$$
LANGUAGE plpgsql;
	;

SELECT * FROM fn_is_game_over(true);
--5

--
--
--
--
--
--
