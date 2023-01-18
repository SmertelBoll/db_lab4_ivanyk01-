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

SELECT get_name_by_owner('SunRay Power LLC');

SELECT get_name_by_owner('PAR Renewables');
