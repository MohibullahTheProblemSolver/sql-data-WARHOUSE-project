/*
===========================================================================
CREATE DATABASE AND SCHEMA
===========================================================================

===========================================================================
Script Purpose:
This script creates  a new DataBase named 'DataWarHouse'
IF there any similiar named DataBases available 
then this script will DROP the database and recreate a new DataBase.

ADDITIONALLY, This Script has three Schemas : 'bronze', 'silver', 'gold' 
===========================================================================

===========================================================================
Warning:
This Script will permanently delete all DataBases named 'DataWarHouse' if it exist.
So, before Running this script ensure you have proper backups

===========================================================================
*/
-- DROP AND RECREATE 'DATAWARHOUSE' DATABASE
USE master;
GO
IF EXISTS (SELECT 1 FROM sys.databases WHERE name ='DataWarHouse')

BEGIN
	ALTER DATABASE DataWarHouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarHouse;

END;

GO
-- CREATE 'DataWarHouse' DataBase
CREATE DATABASE DataWarHouse

GO

USE DataWarHouse;

GO

CREATE SCHEMA bronze;

GO

CREATE SCHEMA silver;

GO

CREATE SCHEMA gold;

GO

