CREATE OR REPLACE FUNCTION random_int(min integer, max integer)
  RETURNS integer AS
$BODY$
BEGIN
  RETURN floor(random() * max + min)::int;
END
$BODY$
  LANGUAGE plpgsql;