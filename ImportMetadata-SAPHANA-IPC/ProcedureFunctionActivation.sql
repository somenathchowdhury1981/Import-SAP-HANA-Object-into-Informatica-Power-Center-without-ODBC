-- ************************************************************************************************************************
-- Script Name : ProcedureFunctionActivation.sql                                                                          *
-- Author      : Somenath Chowdhury                                                                                       *
-- Created On  : 22-December-2018                                                                                         *
-- Description : This script is used to activate SAP HANA database procedure and functions. These database objects are    *
--               used to generate importable XML files Informatica Power Center (v10.2) compatible.                       *
-- ************************************************************************************************************************
-- ========================================================================================================================
-- Procedure  : TABLE_XML_GENERATOR                                                                                       *
-- Description: This is a main procedure which will be used to invoke other child procedure based on import type. If the  *
--              import type is SOURCE then SRC_TABLE_XML_GENERATOR procedure will be invoked otherwise for TARGET import  *
--              type TGT_TABLE_XML_GENERATOR procedure will be triggered.                                                 *
-- ========================================================================================================================
PROCEDURE TABLE_XML_GENERATOR (IN p_folder_name    NVARCHAR(100)
                              ,IN p_import_type    NVARCHAR(50)
							  ,IN p_objcet_schema  NVARCHAR(100)
                              ,IN p_object_name    NVARCHAR(200) ) 
	LANGUAGE SQLSCRIPT
	SQL SECURITY DEFINER 
	DEFAULT SCHEMA <schema name> 
	AS
BEGIN
/***************************** 
	Write your procedure logic 
 *****************************/
	DECLARE v_user              VARCHAR(50) := '';
	--
	
	-- Get User ID
   	SELECT SESSION_USER into v_user FROM DUMMY;
   
  	-- Clear Previous Content from OUTPUT table
    DELETE
      FROM XML_EXPORT_FOR_IPC
     WHERE XML_GENERATION_USER = v_user;
    --
    
    IF :p_import_type = 'SOURCE' THEN
    	CALL SRC_TABLE_XML_GENERATOR(:p_folder_name,:p_objcet_schema,:p_object_name,v_user); 
    ELSEIF :p_import_type = 'TARGET' THEN
    	CALL TGT_TABLE_XML_GENERATOR(:p_folder_name,:p_objcet_schema,:p_object_name,v_user); 
    END IF;
    --
END;
--
-- ========================================================================================================================
-- Procedure  : SRC_TABLE_XML_GENERATOR                                                                                   *
-- Description: This procedure is invoked from the main procedure when import type is SOURCE. It extracts each of the XML * 
--              tags from input tables and invokes XML_VARIABLE_VALUE function for XML attributes                         *                       *
-- ========================================================================================================================
PROCEDURE SRC_TABLE_XML_GENERATOR (IN p_folder_name    NVARCHAR(100)
								  ,IN p_objcet_schema  NVARCHAR(100)
                                  ,IN p_object_name    NVARCHAR(200)
                                  ,IN p_user           NVARCHAR(50)) 
	LANGUAGE SQLSCRIPT
	SQL SECURITY DEFINER 
	DEFAULT SCHEMA <schema name> 
	AS
