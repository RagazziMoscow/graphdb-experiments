CREATE OR REPLACE FUNCTION random_bytea(bytea_length integer)
  RETURNS bytea AS
$BODY$
    SELECT decode(string_agg(lpad(to_hex(width_bucket(random(), 0, 1, 256)-1),2,'0') ,''), 'hex')
    FROM generate_series(1, $1);
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION random_bytea(integer) SET search_path=pg_catalog;


CREATE OR REPLACE FUNCTION random_datetime(start_date timestamp without time zone,
                                           end_date timestamp without time zone)
                                    RETURNS timestamp without time zone AS
$BODY$
BEGIN
  RETURN start_date + random() * (end_date - start_date);
END
$BODY$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION random_double(min real, max real) RETURNS real AS
$BODY$
BEGIN
  RETURN random() * (max-min) + min;
END
$BODY$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION random_int(min integer, max integer)
  RETURNS integer AS
$BODY$
BEGIN
  RETURN floor(random() * max + min)::int;
END
$BODY$
  LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION random_string(length integer)
  RETURNS text AS
$BODY$
DECLARE
  chars text[] := '{0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z}';
  result text := '';
  i integer := 0;
BEGIN
  IF length < 0 THEN
    RAISE EXCEPTION 'Given length cannot be less than 0';
  END IF;
  FOR i in 1..length LOOP
    result := result || chars[1+random()*(array_length(chars, 1)-1)];
  END LOOP;
  RETURN result;
END;
$BODY$
  LANGUAGE plpgsql;