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