BEGIN
/***************************** 
	Write your procedure logic 
 *****************************/
  DECLARE v_lines             VARCHAR(60000) := '';
  DECLARE v_new_line          VARCHAR(20000) := '';
  DECLARE v_var_val           VARCHAR(10000) := '';
  DECLARE v_xml_generation_id BIGINT := 0;
  
  DECLARE CURSOR c_xml_content 
      FOR 
   SELECT XC.XML_CONTENT_ID
         ,XC.XML_INDENTATION
         ,XC.XML_CONTENT_NAME
     FROM XML_CONTENTS AS XC
    WHERE XC.XML_IMPORT_TYPE='SOURCE'
    ORDER BY XC.XML_CONTENT_ID ASC; 
  --
    
  FOR l_xml_content AS c_xml_content
   DO
	   v_var_val := XML_VARIABLE_VALUE(l_xml_content.XML_CONTENT_ID
	                                  ,:p_folder_name
	                                  ,:p_objcet_schema
	                                  ,:p_object_name);
	   
	   IF l_xml_content.XML_CONTENT_ID != 7 THEN
		   IF l_xml_content.XML_CONTENT_NAME = 'xml' THEN
		   		v_new_line := '<?'||l_xml_content.XML_CONTENT_NAME||' ';
		   		v_new_line := v_new_line||v_var_val||'?>';
		   ELSEIF l_xml_content.XML_CONTENT_NAME = '!DOCTYPE' THEN
		   		v_new_line := '<'||l_xml_content.XML_CONTENT_NAME||' ';
		   		v_new_line := v_new_line||v_var_val||'>';
		   ELSE
		   		v_new_line := '<'||l_xml_content.XML_CONTENT_NAME||' ';
		   		v_new_line := v_new_line||v_var_val||'>';
		   END IF;
		   --
		   
		   IF l_xml_content.XML_INDENTATION = 1 THEN
		   		v_new_line := CHAR(9)||v_new_line||CHAR(13)||CHAR(10);
		   ELSEIF l_xml_content.XML_INDENTATION = 2 THEN
		   		v_new_line := CHAR(9)||CHAR(9)||v_new_line||CHAR(13)||CHAR(10);
		   ELSE
		   		v_new_line := v_new_line||CHAR(13)||CHAR(10);
		   END IF;
		   --
	   
	   	   
	   ELSE
	   	   v_new_line := v_var_val;
	   	   --
	   END IF;
	   --
	   
	   v_lines := v_lines||v_new_line;
	   --
	   
  END FOR;
  --
  v_lines := v_lines||CHAR(9)||'</SOURCE>'||CHAR(13)||CHAR(10);
  v_lines := v_lines||'</FOLDER>'||CHAR(13)||CHAR(10);
  v_lines := v_lines||'</REPOSITORY>'||CHAR(13)||CHAR(10);
  v_lines := v_lines||'</POWERMART>'||CHAR(13)||CHAR(10);
  --
  
  SELECT IFNULL(MAX(XML_GENERATION_ID),0)+1
    INTO v_xml_generation_id
    FROM XML_EXPORT_FOR_IPC;
  --
  
  INSERT 
    INTO XML_EXPORT_FOR_IPC
         (XML_GENERATION_ID
         ,XML_GENERATION_USER
         ,XML_GENERATION_TYPE
         ,XML_STRING
         ,XML_GENERATION_DATE)
  VALUES (v_xml_generation_id
         ,:p_user
         ,'SOURCE'
         ,v_lines
         ,TO_CHAR(CURRENT_DATE,'YYYY-MM-DD'));
  --
  COMMIT;
  
  --SELECT v_lines FROM DUMMY;
  
END;
--
-- ========================================================================================================================
-- Procedure  : TGT_TABLE_XML_GENERATOR                                                                                   *
-- Description: This procedure is invoked from the main procedure when import type is TARGET. It extracts each of the XML * 
--              tags from input tables and invokes XML_VARIABLE_VALUE function for XML attributes                         *                       *
-- ========================================================================================================================
PROCEDURE TGT_TABLE_XML_GENERATOR (IN p_folder_name    NVARCHAR(100)
								  ,IN p_objcet_schema  NVARCHAR(100)
                                  ,IN p_object_name    NVARCHAR(200)
                                  ,IN p_user           NVARCHAR(50)) 
	LANGUAGE SQLSCRIPT
	SQL SECURITY DEFINER 
	DEFAULT SCHEMA <schema name> 
	AS
