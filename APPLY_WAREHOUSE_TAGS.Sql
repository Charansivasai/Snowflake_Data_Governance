

--This Stored Procedure will Apply tags to "WAREHOUSE LEVEL"---

CREATE OR REPLACE PROCEDURE DATA_GOVERNANCE.TAGS.APPLY_WAREHOUSE_TAGS( "OBJECT_NAME" VARCHAR(16777216), "TAG_NAME" VARCHAR(16777216), "TAG_VALUE" VARCHAR(16777216))

RETURNS VARCHAR(16777216)

LANGUAGE SQL

EXECUTE AS CALLER

AS DECLARE

   apply_warehouse_tags VARCHAR;

BEGIN

apply_warehouse_tags:= 'alter warehouse if exists ' || :object_name || ' set tag ' || 
'DATA_GOVERNANCE.tags.' || :tag_name || '= ''' || :tag_value || ''';';

   BEGIN

       execute immediate :apply_warehouse_tags;

   END;

RETURN apply_warehouse_tags ;

END;