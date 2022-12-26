-- Функція, яка виводить кількість електростанцій у країні

CREATE OR REPLACE FUNCTION get_count_of_powerplants(country_arg varchar(50))
RETURNS NUMERIC
LANGUAGE 'plpgsql'
AS $$
DECLARE powerplants NUMERIC;

BEGIN
	powerplants := (SELECT COUNT(id) FROM powerplants WHERE country = country_arg);
    RAISE INFO 'Count of powerplants: %,  Powerplant country: %', powerplants, country_arg;
	RETURN powerplants;
END;
$$;

-- SELECT get_count_of_powerplants('United States of America');


-- Процедура, яка створює нову таблицю з даними про назви електростанцій для переданого значення типу палива

CREATE OR REPLACE PROCEDURE new_table(fuel varchar(50))
LANGUAGE 'plpgsql'
AS $$
BEGIN
	DROP TABLE IF EXISTS powerplants_by_fuel;
	CREATE TABLE powerplants_by_fuel
	AS
	(SELECT id, name, fuel_name FROM powerplants 
	 JOIN fuels ON fuels.fuel_id = powerplants.fuel_type
	 WHERE fuel_name = fuel);
	 RAISE INFO 'Created table for: %', fuel;
END;
$$;

CALL new_table('gas');
-- select * from powerplants_by_fuel;


-- Триггер для додавання у таблицю changes при кожному оновленні таблиці powerplants рядків з інформацією про
-- час оновлення, колишнього власника станції та нового власника

DROP TABLE IF EXISTS changes;
CREATE TABLE changes(
	id SERIAL PRIMARY KEY,
	updated TIMESTAMP,
	old_owner INT NOT NULL,
	new_owner INT NOT NULL
);

CREATE OR REPLACE FUNCTION table_update_details() RETURNS trigger AS
$$
BEGIN
 	IF NEW.owner <> OLD.owner THEN
		INSERT INTO changes(updated, old_owner, new_owner)
		VALUES(NOW(), OLD.owner, NEW.owner);
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

DROP TRIGGER IF EXISTS show_update_details ON powerplants;
CREATE TRIGGER show_update_details 
BEFORE UPDATE ON powerplants
FOR EACH ROW EXECUTE FUNCTION table_update_details();

UPDATE powerplants SET owner = 2 WHERE name = '145 Talmadge Solar';
-- UPDATE powerplants SET owner = 7 WHERE name = '145 Talmadge Solar';

UPDATE powerplants SET owner = 5 WHERE name = '180 Raritan Solar';
-- UPDATE powerplants SET owner = 10 WHERE name = '180 Raritan Solar';

SELECT * FROM changes;

