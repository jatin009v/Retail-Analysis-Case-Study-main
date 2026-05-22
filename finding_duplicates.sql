select * from customer_profiles;
select * from product_inventory;
select * from sales_transaction;

WITH CTE_CP AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY CustomerID, Age, Gender, Location, JoinDate ORDER BY (SELECT NULL)) AS rn
    FROM customer_profiles
)
SELECT *
FROM CTE_CP
WHERE rn > 1;

WITH CTE_PI AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY ProductID, ProductName, Category, StockLevel, Price ORDER BY (SELECT NULL)) AS rn
    FROM product_inventory
)
SELECT *
FROM CTE_PI
WHERE rn > 1;

WITH CTE_ST AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY TransactionID, CustomerID, ProductID, QuantityPurchased, TransactionDate, Price ORDER BY (SELECT NULL)) AS rn
    FROM sales_transaction
)
SELECT *
FROM CTE_ST
WHERE rn > 1;

-- There are four duplicate rows in sales_transaction table

