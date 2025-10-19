use chemist_warehouse ;
Select * from Sales ;
Select * from Products ;

-- 1. Create a CTE to show each category and its average price.
With cte_Category_1 AS (
Select Product_Name,Category,Quantity,Price
From Sales)
Select 
 Category,
avg(Price) As Avg_Price From cte_Category_1 Group BY  Category ;

-- 2.From that CTE, show only categories whose average price > 30.
WIth Cte_Category As (
Select Product_Name,Category,Quantity,Price
From Sales)
Select Category , avg (Price) as Avg_Price From Cte_Category
Group By Category
Having Avg_Price >30;

-- 3. Create a CTE to find total revenue per product, then show only top 3 products by revenue.
WIth CTE AS ( 
Select Product_Name,Category,Sum(Price*Quantity) AS Total_Revenue
From Sales
Group By Product_Name,Category)
Select Category,Total_Revenue
From CTE Order By Total_Revenue Desc Limit 3 ;