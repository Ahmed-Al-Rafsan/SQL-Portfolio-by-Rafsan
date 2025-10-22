use chemist_warehouse ;
select * from sales;
select * from products;
-- 1. Compare Monthly Sales with Previous Month
With CTE As ( Select
Category,
date_format(Sales_Date,'%Y-%m') AS Month,
Sum(Quantity*Price) As total_Revenue 
From Sales
Group By Category,Month),
CTE1 AS (Select 
Category, Month,total_Revenue,
Lag(total_Revenue) Over( Partition By Category Order By Month) AS Monthly_Sales_Comparision 
From CTE)
Select 
Category,Month,Total_revenue,total_Revenue-Monthly_Sales_Comparision  AS Month_Over_Month_Change
From CTE1
Order By Category ,Month;

-- 2. Running Total of Revenue by Category 
Select 
Category ,
Sales_Date ,
Sum(Price*Quantity) AS Total_Revenue ,
Sum(Sum(Price*Quantity)) 
	Over (Partition BY Category Order BY Sales_Date) AS Running_Total
From Sales 
Group By Category ,Sales_DAte 
Order By Category ,Sales_DAte ;

-- 3. Quartile Ranking using NTILE
With CTE AS (Select Category , 
Sum(Price*Quantity) AS Total_Revenue 
From Sales 
Group By Category)
Select Category,Total_Revenue,
NTILE(4) Over( Order BY Total_Revenue) AS Ranking 
From CTE ;

-- 4. Moving Average of Daily Revenue
Select
Product_Name,Category,Sales_Date, 
Round(Avg(Price*Quantity) 
Over( Order By Sales_Date Rows Between 6 Preceding and Current Row),0) AS Moving_Average
From Sales  ;