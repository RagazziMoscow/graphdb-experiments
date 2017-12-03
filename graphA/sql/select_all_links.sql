CREATE OR REPLACE FUNCTION select_all_links() RETURNS table (obj text, attr text, type text, attr_value text) AS
$BODY$
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
$BODY$
LANGUAGE plpgsql;