Select* From Sales;
Select * From Products;
-- Task 1 — CTE Chaining
-- For each product in the Sales table, calculate:
-- Total revenue (Quantity × Price)
-- Then rank all products by total revenue (1 = highest revenue overall)
With CTE1 AS ( Select 
	Product_Name,Category,
	Sum(Quantity*Price) AS Total_Revenue 
	From Sales 
	Group BY Product_Name,Category)
Select 
Product_Name,Category,Total_Revenue,
Rank() Over( Order By Total_Revenue Desc) AS Ranking
From CTE1;

Select* From Sales;
Select * From Products;

-- Task 2 — Month-over-Month Revenue Change Using the Sales table:
-- 2.1. Calculate total revenue per category per month.
-- 2.2 Use the LAG() window function to find the previous month’s revenue.
-- 2.3 Add a new column showing Month-Over-Month Change = CurrentMonth – PreviousMonth.
With CTE1 AS (Select 
	Category, date_format(Sales_date,'%Y-%m') AS Month,
	Sum(Price*Quantity) AS Total_Revenue 
	From Sales 
	Group BY Category,Month
	Order BY Month),
CTE2 AS ( Select  
	Category, Month, Total_Revenue,
	Lag(Total_Revenue) Over (Partition BY Category Order BY Month) AS Previous_Month_Rev
	From CTE1)
Select 
	Category, Month, Total_Revenue,Previous_Month_Rev,
	Total_Revenue -Previous_Month_Rev  AS MoM_Change
	From CTE2
    Order BY Category,Month ;
    
Select* From Sales;
Select * From Products;

-- Task 3 — Rolling 3-Month Revenue -Using the Sales table, calculate:
-- Total revenue per category per month
-- Then create a column called Rolling_3_Month_Revenue, 
-- which shows the sum of the current month’s revenue and the revenues of the previous two months within the same category.
With CTE AS (Select 
	Category, date_format(Sales_date,'%Y-%m') AS Month,
	Sum(Price*Quantity) AS Total_Revenue 
	From Sales 
	Group By Category,Month)
Select 
Category,Month,Total_Revenue,
SUM(Total_Revenue) Over(Partition By Category Order by Month 
rows between 2 preceding and current row) AS Rolling_3_Month_Revenue
From CTE;

Select* From Sales;
Select * From Products;

-- Task 4 — Profit Ranking by Category
-- For each product, calculate: Total revenue = SUM(Quantity * Price)
-- Total cost = SUM(Quantity * Cost) 
-- Profit = Revenue - Cost
-- Profit_Margin = Profit / Revenue
-- Rank products inside each Category by Profit (1 = most profitable in that category)
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
        
