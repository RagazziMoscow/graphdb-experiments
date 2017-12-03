--
-- PostgreSQL database dump
--

-- Dumped from database version 9.4.8
-- Dumped by pg_dump version 9.4.8
-- Started on 2017-12-03 23:52:38 MSK

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 2067 (class 1262 OID 19283)
-- Name: graphB; Type: DATABASE; Schema: -; Owner: admin
--

CREATE DATABASE "graphB" WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'ru_RU.UTF-8' LC_CTYPE = 'ru_RU.UTF-8';


ALTER DATABASE "graphB" OWNER TO admin;

\connect "graphB"

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 1 (class 3079 OID 11897)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2070 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- TOC entry 197 (class 1255 OID 19335)
-- Name: fill_links(integer); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION fill_links(records_count integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj1_value int;
  obj2_value int;
  data_type int;
  int_value int;
  string_value character varying;
  real_value real;
  binary_value bytea;
  datetime_value timestamp without time zone;
BEGIN
FOR i in 1..records_count LOOP
  int_value := NULL;
  string_value := NULL;
  real_value := NULL;
  binary_value := NULL;
  datetime_value := NULL;

  SELECT "nir-object".id INTO obj1_value FROM "nir-object" ORDER BY RANDOM() LIMIT 1;
  SELECT "nir-object".id INTO obj2_value FROM "nir-object" ORDER BY RANDOM() LIMIT 1;

  data_type:=floor(random() * 5 + 1)::int;

  IF data_type = 1 THEN
    int_value := random_int(50, 100);
  ELSIF data_type = 2 THEN
    string_value := random_string(6);
  ELSIF data_type = 3 THEN
    real_value := random_double(50, 100);
  ELSIF data_type = 4 THEN
    binary_value := random_bytea(6);
  ELSIF data_type = 5 THEN
    datetime_value := random_datetime('2012-05-05 00:00:00', '2016-06-06 00:00:00');
  END IF;

  INSERT INTO "nir-link" ("obj1",
                          "obj2",
                          "int",
                          "string",
                          "real",
                          "binary",
                          "datetime") VALUES (obj1_value,
				                                      obj2_value,
				                                      int_value,
				                                      string_value,
				                                      real_value,
				                                      binary_value,
				                                      datetime_value);
END LOOP;
END
$$;


ALTER FUNCTION public.fill_links(records_count integer) OWNER TO admin;

--
-- TOC entry 196 (class 1255 OID 19329)
-- Name: fill_objects(integer); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION fill_objects(records_count integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  FOR i in 1..records_count LOOP
    INSERT INTO "nir-object" (name) VALUES (random_string(8));
  END LOOP;
END;
$$;


ALTER FUNCTION public.fill_objects(records_count integer) OWNER TO admin;

--
-- TOC entry 179 (class 1255 OID 19324)
-- Name: random_bytea(integer); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION random_bytea(bytea_length integer) RETURNS bytea
    LANGUAGE sql
    SET search_path TO pg_catalog
    AS $_$
    SELECT decode(string_agg(lpad(to_hex(width_bucket(random(), 0, 1, 256)-1),2,'0') ,''), 'hex')
    FROM generate_series(1, $1);
$_$;


ALTER FUNCTION public.random_bytea(bytea_length integer) OWNER TO admin;

--
-- TOC entry 186 (class 1255 OID 19325)
-- Name: random_datetime(timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION random_datetime(start_date timestamp without time zone, end_date timestamp without time zone) RETURNS timestamp without time zone
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN start_date + random() * (end_date - start_date);
END
$$;


ALTER FUNCTION public.random_datetime(start_date timestamp without time zone, end_date timestamp without time zone) OWNER TO admin;

--
-- TOC entry 193 (class 1255 OID 19326)
-- Name: random_double(real, real); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION random_double(min real, max real) RETURNS real
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN random() * (max-min) + min;
END
$$;


ALTER FUNCTION public.random_double(min real, max real) OWNER TO admin;

--
-- TOC entry 194 (class 1255 OID 19327)
-- Name: random_int(integer, integer); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION random_int(min integer, max integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN floor(random() * max + min)::int;
END
$$;


ALTER FUNCTION public.random_int(min integer, max integer) OWNER TO admin;

--
-- TOC entry 195 (class 1255 OID 19328)
-- Name: random_string(integer); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION random_string(length integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.random_string(length integer) OWNER TO admin;

--
-- TOC entry 198 (class 1255 OID 19477)
-- Name: select_all_links(); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION select_all_links() RETURNS TABLE(obj text, attr text, type text, attr_value text)
    LANGUAGE plpgsql
    AS $$
DECLARE
  link_record RECORD;
BEGIN
  FOR link_record IN SELECT link.link_id, object_table.name AS obj_name,
			    object_table.name AS attr_name,
			    link.int, link.string, link.real,
			    link.binary, link.datetime
		     FROM "nir-link" link
		     JOIN "nir-object" object_table ON link.obj1 = object_table.id
		     LOOP
      obj := link_record.obj_name;
      attr := link_record.attr_name;

      IF link_record.int IS NOT NULL THEN
        attr_value := link_record.int::text;
        type := 'int';
      END IF;
      IF link_record.string IS NOT NULL THEN
        type := 'string';
        attr_value := link_record.string;
      END IF;
      IF link_record.real IS NOT NULL THEN
        type := 'real';
        attr_value := link_record.real::text;
      END IF;
      IF link_record.binary IS NOT NULL THEN
        type := 'binary';
        attr_value := link_record.binary::text;
      END IF;
      IF link_record.datetime IS NOT NULL THEN
        type := 'datetime';
        attr_value := link_record.datetime;
      END IF;
      RETURN NEXT;
  END LOOP;
END;
$$;


ALTER FUNCTION public.select_all_links() OWNER TO admin;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 174 (class 1259 OID 19286)
-- Name: migrations; Type: TABLE; Schema: public; Owner: admin; Tablespace: 
--

CREATE TABLE migrations (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    run_on timestamp without time zone NOT NULL
);


ALTER TABLE migrations OWNER TO admin;

--
-- TOC entry 173 (class 1259 OID 19284)
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE migrations_id_seq OWNER TO admin;

--
-- TOC entry 2071 (class 0 OID 0)
-- Dependencies: 173
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE migrations_id_seq OWNED BY migrations.id;


--
-- TOC entry 178 (class 1259 OID 19305)
-- Name: nir-link; Type: TABLE; Schema: public; Owner: admin; Tablespace: 
--

CREATE TABLE "nir-link" (
    link_id integer NOT NULL,
    obj1 integer,
    obj2 integer,
    "int" integer,
    string character varying,
    "real" real,
    datetime timestamp without time zone,
    "binary" bytea
);


ALTER TABLE "nir-link" OWNER TO admin;

--
-- TOC entry 177 (class 1259 OID 19303)
-- Name: nir-link_link_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE "nir-link_link_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "nir-link_link_id_seq" OWNER TO admin;

--
-- TOC entry 2072 (class 0 OID 0)
-- Dependencies: 177
-- Name: nir-link_link_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE "nir-link_link_id_seq" OWNED BY "nir-link".link_id;


--
-- TOC entry 176 (class 1259 OID 19294)
-- Name: nir-object; Type: TABLE; Schema: public; Owner: admin; Tablespace: 
--

CREATE TABLE "nir-object" (
    id integer NOT NULL,
    name character varying
);


ALTER TABLE "nir-object" OWNER TO admin;

--
-- TOC entry 175 (class 1259 OID 19292)
-- Name: nir-object_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE "nir-object_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "nir-object_id_seq" OWNER TO admin;

--
-- TOC entry 2073 (class 0 OID 0)
-- Dependencies: 175
-- Name: nir-object_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE "nir-object_id_seq" OWNED BY "nir-object".id;


--
-- TOC entry 1943 (class 2604 OID 19289)
-- Name: id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY migrations ALTER COLUMN id SET DEFAULT nextval('migrations_id_seq'::regclass);


--
-- TOC entry 1945 (class 2604 OID 19308)
-- Name: link_id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY "nir-link" ALTER COLUMN link_id SET DEFAULT nextval('"nir-link_link_id_seq"'::regclass);


--
-- TOC entry 1944 (class 2604 OID 19297)
-- Name: id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY "nir-object" ALTER COLUMN id SET DEFAULT nextval('"nir-object_id_seq"'::regclass);


--
-- TOC entry 1947 (class 2606 OID 19291)
-- Name: migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: admin; Tablespace: 
--

ALTER TABLE ONLY migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 1951 (class 2606 OID 19313)
-- Name: nir-link_pkey; Type: CONSTRAINT; Schema: public; Owner: admin; Tablespace: 
--

ALTER TABLE ONLY "nir-link"
    ADD CONSTRAINT "nir-link_pkey" PRIMARY KEY (link_id);


--
-- TOC entry 1949 (class 2606 OID 19302)
-- Name: nir-object_pkey; Type: CONSTRAINT; Schema: public; Owner: admin; Tablespace: 
--

ALTER TABLE ONLY "nir-object"
    ADD CONSTRAINT "nir-object_pkey" PRIMARY KEY (id);


--
-- TOC entry 1953 (class 2606 OID 19319)
-- Name: nir-object_nir-link_obj1_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY "nir-link"
    ADD CONSTRAINT "nir-object_nir-link_obj1_fk" FOREIGN KEY (obj1) REFERENCES "nir-object"(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- TOC entry 1952 (class 2606 OID 19314)
-- Name: nir-object_nir-link_obj2_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY "nir-link"
    ADD CONSTRAINT "nir-object_nir-link_obj2_fk" FOREIGN KEY (obj2) REFERENCES "nir-object"(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- TOC entry 2069 (class 0 OID 0)
-- Dependencies: 7
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2017-12-03 23:52:38 MSK

--
-- PostgreSQL database dump complete
--

