CREATE OR REPLACE FUNCTION random_datetime(start_date timestamp without time zone,
                                           end_date timestamp without time zone)
                                    RETURNS timestamp without time zone AS
$BODY$
BEGIN
  RETURN start_date + random() * (end_date - start_date);
END
$BODY$
LANGUAGE plpgsql;