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

CREATE TRIGGER show_update_details 
BEFORE UPDATE ON powerplants
FOR EACH ROW EXECUTE FUNCTION table_update_details();

UPDATE powerplants
SET owner = 2 WHERE name = '145 Talmadge Solar';

UPDATE powerplants
SET owner = 5 WHERE name = '180 Raritan Solar';

SELECT * FROM changes;