BEGIN
/***************************** 
	Write your procedure logic 
 *****************************/
  DECLARE v_lines             VARCHAR(60000) := '';
  DECLARE v_new_line          VARCHAR(20000) := '';
  DECLARE v_var_val           VARCHAR(10000) := '';  
  DECLARE v_xml_generation_id BIGINT := 0;
  
  DECLARE CURSOR c_xml_content 
      FOR 
   SELECT XC.XML_CONTENT_ID
         ,XC.XML_INDENTATION
         ,XC.XML_CONTENT_NAME
     FROM XML_CONTENTS AS XC
    WHERE XC.XML_IMPORT_TYPE='TARGET'
    ORDER BY XC.XML_CONTENT_ID ASC; 
  --
    
  FOR l_xml_content AS c_xml_content
   DO
	   v_var_val := XML_VARIABLE_VALUE(l_xml_content.XML_CONTENT_ID
	                                  ,:p_folder_name
	                                  ,:p_objcet_schema
	                                  ,:p_object_name);
	   
	   IF l_xml_content.XML_CONTENT_ID != 14 THEN
		   IF l_xml_content.XML_CONTENT_NAME = 'xml' THEN
		   		v_new_line := '<?'||l_xml_content.XML_CONTENT_NAME||' ';
		   		v_new_line := v_new_line||v_var_val||'?>';
		   ELSEIF l_xml_content.XML_CONTENT_NAME = '!DOCTYPE' THEN
		   		v_new_line := '<'||l_xml_content.XML_CONTENT_NAME||' ';
		   		v_new_line := v_new_line||v_var_val||'>';
		   ELSE
		   		v_new_line := '<'||l_xml_content.XML_CONTENT_NAME||' ';
		   		v_new_line := v_new_line||v_var_val||'>';
		   END IF;
		   --
		   
		   IF l_xml_content.XML_INDENTATION = 1 THEN
		   		v_new_line := CHAR(9)||v_new_line||CHAR(13)||CHAR(10);
		   ELSEIF l_xml_content.XML_INDENTATION = 2 THEN
		   		v_new_line := CHAR(9)||CHAR(9)||v_new_line||CHAR(13)||CHAR(10);
		   ELSE
		   		v_new_line := v_new_line||CHAR(13)||CHAR(10);
		   END IF;
		   --
	   
	   	   
	   ELSE
	   	   v_new_line := v_var_val;
	   	   --
	   END IF;
	   --
	   
	   v_lines := v_lines||v_new_line;
	   --
	   
  END FOR;
  --
  v_lines := v_lines||CHAR(9)||'</TARGET>'||CHAR(13)||CHAR(10);
  v_lines := v_lines||'</FOLDER>'||CHAR(13)||CHAR(10);
  v_lines := v_lines||'</REPOSITORY>'||CHAR(13)||CHAR(10);
  v_lines := v_lines||'</POWERMART>'||CHAR(13)||CHAR(10);
  --
  
  SELECT IFNULL(MAX(XML_GENERATION_ID),0)+1
    INTO v_xml_generation_id
    FROM XML_EXPORT_FOR_IPC;
  --
  
  INSERT 
    INTO XML_EXPORT_FOR_IPC
         (XML_GENERATION_ID
         ,XML_GENERATION_USER
         ,XML_GENERATION_TYPE
         ,XML_STRING
         ,XML_GENERATION_DATE)
  VALUES (v_xml_generation_id
         ,:p_user
         ,'TARGET'
         ,v_lines
         ,TO_CHAR(CURRENT_DATE,'YYYY-MM-DD'));
  --
  COMMIT;
  
  --SELECT v_lines FROM DUMMY;
  
END;
-- ========================================================================================================================
-- Funtion:     XML_VARIABLE_VALUE                                                                                        *
-- Description: This function is invoked from the SRC_TABLE_XML_GENERATOR and TGT_TABLE_XML_GENERATOR procedure for each  *
--              XML tags. It generates attributes information in each line in between the XML tags.                       *
-- ========================================================================================================================
FUNCTION XML_VARIABLE_VALUE (IN p_xml_content_id BIGINT
                            ,IN p_folder_name    VARCHAR(100)
                            ,IN p_objcet_schema  VARCHAR(100)
                            ,IN p_object_name    VARCHAR(200)) 
	RETURNS RESULT NVARCHAR(20000)
	LANGUAGE SQLSCRIPT
	SQL SECURITY INVOKER AS
