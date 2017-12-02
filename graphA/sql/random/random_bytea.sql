CREATE OR REPLACE FUNCTION random_bytea(bytea_length integer)
  RETURNS bytea AS
$BODY$
    SELECT decode(string_agg(lpad(to_hex(width_bucket(random(), 0, 1, 256)-1),2,'0') ,''), 'hex')
    FROM generate_series(1, $1);
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION random_bytea(integer) SET search_path=pg_catalog;
