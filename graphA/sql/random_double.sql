CREATE OR REPLACE FUNCTION random_double(min real, max real) RETURNS real AS
$BODY$
BEGIN
  RETURN random() * (max-min) + min;
END
$BODY$
LANGUAGE plpgsql;