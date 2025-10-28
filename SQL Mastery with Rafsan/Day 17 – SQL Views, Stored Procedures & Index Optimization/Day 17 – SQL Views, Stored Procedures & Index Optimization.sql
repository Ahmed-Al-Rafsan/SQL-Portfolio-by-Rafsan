Select* From Sales;
Select * From Products;
-- Task1 . Create a view named Product_Profit_View that shows:
-- Product_Name | Category | Total_Revenue | Total_Cost | Profit
Create View Product_Profit_View AS 
Select 
t.Product_Name,t.Category,t.Total_Revenue,t.Total_Cost,t.Profit
From 
( With CTE AS (Select 
y.Product_Name,y.Category,y.Total_Revenue,y.Total_Cost,y.Profit,
(y.Profit /y.Total_Revenue) AS Profit_Margin
From
    (Select 
	t.Product_Name,t.Category,t.Total_Revenue,t.Total_Cost,
	(t.Total_Revenue-t.Total_Cost) AS Profit 
	From 
		(Select 
		s.Product_Name,s.Category,
		Sum(Quantity*Price) AS Total_Revenue ,p.cost As Cost,
		Sum(s.Quantity * p.cost) AS Total_Cost
		From Sales AS s 
		Inner JOIN Products As p 
		On s.Product_Name = p.Product_Name
		Group BY Product_Name,Category,p.cost
		Order BY Total_Revenue Desc) AS t) AS y)
 Select 
 Product_Name,Category,Total_Revenue,Total_Cost,Profit,Profit_Margin,
 Dense_Rank() Over( Partition BY Category Order BY Profit Desc) AS Ranking
 From CTE ) t;
Select * From Product_Profit_View;

-- 2. create a stored procedure named CategoryRevenueReport in your database, and run it for one real category in your data
Delimiter //
Create Procedure CategoryRevenueReport()
Begin
 With CTE AS (Select 
y.Product_Name,y.Category,y.Total_Revenue,y.Total_Cost,y.Profit,
(y.Profit /y.Total_Revenue) AS Profit_Margin
From
    (Select 
	t.Product_Name,t.Category,t.Total_Revenue,t.Total_Cost,
	(t.Total_Revenue-t.Total_Cost) AS Profit 
	From 
		(Select 
		s.Product_Name,s.Category,
		Sum(Quantity*Price) AS Total_Revenue ,p.cost As Cost,
		Sum(s.Quantity * p.cost) AS Total_Cost
		From Sales AS s 
		Inner JOIN Products As p 
		On s.Product_Name = p.Product_Name
		Group BY Product_Name,Category,p.cost
		Order BY Total_Revenue Desc) AS t) AS y)
 Select 
 Product_Name,Category,Total_Revenue,Total_Cost,Profit,Profit_Margin,
 Dense_Rank() Over( Partition BY Category Order BY Profit Desc) AS Ranking
 From CTE ;
End //
Delimiter ;
call CategoryRevenueReport()

-- Task 3.Create and Verify an Index.
Create Index Index_1 On Sales(Product_Name);
Show Indexes from Sales;