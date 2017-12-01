CREATE OR REPLACE FUNCTION insert_links(records_count int) RETURNS table(obj1 int, obj2 int, datatype character varying) AS
$BODY$
DECLARE
  type int;
BEGIN
FOR i in 1..records_count LOOP
  SELECT "nir-object".id INTO obj1 FROM "nir-object" ORDER BY RANDOM() LIMIT 1;
  SELECT "nir-object".id INTO obj2 FROM "nir-object" ORDER BY RANDOM() LIMIT 1;

  type:=floor(random() * 5 + 1)::int;

  IF type = 1 THEN
    datatype := 'int';
  ELSIF type = 2 THEN
    datatype := 'string';
  ELSIF type = 3 THEN
    datatype := 'double';
  ELSIF type = 4 THEN
    datatype := 'binary';
  ELSIF type = 5 THEN
    datatype := 'datatime';
  END IF;

  RETURN NEXT;
END LOOP;
END
$BODY$
LANGUAGE plpgsql;