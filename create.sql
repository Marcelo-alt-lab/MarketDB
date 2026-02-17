-- 1. Comprobador de existencia de la base de datos
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'MarketDB')
BEGIN
    CREATE DATABASE MarketDB;
END