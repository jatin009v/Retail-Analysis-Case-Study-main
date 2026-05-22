select * from customer_profiles;
select * from product_inventory;
select * from sales_transaction;

SELECT 
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS CustomerID,
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Age,
    SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS JoinDate,
    SUM(CASE WHEN Location IS NULL THEN 1 ELSE 0 END) AS Location,
    SUM(CASE WHEN JoinDate IS NULL THEN 1 ELSE 0 END) AS col3_nulls
FROM customer_profiles;

SELECT 
    SUM(CASE WHEN ProductID IS NULL THEN 1 ELSE 0 END) AS ProductID,
    SUM(CASE WHEN ProductName IS NULL THEN 1 ELSE 0 END) AS ProductName,
    SUM(CASE WHEN Category IS NULL THEN 1 ELSE 0 END) AS Category,
    SUM(CASE WHEN StockLevel IS NULL THEN 1 ELSE 0 END) AS StockLevel,
    SUM(CASE WHEN Price IS NULL THEN 1 ELSE 0 END) AS Price
FROM product_inventory;

SELECT 
    SUM(CASE WHEN TransactionID IS NULL THEN 1 ELSE 0 END) AS TransactionID,
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS CustomerID,
    SUM(CASE WHEN ProductID IS NULL THEN 1 ELSE 0 END) AS ProductID,
    SUM(CASE WHEN QuantityPurchased IS NULL THEN 1 ELSE 0 END) AS QuantityPurchased,
    SUM(CASE WHEN TransactionDate IS NULL THEN 1 ELSE 0 END) AS TransactionDate,
    SUM(CASE WHEN Price IS NULL THEN 1 ELSE 0 END) AS Price
FROM sales_transaction;

-- No Null values where found
