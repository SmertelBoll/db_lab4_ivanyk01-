-- Триггер для додавання у таблицю changes при кожному оновленні таблиці powerplants рядків з інформацією про
-- час оновлення, колишнього тип палива станції та новий тип палива

DROP TABLE IF EXISTS changes;
CREATE TABLE changes(
	id SERIAL PRIMARY KEY,
	updated TIMESTAMP,
	old_fuel INT NOT NULL,
	new_fuel INT NOT NULL
);


CREATE OR REPLACE FUNCTION table_update_details() RETURNS trigger AS
$$
BEGIN
 	IF NEW.fuel_type <> OLD.fuel_type THEN
		INSERT INTO changes(updated, old_fuel, new_fuel)
		VALUES(NOW(), OLD.fuel_type, NEW.fuel_type);
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

DROP TRIGGER IF EXISTS show_update_details ON powerplants;
CREATE TRIGGER show_update_details 
BEFORE UPDATE ON powerplants
FOR EACH ROW EXECUTE FUNCTION table_update_details();

UPDATE powerplants SET fuel_type = 2 WHERE name = '145 Talmadge Solar';
-- UPDATE powerplants SET owner = 7 WHERE name = '145 Talmadge Solar';

UPDATE powerplants SET fuel_type = 5 WHERE name = '180 Raritan Solar';
-- UPDATE powerplants SET owner = 10 WHERE name = '180 Raritan Solar';

SELECT * FROM changes;