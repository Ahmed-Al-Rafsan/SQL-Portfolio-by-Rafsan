# Day 16 – Multi-CTE, Rolling Revenue \& Profit Analysis



Select\* From Sales;

Select \* From Products;



**-- Task 1 — CTE Chaining**

**-- For each product in the Sales table, calculate:**

**-- Total revenue (Quantity × Price)**

**-- Then rank all products by total revenue (1 = highest revenue overall)**



With CTE1 AS ( Select 

&nbsp;	Product\_Name,Category,

&nbsp;	Sum(Quantity\*Price) AS Total\_Revenue 

&nbsp;	From Sales 

&nbsp;	Group BY Product\_Name,Category)

Select 

Product\_Name,Category,Total\_Revenue,

Rank() Over( Order By Total\_Revenue Desc) AS Ranking

From CTE1;



Select\* From Sales;

Select \* From Products;



**-- Task 2 — Month-over-Month Revenue Change Using the Sales table:**

**-- 2.1. Calculate total revenue per category per month.**

**-- 2.2 Use the LAG() window function to find the previous month’s revenue.**

**-- 2.3 Add a new column showing Month-Over-Month Change = CurrentMonth – PreviousMonth.**



With CTE1 AS (Select 

&nbsp;	Category, date\_format(Sales\_date,'%Y-%m') AS Month,

&nbsp;	Sum(Price\*Quantity) AS Total\_Revenue 

&nbsp;	From Sales 

&nbsp;	Group BY Category,Month

&nbsp;	Order BY Month),

CTE2 AS ( Select  

&nbsp;	Category, Month, Total\_Revenue,

&nbsp;	Lag(Total\_Revenue) Over (Partition BY Category Order BY Month) AS Previous\_Month\_Rev

&nbsp;	From CTE1)

Select 

&nbsp;	Category, Month, Total\_Revenue,Previous\_Month\_Rev,

&nbsp;	Total\_Revenue -Previous\_Month\_Rev  AS MoM\_Change

&nbsp;	From CTE2

&nbsp;   Order BY Category,Month ;

&nbsp;   

Select\* From Sales;

Select \* From Products;



**-- Task 3 — Rolling 3-Month Revenue -Using the Sales table, calculate:**

**-- Total revenue per category per month**

**-- Then create a column called Rolling\_3\_Month\_Revenue,** 

**-- which shows the sum of the current month’s revenue and the revenues of the previous two months within the same category.**



With CTE AS (Select 

&nbsp;	Category, date\_format(Sales\_date,'%Y-%m') AS Month,

&nbsp;	Sum(Price\*Quantity) AS Total\_Revenue 

&nbsp;	From Sales 

&nbsp;	Group By Category,Month)

Select 

Category,Month,Total\_Revenue,

SUM(Total\_Revenue) Over(Partition By Category Order by Month 

rows between 2 preceding and current row) AS Rolling\_3\_Month\_Revenue

From CTE;



Select\* From Sales;

Select \* From Products;



**-- Task 4 — Profit Ranking by Category**

**-- For each product, calculate: Total revenue = SUM(Quantity \* Price)**

**-- Total cost = SUM(Quantity \* Cost)** 

**-- Profit = Revenue - Cost**

**-- Profit\_Margin = Profit / Revenue**

**-- Rank products inside each Category by Profit (1 = most profitable in that category)**



With CTE AS (Select 

y.Product\_Name,y.Category,y.Total\_Revenue,y.Total\_Cost,y.Profit,

(y.Profit /y.Total\_Revenue) AS Profit\_Margin

From

&nbsp;   (Select 

&nbsp;	t.Product\_Name,t.Category,t.Total\_Revenue,t.Total\_Cost,

&nbsp;	(t.Total\_Revenue-t.Total\_Cost) AS Profit 

&nbsp;	From 

&nbsp;		(Select 

&nbsp;		s.Product\_Name,s.Category,

&nbsp;		Sum(Quantity\*Price) AS Total\_Revenue ,p.cost As Cost,

&nbsp;		Sum(s.Quantity \* p.cost) AS Total\_Cost

&nbsp;		From Sales AS s 

&nbsp;		Inner JOIN Products As p 

&nbsp;		On s.Product\_Name = p.Product\_Name

&nbsp;		Group BY Product\_Name,Category,p.cost

&nbsp;		Order BY Total\_Revenue Desc) AS t) AS y)

&nbsp;Select 

&nbsp;Product\_Name,Category,Total\_Revenue,Total\_Cost,Profit,Profit\_Margin,

&nbsp;Dense\_Rank() Over( Partition BY Category Order BY Profit Desc) AS Ranking

&nbsp;From CTE ;

&nbsp;       



