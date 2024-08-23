
--This Stored Procedure will Apply tags to "COLUMN LEVEL"---
CREATE OR REPLACE PROCEDURE  DATA_GOVERNANCE.TAGS.APPLY_COLUMN_TAGS("OBJECT_DATABASE" VARCHAR(16777216), "OBJECT_SCHEMA" VARCHAR(16777216), "OBJECT_NAME" VARCHAR(16777216), "OBJECT_COLUMN" VARCHAR(16777216), "TAG_NAME" VARCHAR(16777216), "TAG_VALUE" VARCHAR(16777216))

RETURNS VARCHAR(16777216)

LANGUAGE SQL

EXECUTE AS CALLER

AS DECLARE

   apply_column_tags VARCHAR;

   apply_column_tags_stage VARCHAR;

BEGIN

   apply_column_tags:= 'alter table if exists ' || :object_database ||'.' || :object_schema || '.' || :object_name || 
   ' modify column ' || :object_column || ' set tag '|| 'DATA_GOVERNANCE.tags.'  || :tag_name || ' = ''' || :tag_value || ''';';

   BEGIN

       execute immediate :apply_column_tags;

   EXCEPTION

       WHEN STATEMENT_ERROR THEN

           SYSTEM$LOG('info', 'Information-level message');

           SYSTEM$LOG('error', 'Error message');

            RETURN 'DB OR TABLE DOES NOT EXIST';

   END;


RETURN apply_column_tags ;

END;


----------------




