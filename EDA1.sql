select * from customer_profiles;
select * from product_inventory;
select * from sales_transaction;

-- Segmentation of Cutomer According to Total Product Purchased and Spending

WITH Customer_Segment AS(
	SELECT 
	CustomerID, COUNT(ProductID) AS Total_Product_Purchased 
	FROM sales_transaction 
	GROUP BY CustomerID 
	ORDER BY Total_Product_Purchased DESC
) SELECT 
	CASE
		WHEN Total_Product_Purchased BETWEEN 1 AND 10 THEN "LOW-VALUE"
        WHEN Total_Product_Purchased BETWEEN 10 AND 20 THEN "MID-VALUE"
        ELSE "HIGH_VALUE"
	END
    AS Customer_Segment,
    COUNT(CustomerID) AS Total_Customer_Per_Segment,
    ROUND(
		100 * COUNT(CustomerID) / SUM(COUNT(CustomerID)) OVER(),
        2
    ) AS Percentage_Per_Segment
FROM Customer_Segment GROUP BY Customer_Segment ORDER BY Percentage_Per_Segment DESC;

-- So, the Compnay has only Low-Value and Mid-Value Customer
-- And maximum are Low-Value Customer
-- This segementation was done on total product purchased by each customer not on total money spent by customer

WITH Customer_Segment AS(
	SELECT 
	CustomerID, SUM(QuantityPurchased) * SUM(Price) AS Total_Amount_Spent 
	FROM sales_transaction 
	GROUP BY CustomerID 
	ORDER BY Total_Amount_Spent DESC
) SELECT 
	CASE
		WHEN Total_Amount_Spent BETWEEN 1 AND 10000 THEN "LOW-VALUE"
        WHEN Total_Amount_Spent BETWEEN 10000 AND 20000 THEN "MID-VALUE"
        ELSE "HIGH_VALUE"
	END
    AS Customer_Segment,
    COUNT(CustomerID) as Total_Customer_Per_Segment
FROM Customer_Segment GROUP BY Customer_Segment;

        
WITH Customer_Segment AS (
    SELECT 
        CustomerID, 
        SUM(QuantityPurchased) * SUM(Price) AS Total_Amount_Spent 
    FROM 
        sales_transaction 
    GROUP BY 
        CustomerID
)
SELECT 
    CASE
        WHEN Total_Amount_Spent BETWEEN 1 AND 10000 THEN 'LOW-VALUE'
        WHEN Total_Amount_Spent BETWEEN 10000 AND 20000 THEN 'MID-VALUE'
        ELSE 'HIGH-VALUE'
    END AS Customer_Segment,
    COUNT(CustomerID) AS Total_Customer_Per_Segment,
    ROUND(
        100.0 * COUNT(CustomerID) / SUM(COUNT(CustomerID)) OVER (), 
        2
    ) AS Percentage_Per_Segment
FROM 
    Customer_Segment
GROUP BY 
    Customer_Segment
ORDER BY 
    Percentage_Per_Segment DESC;
    
-- So, the Compnay has Low-Value, Mid-Value and High-Value Customers
-- And maximum are Low-Value Customer then Mid-Value and High-Value
-- This segementation was done on total amount spent by each customer not on total product purchased by each customer
    
-- Identification of Loyal Customer according to gap between there Purchases

WITH PurchaseIntervals AS (
    SELECT
        CustomerID,
        TransactionDate,
        QuantityPurchased,
        LAG(TransactionDate) OVER (PARTITION BY CustomerID ORDER BY TransactionDate) AS PrevPurchaseDate
    FROM sales_transaction
)
SELECT
    CustomerID,
    AVG(DATEDIFF(TransactionDate, PrevPurchaseDate)) AS Avg_Days_Between_Purchases,
    COUNT(*) AS Total_Purchases,
    CASE
        WHEN AVG(DATEDIFF(TransactionDate, PrevPurchaseDate)) <= 73 THEN 'Loyal'
        WHEN AVG(DATEDIFF(TransactionDate, PrevPurchaseDate)) BETWEEN 73 AND 140 THEN 'Moderate'
        ELSE 'At-Risk'
    END AS Loyalty_Status
FROM PurchaseIntervals
WHERE PrevPurchaseDate IS NOT NULL
GROUP BY CustomerID
ORDER BY Avg_Days_Between_Purchases;

-- Customer Distribution on the basis of loyalty

WITH PurchaseIntervals AS (
    SELECT
        CustomerID,
        TransactionDate,
        QuantityPurchased,
        LAG(TransactionDate) OVER (PARTITION BY CustomerID ORDER BY TransactionDate) AS PrevPurchaseDate
    FROM sales_transaction
),
CustomerLoyalty AS (
    SELECT
        CustomerID,
        AVG(DATEDIFF(TransactionDate, PrevPurchaseDate)) AS Avg_Days_Between_Purchases,
        COUNT(*) AS Total_Purchases,
        CASE
            WHEN AVG(DATEDIFF(TransactionDate, PrevPurchaseDate)) <= 73 THEN 'Loyal'
            WHEN AVG(DATEDIFF(TransactionDate, PrevPurchaseDate)) BETWEEN 73 AND 140 THEN 'Moderate'
            ELSE 'At-Risk'
        END AS Loyalty_Status
    FROM PurchaseIntervals
    WHERE PrevPurchaseDate IS NOT NULL
    GROUP BY CustomerID
)
SELECT
    Loyalty_Status,
    COUNT(*) AS Customers_Count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM CustomerLoyalty), 2) AS Percentage
FROM CustomerLoyalty
GROUP BY Loyalty_Status
ORDER BY Percentage DESC;




