CREATE DATABASE IF NOT EXISTS RetailAnalysis;

USE RetailAnalysis;

CREATE TABLE customer_profiles (
        `CustomerID` DECIMAL(38, 0) NOT NULL,
        `Age` DECIMAL(38, 0) NOT NULL,
        `Gender` VARCHAR(6) NOT NULL,
        `Location` VARCHAR(5),
        `JoinDate` TIMESTAMP NOT NULL
);

CREATE TABLE product_inventory (
        `ProductID` DECIMAL(38, 0) NOT NULL,
        `ProductName` VARCHAR(11) NOT NULL,
        `Category` VARCHAR(15) NOT NULL,
        `StockLevel` DECIMAL(38, 0) NOT NULL,
        `Price` DECIMAL(38, 2) NOT NULL
);

CREATE TABLE sales_transaction (
        `TransactionID` DECIMAL(38, 0) NOT NULL,
        `CustomerID` DECIMAL(38, 0) NOT NULL,
        `ProductID` DECIMAL(38, 0) NOT NULL,
        `QuantityPurchased` DECIMAL(38, 0) NOT NULL,
        `TransactionDate` TIMESTAMP NOT NULL,
        `Price` DECIMAL(38, 2) NOT NULL
);

show tables;
