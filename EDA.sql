select * from customer_profiles;
select * from product_inventory;
select * from sales_transaction;

-- Total No of Product Sold Each Category

SELECT product_inventory.Category, SUM(sales_transaction.QuantityPurchased) AS Product_Distribution 
FROM product_inventory JOIN sales_transaction
ON product_inventory.ProductID = sales_transaction.ProductID
GROUP BY product_inventory.Category ORDER BY Product_Distribution DESC;

-- Percentage of product sold each category

create table product_sold_per_category as SELECT 
    pi.Category,
    SUM(st.QuantityPurchased) AS Total_Product_Sold_Each_Category,
    ROUND(100 * SUM(st.QuantityPurchased) / (SELECT SUM(QuantityPurchased) FROM sales_transaction), 2) AS Percentage_Of_Total_Sold
FROM 
    product_inventory pi
JOIN 
    sales_transaction st ON pi.ProductID = st.ProductID
GROUP BY 
    pi.Category
ORDER BY 
    Total_Product_Sold_Each_Category DESC;
    
select * from product_sold_per_category;

SELECT * FROM product_sold_per_category
INTO OUTFILE 'C:/Users/jayan/Desktop/RetailAnalysisCaseStudy/visualization/product_sold_per_category.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- Different types of Product Each Category

WITH CTE AS (
	SELECT product_inventory.ProductID, product_inventory.ProductName, product_inventory.Category, sales_transaction.QuantityPurchased 
	FROM product_inventory JOIN sales_transaction
	ON product_inventory.ProductID = sales_transaction.ProductID
) SELECT Category, COUNT(ProductName) as Product_Count FROM CTE GROUP BY Category;

-- Most Purchased Product Each Category

WITH RankedProducts AS (
    SELECT 
        pi.Category,
        pi.ProductName,
        st.QuantityPurchased,
        RANK() OVER (
            PARTITION BY pi.Category 
            ORDER BY st.QuantityPurchased DESC
        ) AS rnk
    FROM product_inventory pi
    JOIN sales_transaction st ON pi.ProductID = st.ProductID
)
SELECT Category, ProductName, QuantityPurchased
FROM RankedProducts
WHERE rnk = 1;

-- Total Sales of Each Product

SELECT ProductID, sum(QuantityPurchased) * SUM(Price) AS Total_Sales_Of_Each_Product 
FROM sales_transaction 
GROUP BY ProductID 
ORDER BY Total_Sales_Of_Each_Product DESC;

-- Total Sales Per Month

WITH CTE AS(
	SELECT 
		DATE_FORMAT(TransactionDate, '%Y-%m') AS yr_m,
		SUM(QuantityPurchased) * SUM(Price) as Total_Sales_PerMonth
	FROM 
		sales_transaction
	GROUP BY 
		yr_m
	ORDER BY 
		yr_m
) SELECT * FROM CTE;

-- Month-Over-Month Growth Rate

WITH MonthlySales AS (
    SELECT 
        DATE_FORMAT(TransactionDate, '%Y-%m') AS yr_m,
        SUM(QuantityPurchased) * SUM(Price) AS Total_Sales_PerMonth
    FROM 
        sales_transaction
    GROUP BY 
        yr_m
)
SELECT
    yr_m,
    Total_Sales_PerMonth,
    LAG(Total_Sales_PerMonth) OVER (ORDER BY yr_m) AS Prev_Month_Sales,
    ROUND(
        100 * (Total_Sales_PerMonth - LAG(Total_Sales_PerMonth) OVER (ORDER BY yr_m))
        / NULLIF(LAG(Total_Sales_PerMonth) OVER (ORDER BY yr_m), 0),
        2
    ) AS MoM_Growth_Percent
FROM
    MonthlySales
ORDER BY yr_m;

 







