use chemist_warehouse ;
select * from sales;
select * from products;

-- 1. Find Each Product’s Share of Total Revenue
With CTE AS ( Select Product_Name,Category,
Sum(Quantity*Price) AS Total_Revenue
 From Sales
 Group By Product_Name,Category)
Select  Product_Name, Category,Total_Revenue,
Round(Total_Revenue/sum(Total_Revenue) Over(),2) AS Product_Share
From CTE
order By Product_Share Desc ;

-- 2. Find Each Category’s Share of Total Revenue 
With CTE AS ( Select Category, Sum(Price*Quantity) AS Total_Revenue
From Sales
Group By Category )
Select Category,Round(100 * Total_Revenue/Sum(Total_Revenue) Over () ,2)  As Cat_Share
From CTE ;

-- 3. Running Total of Revenue by Date 
Select Product_Name, Category ,
Sum(Quantity*Price) over( Order By Sales_date) As Running_Total_Rev
From Sales
Order By sales_Date ;

-- 4. Rank Products by Total Revenue
With CTE AS ( 
Select Product_Name,Category,
Sum(Quantity* Price) As Total_Revenue 
From Sales 
Group By Product_Name,Category)
Select 
Product_Name,Category,Total_Revenue,
Rank() Over( Order By Total_Revenue Desc)
From CTE ;
-- 5. Rank products within each category
Select t.Product_Name,t.Category,t.Total_Rev ,
Rank () Over ( Partition By t.Category Order By t.Total_Rev Desc) AS Ranking
From
(Select Product_Name,Category,Sum(Quantity*Price) As Total_Rev 
From Sales 
Group By Product_Name,Category) as t 
;
-- 6. Identify Top Product per Category (Rank = 1)
With CTE AS (select Product_Name,Category,
Sum(Price*Quantity) As Total_Revenue 
From Sales Group By Category  ),
CTE2 AS ( Select Product_Name,Category,Total_Revenue,
Rank () over( Partition BY Category Order BY Total_Revenue Desc) AS Rnk From CTE )
Select  Product_Name,Category,Total_Revenue
From CTE2 WHere rnk=1  ;

-- 7.Compare Product Revenue vs Category Average (with CASE Above/Below)
With CTE AS ( Select 
Category,Sum(Quantity*Price) AS Cat_Revenue 
From Sales 
Group By 
Category),
 CTE1 AS ( Select Category,Avg(Price) AS Cat_Avg
 From Sales 
 Group By Category ),
CTE2 AS ( Select a.Category,a.Cat_Revenue,b.Cat_Avg
 From CTE As a  
 Left Join CTE1 As b 
 ON a.category=b.category )
 Select 
  Category,Cat_Revenue,Cat_Avg,
  Case 
  when Cat_Revenue > Cat_Avg Then ' Good Profit'
  When Cat_Revenue < Cat_Avg Then ' Bad for Business '
  Else ' Nutral' 
  End AS Comparision
  From CTE2 ;
  
  -- 8. Best-Performing Category Overall
  With CTE AS 
  ( Select Category ,
  Sum(Quantity*Price) AS Total_Revenue 
  From Sales 
  Group By Category),
CTE1 AS (Select Category,
  Total_Revenue,
  Rank() over ( Order By Total_Revenue Desc ) As Overall_Ranking
  From CTE ) 
Select 
Category,
Total_Revenue,
Overall_Ranking,
Case 
When Overall_Ranking <= 3 Then 'Best Performing Category'
when Overall_Ranking <= 6 and Overall_Ranking > 3 Then 'Moderate Performing Category'
Else 'Clearance Category'
ENd AS Category_performance
From CTE1;

  