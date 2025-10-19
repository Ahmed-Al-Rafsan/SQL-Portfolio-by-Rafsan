## **Day 10 - Common Table Expressions (CTE)**



use chemist\_warehouse ;

Select \* from Sales ;

Select \* from Products ;



**-- 1. Create a CTE to show each category and its average price.**

With cte\_Category\_1 AS (

Select Product\_Name,Category,Quantity,Price

From Sales)

Select 

&nbsp;Category,

avg(Price) As Avg\_Price From cte\_Category\_1 Group BY  Category ;



**-- 2.From that CTE, show only categories whose average price > 30.**

WIth Cte\_Category As (

Select Product\_Name,Category,Quantity,Price

From Sales)

Select Category , avg (Price) as Avg\_Price From Cte\_Category

Group By Category

Having Avg\_Price >30;



**-- 3. Create a CTE to find total revenue per product, then show only top 3 products by revenue.**

WIth CTE AS ( 

Select Product\_Name,Category,Sum(Price\*Quantity) AS Total\_Revenue

From Sales

Group By Product\_Name,Category)

Select Category,Total\_Revenue

From CTE Order By Total\_Revenue Desc Limit 3 ;

