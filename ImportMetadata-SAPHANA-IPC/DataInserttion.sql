-- ************************************************************************************************************************
-- Script Name : DataInsertion.sql                                                                                        *
-- Author      : Somenath Chowdhury                                                                                       *
-- Created On  : 22-December-2018                                                                                         *
-- Description : This script is used to insert data into input database tables, which will be                             *
--               used to generate importable XML files Informatica Power Center                                           *
--               (v10.2) compatible.                                                                                      *
-- ************************************************************************************************************************
-- ========================================================================================================================
-- Insert Into IPC_DATATYPE_MAPPING
-- ========================================================================================================================
insert into IPC_DATATYPE_MAPPING values(1,'NumericType','TINYINT',NULL,NULL,NULL,NULL,NULL,'TINYINT',3,0);
insert into IPC_DATATYPE_MAPPING values(2,'NumericType','SMALLINT',NULL,NULL,NULL,NULL,NULL,'SMALLINT',5,0);
insert into IPC_DATATYPE_MAPPING values(3,'NumericType','INTEGER',NULL,NULL,NULL,NULL,NULL,'INTEGER',10,0);
insert into IPC_DATATYPE_MAPPING values(4,'NumericType','BIGINT',NULL,NULL,NULL,NULL,NULL,'BIGINT',19,0);
insert into IPC_DATATYPE_MAPPING values(5,'NumericType','SMALLDECIMAL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into IPC_DATATYPE_MAPPING values(6,'NumericType','DECIMAL',NULL,NULL,NULL,NULL,NULL,'DECIMAL',NULL,NULL);
insert into IPC_DATATYPE_MAPPING values(7,'NumericType','REAL',NULL,NULL,NULL,NULL,NULL,'REAL',7,0);
insert into IPC_DATATYPE_MAPPING values(8,'NumericType','DOUBLE',NULL,NULL,NULL,NULL,NULL,'DOUBLE',15,0);
insert into IPC_DATATYPE_MAPPING values(9,'NumericType',NULL,NULL,NULL,NULL,NULL,NULL,'NUMERIC',NULL,NULL);
insert into IPC_DATATYPE_MAPPING values(10,'NumericType',NULL,NULL,NULL,NULL,NULL,NULL,'FLOAT',15,0);
insert into IPC_DATATYPE_MAPPING values(11,'Character String Types','VARCHAR',NULL,NULL,NULL,NULL,NULL,'VARCHAR',NULL,0);
insert into IPC_DATATYPE_MAPPING values(12,'Character String Types','NVARCHAR',NULL,NULL,NULL,NULL,NULL,'NVARCHAR',NULL,0);
insert into IPC_DATATYPE_MAPPING values(13,'Character String Types','ALPHANUM',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into IPC_DATATYPE_MAPPING values(14,'Character String Types','SHORTTEXT',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into IPC_DATATYPE_MAPPING values(15,'Character String Types',NULL,NULL,NULL,NULL,NULL,NULL,'CHAR',NULL,0);
insert into IPC_DATATYPE_MAPPING values(16,'Character String Types',NULL,NULL,NULL,NULL,NULL,NULL,'NCHAR',NULL,0);
insert into IPC_DATATYPE_MAPPING values(17,'Character String Types',NULL,NULL,NULL,NULL,NULL,NULL,'BIT',1,0);
insert into IPC_DATATYPE_MAPPING values(18,'Boolean Type','BOOLEAN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into IPC_DATATYPE_MAPPING values(19,'Datetime Types','DATE',NULL,NULL,NULL,NULL,NULL,'DATE',10,0);
insert into IPC_DATATYPE_MAPPING values(20,'Datetime Types','TIME',NULL,NULL,NULL,NULL,NULL,'TIME',8,0);
insert into IPC_DATATYPE_MAPPING values(21,'Datetime Types','SECONDDATE',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into IPC_DATATYPE_MAPPING values(22,'Datetime Types','TIMESTAMP',NULL,NULL,NULL,NULL,NULL,'TIMESTAMP',29,9);
insert into IPC_DATATYPE_MAPPING values(23,'Binary types','VARBINARY',NULL,NULL,NULL,NULL,NULL,'VARBINARY',NULL,0);
insert into IPC_DATATYPE_MAPPING values(24,'Binary types',NULL,NULL,NULL,NULL,NULL,NULL,'BINARY',NULL,0);
insert into IPC_DATATYPE_MAPPING values(25,'Binary types',NULL,NULL,NULL,NULL,NULL,NULL,'LONGVARBINARY',NULL,0);
insert into IPC_DATATYPE_MAPPING values(26,'Large Object types','BLOB',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into IPC_DATATYPE_MAPPING values(27,'Large Object types','CLOB',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into IPC_DATATYPE_MAPPING values(28,'Large Object types','NCLOB',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into IPC_DATATYPE_MAPPING values(29,'Large Object types','TEXT',NULL,NULL,NULL,NULL,NULL,'TEXT',NULL,0);
insert into IPC_DATATYPE_MAPPING values(30,'Large Object types',NULL,NULL,NULL,NULL,NULL,NULL,'NTEXT',NULL,0);
insert into IPC_DATATYPE_MAPPING values(31,'Multi-valued types','ARRAY',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into IPC_DATATYPE_MAPPING values(32,'Spatial types','ST_GEOMETRY',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into IPC_DATATYPE_MAPPING values(33,'Spatial types','ST_POINT',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
--
-- ========================================================================================================================
-- Insert Into XML_CONTENTS
-- ========================================================================================================================
insert into XML_CONTENTS values(1,0,'xml','SOURCE');
insert into XML_CONTENTS values(2,0,'!DOCTYPE','SOURCE');
insert into XML_CONTENTS values(3,0,'POWERMART','SOURCE');
insert into XML_CONTENTS values(4,0,'REPOSITORY','SOURCE');
insert into XML_CONTENTS values(5,0,'FOLDER','SOURCE');
insert into XML_CONTENTS values(6,1,'SOURCE','SOURCE');
insert into XML_CONTENTS values(7,2,'SOURCEFIELD','SOURCE');
insert into XML_CONTENTS values(8,0,'xml','TARGET');
insert into XML_CONTENTS values(9,0,'!DOCTYPE','TARGET');
insert into XML_CONTENTS values(10,0,'POWERMART','TARGET');
insert into XML_CONTENTS values(11,0,'REPOSITORY','TARGET');
insert into XML_CONTENTS values(12,0,'FOLDER','TARGET');
insert into XML_CONTENTS values(13,1,'TARGET','TARGET');
insert into XML_CONTENTS values(14,2,'TARGETFIELD','TARGET');
--
-- ========================================================================================================================
-- Insert Into XML_CONTENT_VARIABLE_IPC
-- ========================================================================================================================
insert into XML_CONTENT_VARIABLE_IPC values(1,1,'version','1.0');
insert into XML_CONTENT_VARIABLE_IPC values(2,1,'encoding','UTF-8');
insert into XML_CONTENT_VARIABLE_IPC values(3,2,'POWERMART SYSTEM','powrmart.dtd');
insert into XML_CONTENT_VARIABLE_IPC values(4,3,'CREATION_DATE','MM/DD/YYYY HH24:MI:SS');
insert into XML_CONTENT_VARIABLE_IPC values(5,3,'REPOSITORY_VERSION','999.99');
insert into XML_CONTENT_VARIABLE_IPC values(6,4,'NAME','dev_repository');
insert into XML_CONTENT_VARIABLE_IPC values(7,4,'VERSION','999');
insert into XML_CONTENT_VARIABLE_IPC values(8,4,'CODEPAGE','UTF-8');
insert into XML_CONTENT_VARIABLE_IPC values(9,4,'DATABASETYPE','ODBC');
insert into XML_CONTENT_VARIABLE_IPC values(10,5,'NAME','XXXXX_99_XXXXX_99');
insert into XML_CONTENT_VARIABLE_IPC values(11,5,'GROUP',NULL);
insert into XML_CONTENT_VARIABLE_IPC values(12,5,'OWNER','Administrator');
insert into XML_CONTENT_VARIABLE_IPC values(13,5,'SHARED','NOTSHARED');
insert into XML_CONTENT_VARIABLE_IPC values(14,5,'DESCRIPTION',NULL);
insert into XML_CONTENT_VARIABLE_IPC values(15,5,'PERMISSIONS','rwx------');
insert into XML_CONTENT_VARIABLE_IPC values(16,5,'UUID',NULL);
insert into XML_CONTENT_VARIABLE_IPC values(17,6,'BUSINESSNAME',NULL);
insert into XML_CONTENT_VARIABLE_IPC values(18,6,'DATABASETYPE','ODBC');
insert into XML_CONTENT_VARIABLE_IPC values(19,6,'DBDNAME','ODBC');
insert into XML_CONTENT_VARIABLE_IPC values(20,6,'DESCRIPTION',NULL);
insert into XML_CONTENT_VARIABLE_IPC values(21,6,'NAME',NULL);
insert into XML_CONTENT_VARIABLE_IPC values(22,6,'OBJECTVERSION','1');
insert into XML_CONTENT_VARIABLE_IPC values(23,6,'OWNERNAME',NULL);
insert into XML_CONTENT_VARIABLE_IPC values(24,6,'VERSIONNUMBER','1');
insert into XML_CONTENT_VARIABLE_IPC values(25,7,'BUSINESSNAME',NULL);
insert into XML_CONTENT_VARIABLE_IPC values(26,7,'DATATYPE',NULL);
insert into XML_CONTENT_VARIABLE_IPC values(27,7,'DESCRIPTION',NULL);
insert into XML_CONTENT_VARIABLE_IPC values(28,7,'FIELDNUMBER',NULL);
insert into XML_CONTENT_VARIABLE_IPC values(29,7,'FIELDPROPERTY','0');
insert into XML_CONTENT_VARIABLE_IPC values(30,7,'FIELDTYPE','ELEMITEM');
insert into XML_CONTENT_VARIABLE_IPC values(31,7,'HIDDEN','NO');
insert into XML_CONTENT_VARIABLE_IPC values(32,7,'KEYTYPE','NOT A KEY');
insert into XML_CONTENT_VARIABLE_IPC values(33,7,'LENGTH','0');
insert into XML_CONTENT_VARIABLE_IPC values(34,7,'LEVEL','0');
insert into XML_CONTENT_VARIABLE_IPC values(35,7,'NAME',NULL);
insert into XML_CONTENT_VARIABLE_IPC values(36,7,'NULLABLE','NULL');
insert into XML_CONTENT_VARIABLE_IPC values(37,7,'OCCURS','0');
insert into XML_CONTENT_VARIABLE_IPC values(38,7,'OFFSET','0');
insert into XML_CONTENT_VARIABLE_IPC values(39,7,'PHYSICALLENGTH',NULL);
insert into XML_CONTENT_VARIABLE_IPC values(40,7,'PHYSICALOFFSET','0');
insert into XML_CONTENT_VARIABLE_IPC values(41,7,'PICTURETEXT',NULL);
insert into XML_CONTENT_VARIABLE_IPC values(42,7,'PRECISION',NULL);
insert into XML_CONTENT_VARIABLE_IPC values(43,7,'SCALE',NULL);
insert into XML_CONTENT_VARIABLE_IPC values(44,7,'USAGE_FLAGS',NULL);
insert into XML_CONTENT_VARIABLE_IPC values(45,8,'version','1.0');
insert into XML_CONTENT_VARIABLE_IPC values(46,8,'encoding','UTF-8');
insert into XML_CONTENT_VARIABLE_IPC values(47,9,'POWERMART SYSTEM','powrmart.dtd');
insert into XML_CONTENT_VARIABLE_IPC values(48,10,'CREATION_DATE','MM/DD/YYYY HH24:MI:SS');
insert into XML_CONTENT_VARIABLE_IPC values(49,10,'REPOSITORY_VERSION','999.99');
insert into XML_CONTENT_VARIABLE_IPC values(50,11,'NAME','dev_repository');
insert into XML_CONTENT_VARIABLE_IPC values(51,11,'VERSION','999');
insert into XML_CONTENT_VARIABLE_IPC values(52,11,'CODEPAGE','UTF-8');
insert into XML_CONTENT_VARIABLE_IPC values(53,11,'DATABASETYPE','ODBC');
insert into XML_CONTENT_VARIABLE_IPC values(54,12,'NAME','XXXXX_00_XXXXX_00');
insert into XML_CONTENT_VARIABLE_IPC values(55,12,'GROUP',NULL);
insert into XML_CONTENT_VARIABLE_IPC values(56,12,'OWNER','Administrator');
insert into XML_CONTENT_VARIABLE_IPC values(57,12,'SHARED','NOTSHARED');
insert into XML_CONTENT_VARIABLE_IPC values(58,12,'DESCRIPTION',NULL);
insert into XML_CONTENT_VARIABLE_IPC values(59,12,'PERMISSIONS','rwx------');
insert into XML_CONTENT_VARIABLE_IPC values(60,12,'UUID',NULL);
insert into XML_CONTENT_VARIABLE_IPC values(61,13,'BUSINESSNAME',NULL);
insert into XML_CONTENT_VARIABLE_IPC values(62,13,'CONSTRAINT',NULL);
insert into XML_CONTENT_VARIABLE_IPC values(63,13,'DATABASETYPE','ODBC');
insert into XML_CONTENT_VARIABLE_IPC values(64,13,'DESCRIPTION',NULL);
insert into XML_CONTENT_VARIABLE_IPC values(65,13,'NAME',NULL);
insert into XML_CONTENT_VARIABLE_IPC values(66,13,'OBJECTVERSION','1');
insert into XML_CONTENT_VARIABLE_IPC values(67,13,'TABLEOPTIONS',NULL);
insert into XML_CONTENT_VARIABLE_IPC values(68,13,'VERSIONNUMBER','1');
insert into XML_CONTENT_VARIABLE_IPC values(69,14,'BUSINESSNAME',NULL);
insert into XML_CONTENT_VARIABLE_IPC values(70,14,'DATATYPE',NULL);
insert into XML_CONTENT_VARIABLE_IPC values(71,14,'DESCRIPTION',NULL);
insert into XML_CONTENT_VARIABLE_IPC values(72,14,'FIELDNUMBER',NULL);
insert into XML_CONTENT_VARIABLE_IPC values(73,14,'KEYTYPE','NOT A KEY');
insert into XML_CONTENT_VARIABLE_IPC values(74,14,'NAME',NULL);
insert into XML_CONTENT_VARIABLE_IPC values(75,14,'NULLABLE','NULL');
insert into XML_CONTENT_VARIABLE_IPC values(76,14,'PICTURETEXT',NULL);
insert into XML_CONTENT_VARIABLE_IPC values(77,14,'PRECISION',NULL);
insert into XML_CONTENT_VARIABLE_IPC values(78,14,'SCALE',NULL);
--
COMMIT;
--