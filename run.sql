-- Функція, яка виводить назву електростанції певного власника


CREATE OR REPLACE FUNCTION get_name_by_owner(own_name varchar(255))
RETURNS VARCHAR(255)
LANGUAGE 'plpgsql'
AS $$

BEGIN

    RETURN (SELECT name
            FROM powerplants
            JOIN owners on powerplants.owner = owners.owner_id 
            WHERE owners.owner_name = own_name
            GROUP BY powerplants.name);
END;
$$;

-- SELECT get_name_by_owner('SunRay Power LLC');

-- SELECT get_name_by_owner('PAR Renewables');


-- Процедура, яка створює нову таблицю з даними про назви електростанцій для переданого імені власника


CREATE OR REPLACE PROCEDURE new_table(own varchar(255))
LANGUAGE 'plpgsql'
AS $$
BEGIN
	DROP TABLE IF EXISTS powerplants_by_own;
	CREATE TABLE powerplants_by_own
	AS
	(SELECT id, name, owner FROM powerplants 
	 JOIN owners ON owners.owner_id = powerplants.owner
	 WHERE owner_name = own);
END;
$$;

CALL new_table('PAR Renewables');

-- SELECT * FROM powerplants_by_own;


-- Триггер для додавання у таблицю changes при кожному оновленні таблиці powerplants рядків з 
-- інформацією про час оновлення, колишнього тип палива станції та новий тип палива


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


-- UPDATE powerplants SET fuel_type = 2 WHERE name = '145 Talmadge Solar'
-- UPDATE powerplants SET fuel_type = 5 WHERE name = '180 Raritan Solar';

-- SELECT * FROM changes;