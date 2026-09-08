-- schema.sql
-- Creates demo objects for exercising tdscli / FreeTDSKit.
--
-- Azure SQL Database does not support switching databases with USE. Run
-- Sources/create-database.sql against master first, then connect sqlcmd directly
-- to the demo database:
--
--   sqlcmd -S tcp:<server>.database.windows.net,1433 -d demo -U <user> -P <password> -i Sources/schema.sql
--
-- Local SQL Server can create and switch to the demo database automatically:
--
--   sqlcmd -S <server> -U <user> -P <password> -i Sources/schema.sql
--
-- Override the database name with: -v DatabaseName="demo"

:setvar DatabaseName "demo"

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

DECLARE @databaseName SYSNAME = N'$(DatabaseName)';
DECLARE @engineEdition INT = CONVERT(INT, SERVERPROPERTY(N'EngineEdition'));
DECLARE @setupSql NVARCHAR(MAX) = N'
IF SCHEMA_ID(N''dbo'') IS NULL
    EXEC(N''CREATE SCHEMA dbo'');

DROP TABLE IF EXISTS dbo.Product;

CREATE TABLE dbo.Product (
    ProductID   INT           NOT NULL,
    ProductName NVARCHAR(100) NOT NULL,
    Quantity    INT           NOT NULL,
    CONSTRAINT PK_Product PRIMARY KEY CLUSTERED (ProductID ASC)
);

INSERT INTO dbo.Product (ProductID, ProductName, Quantity) VALUES
    (1, N''Widget'',      100),
    (2, N''Gadget'',       42),
    (3, N''Gizmo'',         7),
    (4, N''Doohickey'',    88),
    (5, N''Thingamajig'',  15);
';

IF @engineEdition = 5
BEGIN
    IF DB_NAME() <> @databaseName
    BEGIN
        DECLARE @message NVARCHAR(2048) = N'Azure SQL Database does not support USE. Re-run sqlcmd with -d ' + QUOTENAME(@databaseName) + N'.';
        THROW 50000, @message, 1;
    END

    EXEC(@setupSql);
END
ELSE
BEGIN
    IF DB_ID(@databaseName) IS NULL
    BEGIN
        DECLARE @createDatabaseSql NVARCHAR(MAX) = N'CREATE DATABASE ' + QUOTENAME(@databaseName) + N';';
        EXEC(@createDatabaseSql);
    END

    SET @setupSql = N'USE ' + QUOTENAME(@databaseName) + N';
' + @setupSql;
    EXEC(@setupSql);
END
GO