BEGIN
/***************************** 
	Write your function logic
 *****************************/
	DECLARE v_var_val      VARCHAR(30000) := '';
	DECLARE v_var_new_val  VARCHAR(10000) := '';
	DECLARE v_content_name VARCHAR(100)   := '';
	DECLARE v_precision    BIGINT := 0;
	DECLARE v_scale        BIGINT := 0;
	DECLARE v_object_name  VARCHAR(50) := '';
	--
	--
	DECLARE CURSOR c_xml_variable(v_xml_content_id	BIGINT)
        FOR 
     SELECT XC.XML_CONTENT_ID
	       ,XC.XML_INDENTATION
	       ,XC.XML_CONTENT_NAME
	       ,XCV.XML_CONTENT_VARIABLE
	       ,XCV.XML_CONTENT_VARIABLE_VALUE
	   FROM XML_CONTENTS AS XC
	       ,XML_CONTENT_VARIABLE_IPC AS XCV
	  WHERE XCV.XML_CONTENT_ID = XC.XML_CONTENT_ID
	    AND XC.XML_CONTENT_ID = :v_xml_content_id;
	--
	
	DECLARE CURSOR c_object_details(v_objcet_schema		VARCHAR(100)
	                               ,v_object_name		VARCHAR(200))
	    FOR
	 SELECT SCHEMA_NAME
	       ,TABLE_NAME
	       ,COLUMN_NAME
	       ,POSITION
	       ,DATA_TYPE_NAME
	       ,OFFSET
	       ,LENGTH
	       ,SCALE
	       ,IS_NULLABLE
	       ,IFNULL(IS_PRIMARY_KEY,'FALSE') AS IS_PRIMARY_KEY
	   FROM (SELECT a.SCHEMA_NAME
			       ,a.TABLE_NAME
			       ,a.COLUMN_NAME
			       ,a.POSITION
			       ,a.DATA_TYPE_NAME
			       ,a.OFFSET
			       ,a.LENGTH
			       ,a.SCALE
			       ,a.IS_NULLABLE
			       ,b.IS_PRIMARY_KEY   
			   FROM TABLE_COLUMNS a
		 LEFT OUTER JOIN (SELECT * FROM CONSTRAINTS WHERE IS_PRIMARY_KEY != 'FALSE') AS b
		         ON (a.SCHEMA_NAME = b.SCHEMA_NAME AND 
		             a.TABLE_NAME = b.TABLE_NAME AND 
		             a.COLUMN_NAME = b.COLUMN_NAME)
			  UNION
			 SELECT VC.SCHEMA_NAME
			       ,V.VIEW_NAME
			       ,VC.COLUMN_NAME
			       ,VC.POSITION
			       ,VC.DATA_TYPE_NAME
			       ,VC.OFFSET
			       ,VC.LENGTH
			       ,VC.SCALE
			       ,VC.IS_NULLABLE 
			       ,NULL AS IS_PRIMARY_KEY  
			   FROM VIEW_COLUMNS VC,
			        VIEWS V
			  WHERE V.VIEW_OID = VC.VIEW_OID) AS V_METADATA
	  WHERE V_METADATA.SCHEMA_NAME = :v_objcet_schema
	    AND V_METADATA.TABLE_NAME = :v_object_name
	 ORDER BY POSITION ASC;
	--
	
	IF :p_xml_content_id = 7 OR :p_xml_content_id = 14 THEN
		FOR l_object_details AS c_object_details(p_objcet_schema
		                                        ,p_object_name)
		 DO
			v_var_new_val := '';
			--
			
			SELECT "IPC_10.2_PRECISION"
			      ,"IPC_10.2_SCALE"
			  INTO v_precision
			      ,v_scale
			  FROM IPC_DATATYPE_MAPPING AS DTMP
			 WHERE DTMP.SAPHANA_DATATYPE = l_object_details.DATA_TYPE_NAME;				    
		    --
			
			--
			FOR l_xml_variable AS c_xml_variable(p_xml_content_id)
			 DO
				v_content_name = l_xml_variable.XML_CONTENT_NAME;
				v_var_new_val := v_var_new_val||l_xml_variable.XML_CONTENT_VARIABLE;
				--
				IF l_xml_variable.XML_CONTENT_VARIABLE = 'DATATYPE' THEN
					v_var_new_val := v_var_new_val||' ="'||l_object_details.DATA_TYPE_NAME||'" ';
				ELSEIF l_xml_variable.XML_CONTENT_VARIABLE = 'FIELDNUMBER' THEN
					v_var_new_val := v_var_new_val||' ="'||l_object_details.POSITION||'" ';
				ELSEIF l_xml_variable.XML_CONTENT_VARIABLE = 'NAME' THEN
					v_var_new_val := v_var_new_val||' ="'||l_object_details.COLUMN_NAME||'" ';
				
				ELSEIF l_xml_variable.XML_CONTENT_VARIABLE = 'KEYTYPE' THEN
					
					IF l_object_details.IS_PRIMARY_KEY='TRUE' THEN
						v_var_new_val := v_var_new_val||' ="PRIMARY KEY" ';
					ELSE
						v_var_new_val := v_var_new_val||' ="'||IFNULL(l_xml_variable.XML_CONTENT_VARIABLE_VALUE,'')||'" ';
					END IF;					
					
				ELSEIF l_xml_variable.XML_CONTENT_VARIABLE = 'NULLABLE' THEN
					
					IF l_object_details.IS_NULLABLE='FALSE' THEN
						v_var_new_val := v_var_new_val||' ="NOTNULL" ';
					ELSEIF l_object_details.IS_NULLABLE='TRUE' THEN
						v_var_new_val := v_var_new_val||' ="NULL" ';
					ELSE
						v_var_new_val := v_var_new_val||' ="'||IFNULL(l_xml_variable.XML_CONTENT_VARIABLE_VALUE,'')||'" ';
					END IF;
				
				ELSEIF l_xml_variable.XML_CONTENT_VARIABLE = 'PHYSICALLENGTH' OR
				       l_xml_variable.XML_CONTENT_VARIABLE = 'PRECISION' THEN
				    
				    IF l_object_details.DATA_TYPE_NAME = 'TIMESTAMP' THEN
				    	v_var_new_val := v_var_new_val||' ="'||v_precision||'" ';
				    ELSE
						v_var_new_val := v_var_new_val||' ="'||IFNULL(l_object_details.LENGTH,0)||'" ';
					END IF;
					--
					
				ELSEIF l_xml_variable.XML_CONTENT_VARIABLE = 'SCALE' THEN
				
					IF l_object_details.DATA_TYPE_NAME = 'TIMESTAMP' THEN
				    	v_var_new_val := v_var_new_val||' ="'||v_scale||'" ';
				    ELSE
						v_var_new_val := v_var_new_val||' ="'||IFNULL(l_object_details.SCALE,0)||'" ';
					END IF;
					--
													
				ELSE
					v_var_new_val := v_var_new_val||' ="'||IFNULL(l_xml_variable.XML_CONTENT_VARIABLE_VALUE,'')||'" ';
				END IF;
		   		--
			END FOR; 
			--
			v_var_val := v_var_val||CHAR(9)||CHAR(9)||'<'||v_content_name||' '||TRIM(v_var_new_val)||'/>'||CHAR(13)||CHAR(10);
		END FOR;
		--
	ELSE
		FOR l_xml_variable AS c_xml_variable(p_xml_content_id)
		 DO
		   v_var_val := v_var_val||l_xml_variable.XML_CONTENT_VARIABLE;
		   --
		   IF (:p_xml_content_id = 3 OR :p_xml_content_id = 10) AND l_xml_variable.XML_CONTENT_VARIABLE = 'CREATION_DATE' THEN
		   		v_var_val := v_var_val||'="'||TO_CHAR(CURRENT_DATE,l_xml_variable.XML_CONTENT_VARIABLE_VALUE)||'" '; 
		   ELSEIF (:p_xml_content_id = 5 OR :p_xml_content_id = 12) AND l_xml_variable.XML_CONTENT_VARIABLE = 'NAME' THEN
		   		v_var_val := v_var_val||'="'||:p_folder_name||'" ';
		   ELSEIF (:p_xml_content_id = 6 OR :p_xml_content_id = 13) AND l_xml_variable.XML_CONTENT_VARIABLE = 'NAME' THEN
		   		
		   		IF LENGTH(:p_object_name) > 30 THEN
		   			v_object_name := LEFT(SUBSTR_AFTER (:p_object_name,'::'),27)||'_'||TO_CHAR(CAST((RAND()*66)+1 AS BIGINT));
		   		ELSE
		   			v_object_name := :p_object_name;
		   		END IF;
		   		--
		   		v_var_val := v_var_val||'="'||v_object_name||'" ';
		   ELSEIF :p_xml_content_id = 2 OR :p_xml_content_id = 9 THEN
		   		v_var_val := v_var_val||' "'||IFNULL(l_xml_variable.XML_CONTENT_VARIABLE_VALUE,'')||'" ';
		   ELSE
		   		v_var_val := v_var_val||'="'||IFNULL(l_xml_variable.XML_CONTENT_VARIABLE_VALUE,'')||'" ';
		   END IF;
		   --
		END FOR;
	END IF;
	--
	
	RESULT := TRIM(v_var_val);
END;
--