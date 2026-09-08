-- create-database.sql
-- Creates the empty Azure SQL Database used by Sources/schema.sql.
--
-- Run this while connected to the Azure SQL logical server's master database:
--
--   sqlcmd -S tcp:<server>.database.windows.net,1433 -d master -U <user> -P <password> -v DatabaseName="demo" -i Sources/create-database.sql
--
-- Then reconnect to the new database and run Sources/schema.sql.

:setvar DatabaseName "demo"

IF DB_ID(N'$(DatabaseName)') IS NULL
BEGIN
    DECLARE @sql NVARCHAR(MAX) = N'CREATE DATABASE ' + QUOTENAME(N'$(DatabaseName)');
    EXEC(@sql);
END
GO
