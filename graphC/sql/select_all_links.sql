CREATE OR REPLACE FUNCTION select_all_links() RETURNS table (obj text, attr text, type text, attr_value text) AS
$BODY$
DECLARE
  link_record RECORD;
BEGIN
  FOR link_record IN SELECT  object_table.name AS object_name,
          object_table.name AS attr_name,
          link_table.type AS data_type,
          link_table.string_value AS value
  FROM "nir-link" link_table
  JOIN "nir-object" object_table ON link_table.obj1 = object_table.id LOOP
  obj := link_record.object_name;
  attr := link_record.attr_name;
  type := link_record.data_type;
  attr_value := link_record.value;
  RETURN NEXT;
  END LOOP;
END;
$BODY$
LANGUAGE plpgsql;