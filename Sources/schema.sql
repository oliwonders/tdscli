-- schema.sql
-- Creates a small demo database for exercising tdscli / FreeTDSKit.
--
-- Load it with the sqlcmd tool (bundled with SQL Server / mssql-tools):
--
--   sqlcmd -S <server> -U <user> -P <password> -i Sources/schema.sql
--
-- e.g.
--
--   sqlcmd -S 192.168.7.179 -U sa -P 'YourStrong@Passw0rd' -i Sources/schema.sql

IF DB_ID(N'demo') IS NULL
    CREATE DATABASE demo;
GO

USE demo;
GO

IF OBJECT_ID(N'dbo.Product', N'U') IS NOT NULL
    DROP TABLE dbo.Product;
GO

CREATE TABLE dbo.Product (
    ProductID   INT           NOT NULL PRIMARY KEY,
    ProductName NVARCHAR(100) NOT NULL,
    Quantity    INT           NOT NULL
);
GO

INSERT INTO dbo.Product (ProductID, ProductName, Quantity) VALUES
    (1, N'Widget',   100),
    (2, N'Gadget',    42),
    (3, N'Gizmo',      7),
    (4, N'Doohickey', 88),
    (5, N'Thingamajig', 15);
GO
