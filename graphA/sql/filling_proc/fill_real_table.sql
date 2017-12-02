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
