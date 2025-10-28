# Day 17 – SQL Views, Stored Procedures \& Index Optimization



Select\* From Sales;

Select \* From Products;



**-- Task1 . Create a view named Product\_Profit\_View that shows:**

**-- Product\_Name | Category | Total\_Revenue | Total\_Cost | Profit**



Create View Product\_Profit\_View AS 

Select 

t.Product\_Name,t.Category,t.Total\_Revenue,t.Total\_Cost,t.Profit

From 

( With CTE AS (Select 

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

&nbsp;From CTE ) t;

Select \* From Product\_Profit\_View;



**-- 2. create a stored procedure named CategoryRevenueReport in your database, and run it for one real category in your data**



Delimiter //

Create Procedure CategoryRevenueReport()

Begin

&nbsp;With CTE AS (Select 

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

End //

Delimiter ;

call CategoryRevenueReport()



**-- Task 3.Create and Verify an Index.**

Create Index Index\_1 On Sales(Product\_Name);

Show Indexes from Sales;

