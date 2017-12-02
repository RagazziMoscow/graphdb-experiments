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
