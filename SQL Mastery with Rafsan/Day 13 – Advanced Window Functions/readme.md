# Day 13 – Advanced Window Functions



use chemist\_warehouse;

Select \* From Sales;

Select \* From Products;



**-- 1.Calculate Cumulative Distribution**

With CTE AS (Select 

Product\_Name,Category,

Sum(Price\*Quantity) As Total\_Revenue From Sales Group By Product\_Name,Category) 

Select Product\_Name,Category,

cume\_dist() Over (partition By Category order By Total\_Revenue Desc) AS Cumulative\_Distribution

from CTE ;



**-- 2.Calculate the Percent Rank of each product within its category based on Total\_Revenue.**

With CTE AS (Select 

Product\_Name,Category,

Sum(Quantity\*Price) As Total\_Revenue 

From Sales Group by Product\_Name,Category )

Select Product\_Name,Category,

percent\_rank() Over( Partition By Category Order By Total\_Revenue) AS Pr\_Rnk

From CTE ;



**-- 3.Compute, for each Category–Month: Monthly\_Revenue,**

**-- The first month’s revenue in that category,**

**-- The last month’s revenue in that category .**

With CTE AS ( Select 

Category,

date\_format(Sales\_Date,'%y-%m') AS Months,

Sum(Price\*Quantity) As Monthly\_Total\_Revenue

From Sales Group By category,Months )

Select 

Category,

Months,

Monthly\_Total\_Revenue,

first\_value(Monthly\_Total\_Revenue)

&nbsp;Over ( Partition By Category 

&nbsp;Order By Months 

&nbsp;Rows between unbounded preceding and unbounded following) As First\_Months\_Revenue,

&nbsp;Last\_Value(Monthly\_Total\_Revenue) 

&nbsp;Over ( Partition By Category Order by Months

&nbsp;Rows between Unbounded preceding and unbounded following) As Last\_Months\_Revenue

From CTE ;



**-- 4. For each Category–Month, compute:**

**-- Monthly\_Revenue**

**-- Previous\_Month\_Revenue = LAG(Monthly\_Revenue)**

**-- MoM\_Change = Monthly\_Revenue - Previous\_Month\_Revenue**



With CTE AS (Select 

Category,

date\_format(sales\_date,'%Y-%M') As Months,

Sum(Price\*Quantity) As Monthly\_Revenue

From Sales

Group by Category,Months)

Select 

Category,

Months,

Monthly\_Revenue,

Lag(Monthly\_Revenue) Over( Partition By Category Order By Months) AS Previous\_Month\_Revenue ,

Monthly\_Revenue - Lag(Monthly\_Revenue) Over( Partition By Category Order By Months) AS MoM

From CTE

Order By Category,Months;



**-- 5. For each Category–Month, compute a 3-month moving average of Monthly\_Revenue**

With CTE AS (Select Category , 

date\_format(Sales\_Date,'%Y-%m') As Months ,

Sum(Price \* Quantity) As Monthly\_Revenue 

From Sales

Group By Category,Months)

Select 

Category, Months, MOnthly\_Revenue, 

Avg(MOnthly\_Revenue) Over( Partition By Category Order By Months 

Rows between 2 preceding and current row) AS 3M\_MA

From CTE

Order BY Category, Months ;

