CREATE OR REPLACE FUNCTION select_all_links() RETURNS table (obj text, attr text, type text, attr_value text) AS
$BODY$
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
$BODY$
LANGUAGE plpgsql;