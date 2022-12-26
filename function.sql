-- Функція, яка виводить кількість електростанцій у країні

CREATE OR REPLACE FUNCTION get_count_of_powerplants(country_arg varchar(50))
RETURNS NUMERIC
LANGUAGE 'plpgsql'
AS $$
DECLARE powerplants NUMERIC;

BEGIN
	powerplants := (SELECT COUNT(id) FROM powerplants WHERE country = country_arg);
	RETURN powerplants;
END;
$$;

SELECT get_count_of_powerplants('United States of America');
