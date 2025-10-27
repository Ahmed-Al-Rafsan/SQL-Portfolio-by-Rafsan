# Day15\_KPI\_Analysis





**-- Task 1 — Calculate Total Revenue and Total Cost**

**-- For each product, show:**

**-- Product\_Name | Total\_Revenue | Total\_Cost**



WITH CTE1 AS (

&nbsp;   SELECT 

&nbsp;       Product\_Name,

&nbsp;       SUM(Quantity \* Price) AS Total\_Revenue

&nbsp;   FROM Sales

&nbsp;   GROUP BY Product\_Name

),

CTE2 AS (

&nbsp;   SELECT 

&nbsp;       t.Product\_Name,

&nbsp;       SUM(t.Quantity \* t.Cost) AS Total\_Cost

&nbsp;   FROM (

&nbsp;       SELECT 

&nbsp;           s.Product\_Name,

&nbsp;           s.Quantity,

&nbsp;           p.Cost

&nbsp;       FROM Sales AS s

&nbsp;       LEFT JOIN Products AS p 

&nbsp;           ON s.Product\_Name = p.Product\_Name

&nbsp;   ) AS t

&nbsp;   GROUP BY t.Product\_Name

)

SELECT 

&nbsp;   s.Product\_Name,

&nbsp;   s.Total\_Revenue,

&nbsp;   p.Total\_Cost

FROM CTE1 AS s

INNER JOIN CTE2 AS p 

&nbsp;   ON s.Product\_Name = p.Product\_Name;



**-- Task 2 — Calculate Profit and Profit Margin per Product**

**-- Product\_Name | Total\_Revenue | Total\_Cost | Profit | Profit\_Margin\_Percentage**



SELECT 

&nbsp;   t2.Product\_Name,

&nbsp;   COALESCE(t2.Total\_Cost, 'Unknown') AS Total\_Cost,

&nbsp;   t2.Total\_Revenue,

&nbsp;   COALESCE(t2.Profit, 'Unknown') AS Profit,

&nbsp;   COALESCE((t2.Profit / t2.Total\_Revenue) \* 100, 'Unknown') AS Profit\_Margin\_Percentage

FROM (

&nbsp;   SELECT 

&nbsp;       t1.Product\_Name,

&nbsp;       t1.Total\_Revenue,

&nbsp;       t1.Total\_Cost,

&nbsp;       (t1.Total\_Revenue - t1.Total\_Cost) AS Profit

&nbsp;   FROM (

&nbsp;       WITH CTE1 AS (

&nbsp;           SELECT 

&nbsp;               Product\_Name,

&nbsp;               SUM(Price \* Quantity) AS Total\_Revenue

&nbsp;           FROM Sales

&nbsp;           GROUP BY Product\_Name

&nbsp;       ),

&nbsp;       CTE2 AS (

&nbsp;           SELECT 

&nbsp;               t.Product\_Name,

&nbsp;               SUM(t.Quantity \* t.Cost) AS Total\_Cost

&nbsp;           FROM (

&nbsp;               SELECT 

&nbsp;                   s.Product\_Name,

&nbsp;                   s.Quantity,

&nbsp;                   p.Cost

&nbsp;               FROM Sales AS s

&nbsp;               INNER JOIN Products AS p 

&nbsp;                   ON s.Product\_Name = p.Product\_Name

&nbsp;           ) AS t

&nbsp;           GROUP BY t.Product\_Name

&nbsp;       )

&nbsp;       SELECT 

&nbsp;           c1.Product\_Name,

&nbsp;           c1.Total\_Revenue,

&nbsp;           c2.Total\_Cost

&nbsp;       FROM CTE1 AS c1

&nbsp;       INNER JOIN CTE2 AS c2 

&nbsp;           ON c1.Product\_Name = c2.Product\_Name

&nbsp;   ) AS t1

) AS t2;

Select\* From Sales;

Select \* From Products;





**-- Task 3.1 For each category, calculate the total monthly revenue.**

**-- Show: Category ,Month (format as YYYY-MM),Total\_Monthly\_Revenue**



Select 

Category , 

Date\_Format(Sales\_date,'%Y-%m') AS Month,

Sum( Quantity\*Price) As Monthly\_Revenue 

From Sales 

Group By Category,Month;



\-**- Task 3.2 — Add Previous Month’s Revenue**

Select 

t.Category,t.Month,t.Monthly\_Revenue,

ifnull(Lag (Monthly\_Revenue) Over( Partition By Category order By t.Month),'First Month') AS Previous\_Month\_Revenue

From

(Select 

Category , 

Date\_Format(Sales\_date,'%Y-%m') AS Month,

Sum( Quantity\*Price) As Monthly\_Revenue 

From Sales 

Group By Category,Month) AS t;



**-- Task 3.3 — Month-over-Month Growth %**

&nbsp;	With CTE AS (Select 

&nbsp;	t.Category,t.Month,t.Monthly\_Revenue,

&nbsp;	ifnull(Lag (Monthly\_Revenue) Over( Partition By Category order By t.Month),'First Month') AS Previous\_Month\_Revenue

&nbsp;	From

&nbsp;	(Select 

&nbsp;	Category , 

&nbsp;	Date\_Format(Sales\_date,'%Y-%m') AS Month,

&nbsp;	Sum( Quantity\*Price) As Monthly\_Revenue 

&nbsp;	From Sales 

&nbsp;	Group By Category,Month) AS t)

&nbsp;	Select 

&nbsp;	Category,Month,Monthly\_Revenue,Previous\_Month\_Revenue,

&nbsp;	Round(ifnull(((Monthly\_Revenue-Previous\_Month\_Revenue)/Previous\_Month\_Revenue)\*100,'First Month'),2) AS MOM\_Growth\_Per

&nbsp;	From CTE;

&nbsp;   Select \* From Sales;

&nbsp;   Select \* From Products;





**-- Task 4 — Profitability Ranking by Category.**

**-- What it does: Calculates Total\_Revenue per Category**

**-- Calculates Total\_Cost per Category (using Cost from Products)**

**-- Calculates Profit = Revenue - Cost**

**-- Ranks categories by Profit (1 = most profitable)**





WIth CTE AS (Select 

t.Product\_Name,t.Category,t.Revenue,t.Cost,

(t.Revenue-t.Cost) AS Profit

From

(Select

&nbsp;	s.Product\_Name,s.Category,

&nbsp;	Sum(Quantity\*Price) Over (Partition By Product\_Name) As Revenue,

&nbsp;	p.Cost

From Sales AS s

&nbsp;	Inner Join Products AS p

&nbsp;	On s.Product\_Name=p.Product\_Name) AS t)

&nbsp; Select  

&nbsp; Product\_Name,Category,Revenue,Cost, Profit,

&nbsp; dense\_rank () Over(Order BY Profit Desc)

&nbsp; From CTE;

&nbsp; -- Calculates Total\_Revenue per Category

Select 

Category,

Sum(Quantity\*Price) AS Total\_Revenue 

From Sales 

Group BY Category;

Select\* From Sales;

Select \* From Products;

-- Calculates Total\_Cost per Category (using Cost from Products)

Select 

t.Category,

Sum(t.Quantity\*t.cost) As Total\_Cost

From 	

&nbsp;   (Select s.Category,s.Quantity,p.cost

&nbsp;	from sales as s 

&nbsp;	Inner Join Products as p 

&nbsp;	On s.Product\_Name=p.Product\_Name) AS t

Group By t.Category ;

