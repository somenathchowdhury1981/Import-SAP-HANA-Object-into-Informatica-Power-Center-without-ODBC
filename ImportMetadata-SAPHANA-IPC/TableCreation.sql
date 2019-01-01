-- *******************************************************************************
-- Script Name : TableCreation.sql                                               *
-- Author      : Somenath Chowdhury                                              *
-- Created On  : 22-December-2018                                                *
-- Description : This script is used to creation database tables, which will be  *
--               used to generate importable XML files Informatica Power Center  *
--               (v10.2) compatible.                                             *
-- *******************************************************************************
-- ===============================================================================
-- Table Creation Script for IPC_DATATYPE_MAPPING
-- ===============================================================================
CREATE COLUMN TABLE "IPC_DATATYPE_MAPPING" 
                   ("DATA_TYPE_SEQ"         BIGINT PRIMARY KEY,
					"CATEGORY_OF_DATA_TYPE" NVARCHAR(50),
					"SAPHANA_DATATYPE"      NVARCHAR(50),
					"SAPHANA_PRECISION"     BIGINT,
					"SAPHANA_SCALE"         BIGINT,
					"ORACLE_DATATYPE"       NVARCHAR(50),
					"ORACLE_PRECISION"      BIGINT,
					"ORACLE_SCALE"          BIGINT,
					"IPC_10.2_DATATYPE"     NVARCHAR(50),
					"IPC_10.2_PRECISION"    BIGINT,
					"IPC_10.2_SCALE"        BIGINT);
--
-- ===============================================================================
-- Table Creation Script for XML_CONTENTS
-- ===============================================================================
CREATE COLUMN TABLE "XML_CONTENTS" 
                   ("XML_CONTENT_ID"   BIGINT PRIMARY KEY,
	                "XML_INDENTATION"  BIGINT ,
	                "XML_CONTENT_NAME" NVARCHAR(1000),
	                "XML_IMPORT_TYPE"  NVARCHAR(100)); 
--
-- ===============================================================================					
-- Table Creation Script for XML_CONTENT_VARIABLE_IPC					
-- ===============================================================================					
CREATE COLUMN TABLE "XML_CONTENT_VARIABLE_IPC" 
                   ("XML_CONTENT_VARIABLE_SEQ"   BIGINT PRIMARY KEY,
	                "XML_CONTENT_ID"             BIGINT,
	                "XML_CONTENT_VARIABLE"       NVARCHAR(1000),
	                "XML_CONTENT_VARIABLE_VALUE" NVARCHAR(1000));
--
-- ===============================================================================					
-- Table Creation Script for XML_EXPORT_FOR_IPC					
-- ===============================================================================
CREATE COLUMN TABLE "XML_EXPORT_FOR_IPC" 
                   ("XML_GENERATION_ID"   BIGINT PRIMARY KEY,
					"XML_GENERATION_USER" NVARCHAR(50),
					"XML_STRING"          NCLOB MEMORY THRESHOLD 1000,
					"XML_GENERATION_DATE" NVARCHAR(50),
					"XML_GENERATION_TYPE" NVARCHAR(50));
--				