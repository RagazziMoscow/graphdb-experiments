CREATE OR REPLACE FUNCTION fill_links(records_count integer) RETURNS VOID AS
$BODY$
DECLARE
  obj1_value int;
  obj2_value int;
  data_type int;
  int_value int;
  string_value character varying;
  real_value real;
  binary_value bytea;
  datetime_value timestamp without time zone;
BEGIN
FOR i in 1..records_count LOOP
  int_value := NULL;
  string_value := NULL;
  real_value := NULL;
  binary_value := NULL;
  datetime_value := NULL;

  SELECT "nir-object".id INTO obj1_value FROM "nir-object" ORDER BY RANDOM() LIMIT 1;
  SELECT "nir-object".id INTO obj2_value FROM "nir-object" ORDER BY RANDOM() LIMIT 1;

  data_type:=floor(random() * 5 + 1)::int;

  IF data_type = 1 THEN
    int_value := random_int(50, 100);
  ELSIF data_type = 2 THEN
    string_value := random_string(6);
  ELSIF data_type = 3 THEN
    real_value := random_double(50, 100);
  ELSIF data_type = 4 THEN
    binary_value := random_bytea(6);
  ELSIF data_type = 5 THEN
    datetime_value := random_datetime('2012-05-05 00:00:00', '2016-06-06 00:00:00');
  END IF;

  INSERT INTO "nir-link" ("obj1",
                          "obj2",
                          "int",
                          "string",
                          "real",
                          "binary",
                          "datetime") VALUES (obj1_value,
				                                      obj2_value,
				                                      int_value,
				                                      string_value,
				                                      real_value,
				                                      binary_value,
				                                      datetime_value);
END LOOP;
END
$BODY$
  LANGUAGE plpgsql;