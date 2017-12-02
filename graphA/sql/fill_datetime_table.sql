CREATE OR REPLACE FUNCTION fill_datetime_table(start_date timestamp without time zone,
                                               end_date timestamp without time zone)
                                               RETURNS VOID AS
$BODY$
DECLARE
  link_record RECORD;
  date_value timestamp without time zone;
BEGIN
  FOR link_record IN SELECT t.link_id, t.type FROM "nir-link" t LOOP
    IF link_record.type = 'datatime' THEN
      date_value := random_datetime(start_date, end_date);
      INSERT INTO "date-time" (link_id, value) VALUES (link_record.link_id, date_value);
    END IF;
  END LOOP;
END;
$BODY$
LANGUAGE plpgsql;
