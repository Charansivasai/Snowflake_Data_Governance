
----***Main**---
CREATE OR REPLACE PROCEDURE DATA_GOVERNANCE.TAGS.CREATE_AND_APPLY_TAGS( "TAG_TABLE_NAME" VARCHAR(16777216), "DATE_PARAMETER" VARCHAR(10), "SCHEMA_NAME_FOR_RUN" VARCHAR(100))

RETURNS VARCHAR(16777216)
LANGUAGE SQL
EXECUTE AS CALLER
AS DECLARE
   table_query VARCHAR(2000);
   table_result_set resultset;
   counter INTEGER DEFAULT 0;
   total_row_count INTEGER DEFAULT 0;

BEGIN

if (:SCHEMA_NAME_FOR_RUN > '""') then

    table_query := 'SELECT * FROM ' || :TAG_TABLE_NAME || 
                    ' WHERE OBJECT_SCHEMA = ''' || :SCHEMA_NAME_FOR_RUN || '''' ||
                    ' AND (ROW_CREATE_DATETIME >= TO_TIMESTAMP_NTZ(''' || :DATE_PARAMETER || ''')' ||                
                    ' ORDER BY OBJECT_DOMAIN';
else

    table_query := 'SELECT * FROM ' || :TAG_TABLE_NAME || 
                    ' WHERE ROW_CREATE_DATETIME >= TO_TIMESTAMP_NTZ(''' || :DATE_PARAMETER || ''')'  ||
                    ' ORDER BY OBJECT_DOMAIN';

end if;

BEGIN

   table_result_set := (execute immediate :table_query);

declare

   cur_row cursor for table_result_set;

   object_database VARCHAR (2000);

   object_schema VARCHAR (2000);

   object_name VARCHAR (2000);

   object_column VARCHAR (2000);

   tag_name VARCHAR (2000);

   tag_value VARCHAR (2000);
 
   BEGIN

   for rec in cur_row loop

         object_database:=coalesce(rec."OBJECT_DATABASE", '') ;

         object_schema:=coalesce(rec."OBJECT_SCHEMA", '') ;

         object_name:=coalesce(rec."OBJECT_NAME", '') ;

         object_column:=coalesce(rec."OBJECT_COLUMN", '') ;

         tag_name:=coalesce(rec."TAG_NAME", '') ;

         tag_value:=coalesce(rec."TAG_VALUE", '') ;

          BEGIN

           if (lower(rec."OBJECT_DOMAIN") = 'column') then
		   
			---Adding tags To "COLUMN LEVEL":
				call DATA_GOVERNANCE.TAGS.APPLY_COLUMN_TAGS( :object_database, :object_schema, :object_name, :object_column, :tag_name, :tag_value);

           elseif (lower(rec."OBJECT_DOMAIN") = 'table') then
			--Adding tags To "TABLE LEVEL":
               call DATA_GOVERNANCE.TAGS.APPLY_TABLE_TAGS( :object_database, :object_schema, :object_name, :tag_name, :tag_value);

           elseif (rec."OBJECT_DOMAIN" = 'schema') then
			--Adding Tags To "SCHEMA LEVEL":
               call DATA_GOVERNANCE.TAGS.APPLY_SCHEMA_TAGS( :object_database, :object_schema, :tag_name, :tag_value);

           elseif (rec."OBJECT_DOMAIN" = 'database') then
			--Adding Tags To "DATABASE LEVEL":
               call DATA_GOVERNANCE.TAGS.APPLY_DATABASE_TAGS( :object_database, :tag_name, :tag_value);

           elseif (rec."OBJECT_DOMAIN" = 'warehouse') then
			--Adding Tags To "WAREHOUSE LEVEL":
               call DATA_GOVERNANCE.TAGS.APPLY_WAREHOUSE_TAGS( :object_name, :tag_name, :tag_value);

           end if;

           END;

           counter := counter + 1;

          end loop ;

         END ;

   END;

return  'successfully applied to ' || :counter || ' objects';

END;


--CALL DATA_GOVERNANCE.TAGS.CREATE_AND_APPLY_TAGS('DEV','DATA_GOVERNANCE.TAGS.TAG_LIST','2024-08-09','L0_RAW_SCH');

 