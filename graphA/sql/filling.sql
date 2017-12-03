CREATE OR REPLACE FUNCTION fill_binary_table(bytea_length int) RETURNS VOID AS
$BODY$
DECLARE
  link_record RECORD;
  bin_value bytea;
BEGIN
  FOR link_record IN SELECT t.link_id, t.type FROM "nir-link" t LOOP
    IF link_record.type = 'binary' THEN
      bin_value := random_bytea(bytea_length);
      INSERT INTO "binary" (link_id, value) VALUES (link_record.link_id, bin_value);
    END IF;
  END LOOP;
END;
$BODY$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION fill_datetime_table(start_date timestamp without time zone,
                                               end_date timestamp without time zone)
                                               RETURNS VOID AS
$BODY$
DECLARE
  link_record RECORD;
  date_value timestamp without time zone;
BEGIN
  FOR link_record IN SELECT t.link_id, t.type FROM "nir-link" t LOOP
    IF link_record.type = 'datetime' THEN
      date_value := random_datetime(start_date, end_date);
      INSERT INTO "date-time" (link_id, value) VALUES (link_record.link_id, date_value);
    END IF;
  END LOOP;
END;
$BODY$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION fill_int_table(min_value int, max_value int) RETURNS VOID AS
$BODY$
DECLARE
  link_record RECORD;
  int_value int;
BEGIN
  FOR link_record IN SELECT t.link_id, t.type FROM "nir-link" t LOOP
    IF link_record.type = 'int' THEN
      int_value := random_int(min_value, max_value);
      INSERT INTO "int" (link_id, value) VALUES (link_record.link_id, int_value);
    END IF;
  END LOOP;
END;
$BODY$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION fill_links(records_count integer) RETURNS VOID AS
$BODY$
DECLARE
  obj1_value int;
  obj2_value int;
  type int;
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


CREATE OR REPLACE FUNCTION fill_real_table(min_value real, max_value real) RETURNS VOID AS
$BODY$
DECLARE
  link_record RECORD;
  double_value real;
BEGIN
  FOR link_record IN SELECT t.link_id, t.type FROM "nir-link" t LOOP
    IF link_record.type = 'double' THEN
      double_value := random_double(min_value, max_value);
      INSERT INTO "real" (link_id, value) VALUES (link_record.link_id, double_value);
    END IF;
  END LOOP;
END;
$BODY$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION fill_string_table(strings_length int) RETURNS VOID AS
$BODY$
DECLARE
  link_record RECORD;
  string_value character varying;
BEGIN
  FOR link_record IN SELECT t.link_id, t.type FROM "nir-link" t LOOP
    IF link_record.type = 'string' THEN
      string_value := random_string(strings_length);
      INSERT INTO "string" (link_id, value) VALUES (link_record.link_id, string_value);
    END IF;
  END LOOP;
END;
$BODY$
LANGUAGE plpgsql;
