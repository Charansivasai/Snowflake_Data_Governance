
--This Stored Procedure will Apply tags to "DATABASE LEVEL"---

CREATE OR REPLACE PROCEDURE DATA_GOVERNANCE.TAGS.APPLY_DATABASE_TAGS( "OBJECT_DATABASE" VARCHAR(16777216), "TAG_NAME" VARCHAR(16777216), "TAG_VALUE" VARCHAR(16777216))

RETURNS VARCHAR(16777216)

LANGUAGE SQL

EXECUTE AS CALLER

AS DECLARE

   apply_database_tags VARCHAR;

BEGIN

   apply_database_tags:= 'alter database if exists ' || :object_database || ' set tag ' || 
   'DATA_GOVERNANCE.tags.' || :tag_name || '= ''' || :tag_value || ''';';

   BEGIN

       execute immediate :apply_database_tags;

   END;

RETURN apply_database_tags ;

END;