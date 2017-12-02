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
