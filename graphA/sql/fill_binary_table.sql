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
