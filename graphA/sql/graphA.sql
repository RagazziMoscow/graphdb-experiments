--
-- PostgreSQL database dump
--

-- Dumped from database version 9.4.8
-- Dumped by pg_dump version 9.4.8
-- Started on 2017-12-03 23:51:30 MSK

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 2124 (class 1262 OID 19348)
-- Name: graphA; Type: DATABASE; Schema: -; Owner: admin
--

CREATE DATABASE "graphA" WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'ru_RU.UTF-8' LC_CTYPE = 'ru_RU.UTF-8';


ALTER DATABASE "graphA" OWNER TO admin;

\connect "graphA"

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
-- TOC entry 2127 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- TOC entry 206 (class 1255 OID 19465)
-- Name: fill_binary_table(integer); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION fill_binary_table(bytea_length integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.fill_binary_table(bytea_length integer) OWNER TO admin;

--
-- TOC entry 207 (class 1255 OID 19466)
-- Name: fill_datetime_table(timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION fill_datetime_table(start_date timestamp without time zone, end_date timestamp without time zone) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  link_record RECORD;
  date_value timestamp without time zone;
BEGIN
  FOR link_record IN SELECT t.link_id, t.type FROM "nir-link" t LOOP
    IF link_record.type = 'datetime' THEN
      date_value := random_datetime(start_date, end_date);
      INSERT INTO "date-time" (link_id, value) VALUES (link_record.link_id, date_value);
    END IF;
  END LOOP;
END;
$$;


ALTER FUNCTION public.fill_datetime_table(start_date timestamp without time zone, end_date timestamp without time zone) OWNER TO admin;

--
-- TOC entry 208 (class 1255 OID 19467)
-- Name: fill_int_table(integer, integer); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION fill_int_table(min_value integer, max_value integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  link_record RECORD;
  int_value int;
BEGIN
  FOR link_record IN SELECT t.link_id, t.type FROM "nir-link" t LOOP
    IF link_record.type = 'int' THEN
      int_value := random_int(min_value, max_value);
      INSERT INTO "int" (link_id, value) VALUES (link_record.link_id, int_value);
    END IF;
  END LOOP;
END;
$$;


ALTER FUNCTION public.fill_int_table(min_value integer, max_value integer) OWNER TO admin;

--
-- TOC entry 209 (class 1255 OID 19469)
-- Name: fill_links(integer); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION fill_links(records_count integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj1_value int;
  obj2_value int;
  type int;
  data_type character varying;
BEGIN
FOR i in 1..records_count LOOP
  SELECT "nir-object".id INTO obj1_value FROM "nir-object" ORDER BY RANDOM() LIMIT 1;
  SELECT "nir-object".id INTO obj2_value FROM "nir-object" ORDER BY RANDOM() LIMIT 1;

  type:=floor(random() * 5 + 1)::int;

  IF type = 1 THEN
    data_type := 'int';
  ELSIF type = 2 THEN
    data_type := 'string';
  ELSIF type = 3 THEN
    data_type := 'double';
  ELSIF type = 4 THEN
    data_type := 'binary';
  ELSIF type = 5 THEN
    data_type := 'datetime';
  END IF;

  INSERT INTO "nir-link" (obj1, obj2, type) VALUES (obj1_value, obj2_value, data_type);
END LOOP;
END
$$;


ALTER FUNCTION public.fill_links(records_count integer) OWNER TO admin;

--
-- TOC entry 210 (class 1255 OID 19470)
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
-- TOC entry 211 (class 1255 OID 19471)
-- Name: fill_real_table(real, real); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION fill_real_table(min_value real, max_value real) RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.fill_real_table(min_value real, max_value real) OWNER TO admin;

--
-- TOC entry 212 (class 1255 OID 19472)
-- Name: fill_string_table(integer); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION fill_string_table(strings_length integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  link_record RECORD;
  string_value character varying;
BEGIN
  FOR link_record IN SELECT t.link_id, t.type FROM "nir-link" t LOOP
    IF link_record.type = 'string' THEN
      string_value := random_string(strings_length);
      INSERT INTO "string" (link_id, value) VALUES (link_record.link_id, string_value);
    END IF;
  END LOOP;
END;
$$;


ALTER FUNCTION public.fill_string_table(strings_length integer) OWNER TO admin;

--
-- TOC entry 189 (class 1255 OID 19460)
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
-- TOC entry 196 (class 1255 OID 19461)
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
-- TOC entry 203 (class 1255 OID 19462)
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
-- TOC entry 204 (class 1255 OID 19463)
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
-- TOC entry 205 (class 1255 OID 19464)
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
-- TOC entry 213 (class 1255 OID 19475)
-- Name: select_all_links(); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION select_all_links() RETURNS TABLE(obj text, attr text, type text, attr_value text)
    LANGUAGE plpgsql
    AS $$
DECLARE
  link_record RECORD;
BEGIN
  FOR link_record IN SELECT link.link_id, object1.name AS obj1_name, object2.name AS obj2_name, link.type FROM "nir-link" link
    JOIN "nir-object" object1 ON link.obj1 = object1.id
    JOIN "nir-object" object2 ON link.obj2 = object2.id

    LOOP
      obj := link_record.obj1_name;
      attr := link_record.obj2_name;
      type := link_record.type;

      IF type = 'int' THEN
        SELECT value::text INTO attr_value  FROM "int" int_table WHERE int_table.link_id = link_record.link_id LIMIT 1;
      END IF;
      IF type = 'string' THEN
        SELECT value INTO attr_value FROM "string" string_table WHERE string_table.link_id = link_record.link_id LIMIT 1;
      END IF;
      IF type = 'double' THEN
        SELECT value::text INTO attr_value FROM "real" real_table WHERE real_table.link_id = link_record.link_id LIMIT 1;
      END IF;
      IF type = 'binary' THEN
        SELECT value::text INTO attr_value FROM "binary" binary_table WHERE binary_table.link_id = link_record.link_id LIMIT 1;
      END IF;
      IF type = 'datetime' THEN
        SELECT value INTO attr_value FROM "date-time" datetime_table WHERE datetime_table.link_id = link_record.link_id LIMIT 1;
      END IF;
      RETURN NEXT;
  END LOOP;
END;
$$;


ALTER FUNCTION public.select_all_links() OWNER TO admin;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 186 (class 1259 OID 19423)
-- Name: binary; Type: TABLE; Schema: public; Owner: admin; Tablespace: 
--

CREATE TABLE "binary" (
    id integer NOT NULL,
    link_id integer NOT NULL,
    value bytea NOT NULL
);


ALTER TABLE "binary" OWNER TO admin;

--
-- TOC entry 185 (class 1259 OID 19421)
-- Name: binary_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE binary_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE binary_id_seq OWNER TO admin;

--
-- TOC entry 2128 (class 0 OID 0)
-- Dependencies: 185
-- Name: binary_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE binary_id_seq OWNED BY "binary".id;


--
-- TOC entry 188 (class 1259 OID 19434)
-- Name: date-time; Type: TABLE; Schema: public; Owner: admin; Tablespace: 
--

CREATE TABLE "date-time" (
    id integer NOT NULL,
    link_id integer NOT NULL,
    value timestamp without time zone NOT NULL
);


ALTER TABLE "date-time" OWNER TO admin;

--
-- TOC entry 187 (class 1259 OID 19432)
-- Name: date-time_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE "date-time_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "date-time_id_seq" OWNER TO admin;

--
-- TOC entry 2129 (class 0 OID 0)
-- Dependencies: 187
-- Name: date-time_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE "date-time_id_seq" OWNED BY "date-time".id;


--
-- TOC entry 180 (class 1259 OID 19391)
-- Name: int; Type: TABLE; Schema: public; Owner: admin; Tablespace: 
--

CREATE TABLE "int" (
    id integer NOT NULL,
    link_id integer NOT NULL,
    value integer NOT NULL
);


ALTER TABLE "int" OWNER TO admin;

--
-- TOC entry 179 (class 1259 OID 19389)
-- Name: int_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE int_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE int_id_seq OWNER TO admin;

--
-- TOC entry 2130 (class 0 OID 0)
-- Dependencies: 179
-- Name: int_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE int_id_seq OWNED BY "int".id;


--
-- TOC entry 174 (class 1259 OID 19351)
-- Name: migrations; Type: TABLE; Schema: public; Owner: admin; Tablespace: 
--

CREATE TABLE migrations (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    run_on timestamp without time zone NOT NULL
);


ALTER TABLE migrations OWNER TO admin;

--
-- TOC entry 173 (class 1259 OID 19349)
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
-- TOC entry 2131 (class 0 OID 0)
-- Dependencies: 173
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE migrations_id_seq OWNED BY migrations.id;


--
-- TOC entry 178 (class 1259 OID 19370)
-- Name: nir-link; Type: TABLE; Schema: public; Owner: admin; Tablespace: 
--

CREATE TABLE "nir-link" (
    link_id integer NOT NULL,
    obj1 integer NOT NULL,
    obj2 integer NOT NULL,
    type character varying
);


ALTER TABLE "nir-link" OWNER TO admin;

--
-- TOC entry 177 (class 1259 OID 19368)
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
-- TOC entry 2132 (class 0 OID 0)
-- Dependencies: 177
-- Name: nir-link_link_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE "nir-link_link_id_seq" OWNED BY "nir-link".link_id;


--
-- TOC entry 176 (class 1259 OID 19359)
-- Name: nir-object; Type: TABLE; Schema: public; Owner: admin; Tablespace: 
--

CREATE TABLE "nir-object" (
    id integer NOT NULL,
    name character varying
);


ALTER TABLE "nir-object" OWNER TO admin;

--
-- TOC entry 175 (class 1259 OID 19357)
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
-- TOC entry 2133 (class 0 OID 0)
-- Dependencies: 175
-- Name: nir-object_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE "nir-object_id_seq" OWNED BY "nir-object".id;


--
-- TOC entry 184 (class 1259 OID 19415)
-- Name: real; Type: TABLE; Schema: public; Owner: admin; Tablespace: 
--

CREATE TABLE "real" (
    id integer NOT NULL,
    link_id integer NOT NULL,
    value real NOT NULL
);


ALTER TABLE "real" OWNER TO admin;

--
-- TOC entry 183 (class 1259 OID 19413)
-- Name: real_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE real_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE real_id_seq OWNER TO admin;

--
-- TOC entry 2134 (class 0 OID 0)
-- Dependencies: 183
-- Name: real_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE real_id_seq OWNED BY "real".id;


--
-- TOC entry 182 (class 1259 OID 19404)
-- Name: string; Type: TABLE; Schema: public; Owner: admin; Tablespace: 
--

CREATE TABLE string (
    id integer NOT NULL,
    link_id integer NOT NULL,
    value character varying NOT NULL
);


ALTER TABLE string OWNER TO admin;

--
-- TOC entry 181 (class 1259 OID 19402)
-- Name: string_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE string_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE string_id_seq OWNER TO admin;

--
-- TOC entry 2135 (class 0 OID 0)
-- Dependencies: 181
-- Name: string_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE string_id_seq OWNED BY string.id;


--
-- TOC entry 1986 (class 2604 OID 19426)
-- Name: id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY "binary" ALTER COLUMN id SET DEFAULT nextval('binary_id_seq'::regclass);


--
-- TOC entry 1987 (class 2604 OID 19437)
-- Name: id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY "date-time" ALTER COLUMN id SET DEFAULT nextval('"date-time_id_seq"'::regclass);


--
-- TOC entry 1983 (class 2604 OID 19394)
-- Name: id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY "int" ALTER COLUMN id SET DEFAULT nextval('int_id_seq'::regclass);


--
-- TOC entry 1980 (class 2604 OID 19354)
-- Name: id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY migrations ALTER COLUMN id SET DEFAULT nextval('migrations_id_seq'::regclass);


--
-- TOC entry 1982 (class 2604 OID 19373)
-- Name: link_id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY "nir-link" ALTER COLUMN link_id SET DEFAULT nextval('"nir-link_link_id_seq"'::regclass);


--
-- TOC entry 1981 (class 2604 OID 19362)
-- Name: id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY "nir-object" ALTER COLUMN id SET DEFAULT nextval('"nir-object_id_seq"'::regclass);


--
-- TOC entry 1985 (class 2604 OID 19418)
-- Name: id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY "real" ALTER COLUMN id SET DEFAULT nextval('real_id_seq'::regclass);


--
-- TOC entry 1984 (class 2604 OID 19407)
-- Name: id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY string ALTER COLUMN id SET DEFAULT nextval('string_id_seq'::regclass);


--
-- TOC entry 2001 (class 2606 OID 19431)
-- Name: binary_pkey; Type: CONSTRAINT; Schema: public; Owner: admin; Tablespace: 
--

ALTER TABLE ONLY "binary"
    ADD CONSTRAINT binary_pkey PRIMARY KEY (id);


--
-- TOC entry 2003 (class 2606 OID 19439)
-- Name: date-time_pkey; Type: CONSTRAINT; Schema: public; Owner: admin; Tablespace: 
--

ALTER TABLE ONLY "date-time"
    ADD CONSTRAINT "date-time_pkey" PRIMARY KEY (id);


--
-- TOC entry 1995 (class 2606 OID 19396)
-- Name: int_pkey; Type: CONSTRAINT; Schema: public; Owner: admin; Tablespace: 
--

ALTER TABLE ONLY "int"
    ADD CONSTRAINT int_pkey PRIMARY KEY (id);


--
-- TOC entry 1989 (class 2606 OID 19356)
-- Name: migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: admin; Tablespace: 
--

ALTER TABLE ONLY migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 1993 (class 2606 OID 19378)
-- Name: nir-link_pkey; Type: CONSTRAINT; Schema: public; Owner: admin; Tablespace: 
--

ALTER TABLE ONLY "nir-link"
    ADD CONSTRAINT "nir-link_pkey" PRIMARY KEY (link_id);


--
-- TOC entry 1991 (class 2606 OID 19367)
-- Name: nir-object_pkey; Type: CONSTRAINT; Schema: public; Owner: admin; Tablespace: 
--

ALTER TABLE ONLY "nir-object"
    ADD CONSTRAINT "nir-object_pkey" PRIMARY KEY (id);


--
-- TOC entry 1999 (class 2606 OID 19420)
-- Name: real_pkey; Type: CONSTRAINT; Schema: public; Owner: admin; Tablespace: 
--

ALTER TABLE ONLY "real"
    ADD CONSTRAINT real_pkey PRIMARY KEY (id);


--
-- TOC entry 1997 (class 2606 OID 19412)
-- Name: string_pkey; Type: CONSTRAINT; Schema: public; Owner: admin; Tablespace: 
--

ALTER TABLE ONLY string
    ADD CONSTRAINT string_pkey PRIMARY KEY (id);


--
-- TOC entry 2009 (class 2606 OID 19450)
-- Name: nir-link_binary_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY "binary"
    ADD CONSTRAINT "nir-link_binary_fk" FOREIGN KEY (link_id) REFERENCES "nir-link"(link_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- TOC entry 2010 (class 2606 OID 19455)
-- Name: nir-link_date-time_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY "date-time"
    ADD CONSTRAINT "nir-link_date-time_fk" FOREIGN KEY (link_id) REFERENCES "nir-link"(link_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- TOC entry 2006 (class 2606 OID 19397)
-- Name: nir-link_int_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY "int"
    ADD CONSTRAINT "nir-link_int_fk" FOREIGN KEY (link_id) REFERENCES "nir-link"(link_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- TOC entry 2008 (class 2606 OID 19445)
-- Name: nir-link_real_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY "real"
    ADD CONSTRAINT "nir-link_real_fk" FOREIGN KEY (link_id) REFERENCES "nir-link"(link_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- TOC entry 2007 (class 2606 OID 19440)
-- Name: nir-link_string_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY string
    ADD CONSTRAINT "nir-link_string_fk" FOREIGN KEY (link_id) REFERENCES "nir-link"(link_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- TOC entry 2005 (class 2606 OID 19384)
-- Name: nir-object_nir-link_obj1_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY "nir-link"
    ADD CONSTRAINT "nir-object_nir-link_obj1_fk" FOREIGN KEY (obj1) REFERENCES "nir-object"(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- TOC entry 2004 (class 2606 OID 19379)
-- Name: nir-object_nir-link_obj2_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY "nir-link"
    ADD CONSTRAINT "nir-object_nir-link_obj2_fk" FOREIGN KEY (obj2) REFERENCES "nir-object"(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- TOC entry 2126 (class 0 OID 0)
-- Dependencies: 7
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2017-12-03 23:51:30 MSK

--
-- PostgreSQL database dump complete
--

