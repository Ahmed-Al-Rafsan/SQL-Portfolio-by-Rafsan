Select * From Sales;
Select * From Products;

-- Task 1 — Profitability Report per Product
-- For each product, calculate:
-- Total Revenue
-- Total Cost
-- Total Profit
-- Profit Margin (%)
Select 
s.Product_Name,p.cost,
	Sum(Quantity*Price) AS Total_Revenue,
	Sum(s.Quantity*p.cost) AS Total_Cost,
	Sum(Quantity*Price) - Sum(s.Quantity*p.cost) AS Total_Profit,
	Round(((Sum(Quantity*Price) - Sum(s.Quantity*p.cost))/Sum(Quantity*Price)) * 100,2) AS Profit_Margin 
From Sales as s
Inner Join Products As p
On s.Product_Name=p.Product_Name
Group BY Product_Name,p.cost ;

Select * From Sales;
Select * From Products;
-- Task 2 — Monthly Category Performance Show:
-- Category ,Month (YYYY-MM),Total Revenue,Month-over-Month Change (%)
Select 
t.Category,t.Month,t.Total_Revenue AS Total_Revenue,
Case 
	When MoM IS NUll Or MoM =0 Then Null 
    Else Round(((t.Total_Revenue-t.MOM)/t.MOM)* 100,2) END AS MoM_Change 
From 
	(Select
	Category,
	date_format(Sales_date,'%Y-%m') AS Month,
	Sum(Quantity*Price) AS Total_Revenue,
    Lag(Sum(Quantity*Price)) Over ( Partition BY Category Order BY date_format(Sales_date,'%Y-%m') ) AS MOM
	From Sales 
	Group BY Category,Month) AS t ;

Select * From Sales;
Select * From Products;
-- Task 3 — Top 5 Best-Performing Products Overall - Using the Sales and Products tables,
-- show the Top 5 products ranked by Total Profit, including:
-- Product Name
-- Total Revenue
-- Total Cost
-- Total Profit
-- Profit Margin (%)
-- Rank based on Profit

With CTE AS (Select 
	s.Product_Name,
	Sum(s.Price*s.Quantity) AS Total_Revenue,
	Sum(s.Quantity * p.Cost) AS Total_Cost 
	From Sales As s 
	Inner Join Products As p 
	On s.Product_Name = p.Product_Name
	Group BY Product_Name),
CTE1 AS ( Select 
	t.Product_Name,t.Total_Revenue,t.Total_Profit,Total_Cost,
	((t.Total_Revenue-t.Total_Cost)/t.Total_Cost) * 100 AS Profit_Margin
From
(Select 
	Product_Name,Total_Revenue,Total_Cost,
	(Total_Revenue-Total_Cost) AS Total_Profit
	From CTE ) as t) ,
CTE2 AS (Select 
	Product_Name,Total_Revenue,Total_Cost, Total_Profit,Profit_Margin,
	Dense_Rank() Over( Order BY Total_Profit Desc ) AS Top_5_Product
From CTE1)
Select * From CTE2
Where Top_5_Product <=5 ;

Select * From Sales;
Select * From Products;
-- Task 4 — Cumulative Revenue Growth by Category
With CTE AS ( Select 
Category, date_format(Sales_date,'%Y-%m') AS Month,
Sum(Quantity*Price) As Total_Revenue
From Sales 
Group By Category, date_format(Sales_date,'%Y-%m'))
Select 
Category,Month,Total_Revenue,
Sum(Total_Revenue) Over (Partition By Category Order BY Month) AS Cumulative_Revenue_Growth
From CTE ;

Select * From Sales;
Select * From Products;

-- Task 5 — Create a View: vw_Category_Profitability
-- Save your category-level metrics so analysts or Power BI/Tableau can query them directly.
-- The view should include: Category ,Total Revenue,Total Cost,Total Profit,Profit Margin (%)
Create View vw_Category_Profitability AS 
Select 
t.Category,t.Total_Revenue,t.Total_Cost,t.Total_Profit,t.Profit_Margin_Per
From
(With Join_Table  AS (Select 
	s.Category,s.price,s.Quantity, p.Cost
	From Sales AS s 
	Inner Join Products AS p 
	On s.Product_Name =p.Product_Name ),
	Total AS (Select 
	Category, 
	Sum(Price*Quantity) AS Total_Revenue,
	Sum(Quantity *Cost) AS Total_Cost
	From Join_Table
	Group By Category ),
	Total_Profit AS (Select 
	Category,Total_Revenue,Total_Cost,
	(Total_Revenue-Total_Cost) AS Total_Profit From Total)
	Select 
	Category,Total_Revenue,Total_Cost,Total_Profit,
	((Total_Revenue-Total_Cost)/Total_Revenue) * 100 AS Profit_Margin_Per
	From Total_Profit) AS t ;
-- Testing View : 
Show tables ;
Select * From vw_category_profitability ;

