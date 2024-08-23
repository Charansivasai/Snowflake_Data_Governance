

--This Stored Procedure will Apply tags to "SCHEMA LEVEL"---

CREATE OR REPLACE PROCEDURE DATA_GOVERNANCE.TAGS.APPLY_SCHEMA_TAGS("OBJECT_DATABASE" VARCHAR(16777216), "OBJECT_SCHEMA" VARCHAR(16777216), "TAG_NAME" VARCHAR(16777216), "TAG_VALUE" VARCHAR(16777216))

RETURNS VARCHAR(16777216)

LANGUAGE SQL

EXECUTE AS CALLER

AS DECLARE

   apply_schema_tags VARCHAR;

BEGIN

 apply_schema_tags:= 'alter schema if exists ' || :object_database || '.' || :object_schema || ' set tag ' || 'DATA_GOVERNANCE.tags.' || :tag_name ||' = ''' || :tag_value || ''';';

   BEGIN

       execute immediate :apply_schema_tags;

   END;

RETURN apply_schema_tags ;

END;