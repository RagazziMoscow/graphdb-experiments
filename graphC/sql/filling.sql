CREATE OR REPLACE FUNCTION fill_objects(records_count integer)
  RETURNS void AS
$BODY$
BEGIN
  FOR i in 1..records_count LOOP
    INSERT INTO "nir-object" (name) VALUES (random_string(8));
  END LOOP;
END;
$BODY$
  LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION fill_links(records_count integer) RETURNS VOID AS
$BODY$
DECLARE
  obj1_value int;
  obj2_value int;
  data_type int;
  type_value character varying;
  str_value character varying;
BEGIN
FOR i in 1..records_count LOOP
  str_value := NULL;

  SELECT "nir-object".id INTO obj1_value FROM "nir-object" ORDER BY RANDOM() LIMIT 1;
  SELECT "nir-object".id INTO obj2_value FROM "nir-object" ORDER BY RANDOM() LIMIT 1;

  data_type:=floor(random() * 5 + 1)::int;

  IF data_type = 1 THEN
    type_value := 'int';
    str_value := random_int(50, 100)::text;
  ELSIF data_type = 2 THEN
    type_value := 'string';
    str_value := random_string(6);
  ELSIF data_type = 3 THEN
    type_value := 'double';
    str_value := random_double(50, 100)::text;
  ELSIF data_type = 4 THEN
    type_value := 'binary';
    str_value := random_bytea(6)::text;
  ELSIF data_type = 5 THEN
    type_value := 'datetime';
    str_value := random_datetime('2012-05-05 00:00:00', '2016-06-06 00:00:00');
  END IF;

  INSERT INTO "nir-link" ("obj1",
                          "obj2",
                          "type",
                          "string_value") VALUES (obj1_value,
                                                  obj2_value,
                                                  type_value,
                                                  str_value);
END LOOP;
END
$BODY$
  LANGUAGE plpgsql;