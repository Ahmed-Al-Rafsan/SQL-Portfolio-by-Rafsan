## **Day-11 Window\_Function**



use chemist\_warehouse ;

select \* from sales;

select \* from products;



**-- 1. Find Each Product’s Share of Total Revenue**

With CTE AS ( Select Product\_Name,Category,

Sum(Quantity\*Price) AS Total\_Revenue

&nbsp;From Sales

&nbsp;Group By Product\_Name,Category)

Select  Product\_Name, Category,Total\_Revenue,

Round(Total\_Revenue/sum(Total\_Revenue) Over(),2) AS Product\_Share

From CTE

order By Product\_Share Desc ;



**-- 2. Find Each Category’s Share of Total Revenue** 

With CTE AS ( Select Category, Sum(Price\*Quantity) AS Total\_Revenue

From Sales

Group By Category )

Select Category,Round(100 \* Total\_Revenue/Sum(Total\_Revenue) Over () ,2)  As Cat\_Share

From CTE ;



**-- 3. Running Total of Revenue by Date** 

Select Product\_Name, Category ,

Sum(Quantity\*Price) over( Order By Sales\_date) As Running\_Total\_Rev

From Sales

Order By sales\_Date ;



**-- 4. Rank Products by Total Revenue**

With CTE AS ( 

Select Product\_Name,Category,

Sum(Quantity\* Price) As Total\_Revenue 

From Sales 

Group By Product\_Name,Category)

Select 

Product\_Name,Category,Total\_Revenue,

Rank() Over( Order By Total\_Revenue Desc)

From CTE ;



**-- 5. Rank products within each category**

Select t.Product\_Name,t.Category,t.Total\_Rev ,

Rank () Over ( Partition By t.Category Order By t.Total\_Rev Desc) AS Ranking

From

(Select Product\_Name,Category,Sum(Quantity\*Price) As Total\_Rev 

From Sales 

Group By Product\_Name,Category) as t 

;



**-- 6. Identify Top Product per Category (Rank = 1)**

With CTE AS (select Product\_Name,Category,

Sum(Price\*Quantity) As Total\_Revenue 

From Sales Group By Category  ),

CTE2 AS ( Select Product\_Name,Category,Total\_Revenue,

Rank () over( Partition BY Category Order BY Total\_Revenue Desc) AS Rnk From CTE )

Select  Product\_Name,Category,Total\_Revenue

From CTE2 WHere rnk=1  ;



**-- 7.Compare Product Revenue vs Category Average (with CASE Above/Below)**

With CTE AS ( Select 

Category,Sum(Quantity\*Price) AS Cat\_Revenue 

From Sales 

Group By 

Category),

&nbsp;CTE1 AS ( Select Category,Avg(Price) AS Cat\_Avg

&nbsp;From Sales 

&nbsp;Group By Category ),

CTE2 AS ( Select a.Category,a.Cat\_Revenue,b.Cat\_Avg

&nbsp;From CTE As a  

&nbsp;Left Join CTE1 As b 

&nbsp;ON a.category=b.category )

&nbsp;Select 

&nbsp; Category,Cat\_Revenue,Cat\_Avg,

&nbsp; Case 

&nbsp; when Cat\_Revenue > Cat\_Avg Then ' Good Profit'

&nbsp; When Cat\_Revenue < Cat\_Avg Then ' Bad for Business '

&nbsp; Else ' Nutral' 

&nbsp; End AS Comparision

&nbsp; From CTE2 ;

&nbsp; 

&nbsp; **-- 8. Best-Performing Category Overall**

&nbsp; With CTE AS 

&nbsp; ( Select Category ,

&nbsp; Sum(Quantity\*Price) AS Total\_Revenue 

&nbsp; From Sales 

&nbsp; Group By Category),

CTE1 AS (Select Category,

&nbsp; Total\_Revenue,

&nbsp; Rank() over ( Order By Total\_Revenue Desc ) As Overall\_Ranking

&nbsp; From CTE ) 

Select 

Category,

Total\_Revenue,

Overall\_Ranking,

Case 

When Overall\_Ranking <= 3 Then 'Best Performing Category'

when Overall\_Ranking <= 6 and Overall\_Ranking > 3 Then 'Moderate Performing Category'

Else 'Clearance Category'

ENd AS Category\_performance

From CTE1;



&nbsp; 

