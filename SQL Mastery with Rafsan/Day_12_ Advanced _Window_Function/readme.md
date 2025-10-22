# Day\_12 More Window Functions 



use chemist\_warehouse ;

select \* from sales;

select \* from products;



**-- 1. Compare Monthly Sales with Previous Month**

With CTE As ( Select

Category,

date\_format(Sales\_Date,'%Y-%m') AS Month,

Sum(Quantity\*Price) As total\_Revenue 

From Sales

Group By Category,Month),

CTE1 AS (Select 

Category, Month,total\_Revenue,

Lag(total\_Revenue) Over( Partition By Category Order By Month) AS Monthly\_Sales\_Comparision 

From CTE)

Select 

Category,Month,Total\_revenue,total\_Revenue-Monthly\_Sales\_Comparision  AS Month\_Over\_Month\_Change

From CTE1

Order By Category ,Month;







**-- 2. Running Total of Revenue by Category** 

Select 

Category ,

Sales\_Date ,

Sum(Price\*Quantity) AS Total\_Revenue ,

Sum(Sum(Price\*Quantity)) 

&nbsp;	Over (Partition BY Category Order BY Sales\_Date) AS Running\_Total

From Sales 

Group By Category ,Sales\_DAte 

Order By Category ,Sales\_DAte ;







**-- 3. Quartile Ranking using NTILE**

With CTE AS (Select Category , 

Sum(Price\*Quantity) AS Total\_Revenue 

From Sales 

Group By Category)

Select Category,Total\_Revenue,

NTILE(4) Over( Order BY Total\_Revenue) AS Ranking 

From CTE ;







**-- 4. Moving Average of Daily Revenue**

Select

Product\_Name,Category,Sales\_Date, 

Round(Avg(Price\*Quantity) 

Over( Order By Sales\_Date Rows Between 6 Preceding and Current Row),0) AS Moving\_Average

From Sales  ;

