
--This Stored Procedure will Apply tags to "TABLE LEVEL"---
CREATE OR REPLACE PROCEDURE DATA_GOVERNANCE.TAGS.APPLY_TABLE_TAGS("OBJECT_DATABASE" VARCHAR(16777216), "OBJECT_SCHEMA" VARCHAR(16777216), "OBJECT_NAME" VARCHAR(16777216), "TAG_NAME" VARCHAR(16777216), "TAG_VALUE" VARCHAR(16777216))

RETURNS VARCHAR(16777216)

LANGUAGE SQL

EXECUTE AS CALLER

AS 
DECLARE

   apply_table_tags VARCHAR;

   apply_stage_table_tags VARCHAR;

BEGIN

 apply_table_tags:= 'alter table if exists ' || :object_database || '.' || :object_schema || '.' || :object_name || 
' set tag ' || 'DATA_GOVERNANCE.tags.' || :tag_name || ' = ''' || :tag_value || ''';';

   BEGIN

       execute immediate :apply_table_tags;

   EXCEPTION

    WHEN STATEMENT_ERROR THEN

       RETURN 'DB OR TABLE DOES NOT EXIST';

   END;

RETURN apply_table_tags ;

END;