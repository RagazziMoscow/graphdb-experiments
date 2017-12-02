CREATE OR REPLACE FUNCTION fill_links(records_count integer) RETURNS TABLE VOID AS
$BODY$
DECLARE
  obj1_value int;
  obj2_value int;
  data_type character varying;
BEGIN
FOR i in 1..records_count LOOP
  SELECT "nir-object".id INTO obj1_value FROM "nir-object" ORDER BY RANDOM() LIMIT 1;
  SELECT "nir-object".id INTO obj2_value FROM "nir-object" ORDER BY RANDOM() LIMIT 1;

  type:=floor(random() * 5 + 1)::int;

  IF type = 1 THEN
    data_type := 'int';
  ELSIF type = 2 THEN
    data_type := 'string';
  ELSIF type = 3 THEN
    data_type := 'double';
  ELSIF type = 4 THEN
    data_type := 'binary';
  ELSIF type = 5 THEN
    data_type := 'datetime';
  END IF;

  INSERT INTO "nir-link" (obj1, obj2, type) VALUES (obj1_value, obj2_value, data_type);
END LOOP;
END
$BODY$
  LANGUAGE plpgsql;