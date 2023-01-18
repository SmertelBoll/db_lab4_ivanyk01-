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

SELECT * FROM powerplants_by_own;
