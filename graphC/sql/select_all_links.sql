CREATE OR REPLACE FUNCTION public.select_all_links()
  RETURNS TABLE(obj text, attr text, type text, attr_value text) AS
$BODY$
DECLARE
  link_record RECORD;
BEGIN
  FOR link_record IN SELECT  object_table1.name AS object_name,
          object_table2.name AS attr_name,
          link_table.type AS data_type,
          link_table.string_value AS value
  FROM "nir-link" link_table
  JOIN "nir-object" object_table1 ON link_table.obj1 = object_table1.id
  JOIN "nir-object" object_table2 ON link_table.obj2 = object_table2.id
  LOOP
  obj := link_record.object_name;
  attr := link_record.attr_name;
  type := link_record.data_type;
  attr_value := link_record.value;
  RETURN NEXT;
  END LOOP;
END;
$BODY$
  LANGUAGE plpgsql
$BODY$
LANGUAGE plpgsql;