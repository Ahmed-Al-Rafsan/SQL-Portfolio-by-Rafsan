# **Day 19 — Final SQL Project**



Select \* From Sales;

Select \* From Products;



**-- Task 1 — Profitability Report per Product**

**-- For each product, calculate:**

**-- Total Revenue**

**-- Total Cost**

**-- Total Profit**

**-- Profit Margin (%)**



Select 

s.Product\_Name,p.cost,

&nbsp;	Sum(Quantity\*Price) AS Total\_Revenue,

&nbsp;	Sum(s.Quantity\*p.cost) AS Total\_Cost,

&nbsp;	Sum(Quantity\*Price) - Sum(s.Quantity\*p.cost) AS Total\_Profit,

&nbsp;	Round(((Sum(Quantity\*Price) - Sum(s.Quantity\*p.cost))/Sum(Quantity\*Price)) \* 100,2) AS Profit\_Margin 

From Sales as s

Inner Join Products As p

On s.Product\_Name=p.Product\_Name

Group BY Product\_Name,p.cost ;



Select \* From Sales;

Select \* From Products;





**-- Task 2 — Monthly Category Performance Show:**

**-- Category ,Month (YYYY-MM),Total Revenue,Month-over-Month Change (%)**



Select 

t.Category,t.Month,t.Total\_Revenue AS Total\_Revenue,

Case 

&nbsp;	When MoM IS NUll Or MoM =0 Then Null 

&nbsp;   Else Round(((t.Total\_Revenue-t.MOM)/t.MOM)\* 100,2) END AS MoM\_Change 

From 

&nbsp;	(Select

&nbsp;	Category,

&nbsp;	date\_format(Sales\_date,'%Y-%m') AS Month,

&nbsp;	Sum(Quantity\*Price) AS Total\_Revenue,

&nbsp;   Lag(Sum(Quantity\*Price)) Over ( Partition BY Category Order BY date\_format(Sales\_date,'%Y-%m') ) AS MOM

&nbsp;	From Sales 

&nbsp;	Group BY Category,Month) AS t ;



Select \* From Sales;

Select \* From Products;





**-- Task 3 — Top 5 Best-Performing Products Overall - Using the Sales and Products tables,**

**-- show the Top 5 products ranked by Total Profit, including:**

**-- Product Name**

**-- Total Revenue**

**-- Total Cost**

**-- Total Profit**

**-- Profit Margin (%)**

**-- Rank based on Profit**



With CTE AS (Select 

&nbsp;	s.Product\_Name,

&nbsp;	Sum(s.Price\*s.Quantity) AS Total\_Revenue,

&nbsp;	Sum(s.Quantity \* p.Cost) AS Total\_Cost 

&nbsp;	From Sales As s 

&nbsp;	Inner Join Products As p 

&nbsp;	On s.Product\_Name = p.Product\_Name

&nbsp;	Group BY Product\_Name),

CTE1 AS ( Select 

&nbsp;	t.Product\_Name,t.Total\_Revenue,t.Total\_Profit,Total\_Cost,

&nbsp;	((t.Total\_Revenue-t.Total\_Cost)/t.Total\_Cost) \* 100 AS Profit\_Margin

From

(Select 

&nbsp;	Product\_Name,Total\_Revenue,Total\_Cost,

&nbsp;	(Total\_Revenue-Total\_Cost) AS Total\_Profit

&nbsp;	From CTE ) as t) ,

CTE2 AS (Select 

&nbsp;	Product\_Name,Total\_Revenue,Total\_Cost, Total\_Profit,Profit\_Margin,

&nbsp;	Dense\_Rank() Over( Order BY Total\_Profit Desc ) AS Top\_5\_Product

From CTE1)

Select \* From CTE2

Where Top\_5\_Product <=5 ;



Select \* From Sales;

Select \* From Products;





**-- Task 4 — Cumulative Revenue Growth by Category**





With CTE AS ( Select 

Category, date\_format(Sales\_date,'%Y-%m') AS Month,

Sum(Quantity\*Price) As Total\_Revenue

From Sales 

Group By Category, date\_format(Sales\_date,'%Y-%m'))

Select 

Category,Month,Total\_Revenue,

Sum(Total\_Revenue) Over (Partition By Category Order BY Month) AS Cumulative\_Revenue\_Growth

From CTE ;



Select \* From Sales;

Select \* From Products;





**-- Task 5 — Create a View: vw\_Category\_Profitability**

**-- Save your category-level metrics so analysts or Power BI/Tableau can query them directly.**

**-- The view should include: Category ,Total Revenue,Total Cost,Total Profit,Profit Margin (%)**





Create View vw\_Category\_Profitability AS 

Select 

t.Category,t.Total\_Revenue,t.Total\_Cost,t.Total\_Profit,t.Profit\_Margin\_Per

From

(With Join\_Table  AS (Select 

&nbsp;	s.Category,s.price,s.Quantity, p.Cost

&nbsp;	From Sales AS s 

&nbsp;	Inner Join Products AS p 

&nbsp;	On s.Product\_Name =p.Product\_Name ),

&nbsp;	Total AS (Select 

&nbsp;	Category, 

&nbsp;	Sum(Price\*Quantity) AS Total\_Revenue,

&nbsp;	Sum(Quantity \*Cost) AS Total\_Cost

&nbsp;	From Join\_Table

&nbsp;	Group By Category ),

&nbsp;	Total\_Profit AS (Select 

&nbsp;	Category,Total\_Revenue,Total\_Cost,

&nbsp;	(Total\_Revenue-Total\_Cost) AS Total\_Profit From Total)

&nbsp;	Select 

&nbsp;	Category,Total\_Revenue,Total\_Cost,Total\_Profit,

&nbsp;	((Total\_Revenue-Total\_Cost)/Total\_Revenue) \* 100 AS Profit\_Margin\_Per

&nbsp;	From Total\_Profit) AS t ;

-- Testing View : 

Show tables ;

Select \* From vw\_category\_profitability ;





