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
END;
$$;

CALL new_table('gas');
select * from powerplants_by_fuel;
