-- Analyzing patterns in repeat purchases and loyality indicatior

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
        COUNT(*) AS TotalPurchases,
        AVG(DATEDIFF(TransactionDate, PrevPurchaseDate)) AS AvgDaysBetweenPurchases,
        CASE
            WHEN AVG(DATEDIFF(TransactionDate, PrevPurchaseDate)) <= 73 THEN 'Loyal'
            WHEN AVG(DATEDIFF(TransactionDate, PrevPurchaseDate)) BETWEEN 74 AND 140 THEN 'Moderate'
            ELSE 'At-Risk'
        END AS LoyaltyStatus
    FROM PurchaseIntervals
    WHERE PrevPurchaseDate IS NOT NULL
    GROUP BY CustomerID
),
RepeatPurchaseAnalysis AS (
    SELECT
        CustomerID,
        TotalPurchases,
        AvgDaysBetweenPurchases,
        LoyaltyStatus,
        COUNT(CASE WHEN DATEDIFF(TransactionDate, PrevPurchaseDate) <= 30 THEN 1 END) AS RepeatPurchasesWithin30Days,
        COUNT(CASE WHEN DATEDIFF(TransactionDate, PrevPurchaseDate) > 30 THEN 1 END) AS PurchasesAfter30Days
    FROM PurchaseIntervals
    JOIN CustomerLoyalty USING (CustomerID)
    WHERE PrevPurchaseDate IS NOT NULL
    GROUP BY CustomerID, TotalPurchases, AvgDaysBetweenPurchases, LoyaltyStatus
)
SELECT
    CustomerID,
    TotalPurchases,
    AvgDaysBetweenPurchases,
    LoyaltyStatus,
    RepeatPurchasesWithin30Days,
    PurchasesAfter30Days
FROM RepeatPurchaseAnalysis
ORDER BY AvgDaysBetweenPurchases;


