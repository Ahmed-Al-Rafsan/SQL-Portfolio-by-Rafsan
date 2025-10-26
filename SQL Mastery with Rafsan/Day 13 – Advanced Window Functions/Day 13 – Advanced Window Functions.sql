use chemist_warehouse;
Select * From Sales;
Select * From Products;
-- 1.Calculate Cumulative Distribution
With CTE AS (Select 
Product_Name,Category,
Sum(Price*Quantity) As Total_Revenue From Sales Group By Product_Name,Category) 
Select Product_Name,Category,
cume_dist() Over (partition By Category order By Total_Revenue Desc) AS Cumulative_Distribution
from CTE ;

-- 2.Calculate the Percent Rank of each product within its category based on Total_Revenue.
With CTE AS (Select 
Product_Name,Category,
Sum(Quantity*Price) As Total_Revenue 
From Sales Group by Product_Name,Category )
Select Product_Name,Category,
percent_rank() Over( Partition By Category Order By Total_Revenue) AS Pr_Rnk
From CTE ;

-- 3.Compute, for each Category–Month: Monthly_Revenue,
-- The first month’s revenue in that category,
-- The last month’s revenue in that category .
With CTE AS ( Select 
Category,
date_format(Sales_Date,'%y-%m') AS Months,
Sum(Price*Quantity) As Monthly_Total_Revenue
From Sales Group By category,Months )
Select 
Category,
Months,
Monthly_Total_Revenue,
first_value(Monthly_Total_Revenue)
 Over ( Partition By Category 
 Order By Months 
 Rows between unbounded preceding and unbounded following) As First_Months_Revenue,
 Last_Value(Monthly_Total_Revenue) 
 Over ( Partition By Category Order by Months
 Rows between Unbounded preceding and unbounded following) As Last_Months_Revenue
From CTE ;

-- 4. For each Category–Month, compute:
-- Monthly_Revenue
-- Previous_Month_Revenue = LAG(Monthly_Revenue)
-- MoM_Change = Monthly_Revenue - Previous_Month_Revenue

With CTE AS (Select 
Category,
date_format(sales_date,'%Y-%M') As Months,
Sum(Price*Quantity) As Monthly_Revenue
From Sales
Group by Category,Months)
Select 
Category,
Months,
Monthly_Revenue,
Lag(Monthly_Revenue) Over( Partition By Category Order By Months) AS Previous_Month_Revenue ,
Monthly_Revenue - Lag(Monthly_Revenue) Over( Partition By Category Order By Months) AS MoM
From CTE
Order By Category,Months;

-- 5. For each Category–Month, compute a 3-month moving average of Monthly_Revenue
With CTE AS (Select Category , 
date_format(Sales_Date,'%Y-%m') As Months ,
Sum(Price * Quantity) As Monthly_Revenue 
From Sales
Group By Category,Months)
Select 
Category, Months, MOnthly_Revenue, 
Avg(MOnthly_Revenue) Over( Partition By Category Order By Months 
Rows between 2 preceding and current row) AS 3M_MA
From CTE
Order BY Category, Months ;