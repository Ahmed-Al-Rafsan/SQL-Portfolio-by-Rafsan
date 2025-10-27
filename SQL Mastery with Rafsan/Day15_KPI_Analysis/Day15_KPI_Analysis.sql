-- Task 1 — Calculate Total Revenue and Total Cost
-- For each product, show:
-- Product_Name | Total_Revenue | Total_Cost

WITH CTE1 AS (
    SELECT 
        Product_Name,
        SUM(Quantity * Price) AS Total_Revenue
    FROM Sales
    GROUP BY Product_Name
),
CTE2 AS (
    SELECT 
        t.Product_Name,
        SUM(t.Quantity * t.Cost) AS Total_Cost
    FROM (
        SELECT 
            s.Product_Name,
            s.Quantity,
            p.Cost
        FROM Sales AS s
        LEFT JOIN Products AS p 
            ON s.Product_Name = p.Product_Name
    ) AS t
    GROUP BY t.Product_Name
)
SELECT 
    s.Product_Name,
    s.Total_Revenue,
    p.Total_Cost
FROM CTE1 AS s
INNER JOIN CTE2 AS p 
    ON s.Product_Name = p.Product_Name;

-- Task 2 — Calculate Profit and Profit Margin per Product
-- Product_Name | Total_Revenue | Total_Cost | Profit | Profit_Margin_Percentage

SELECT 
    t2.Product_Name,
    COALESCE(t2.Total_Cost, 'Unknown') AS Total_Cost,
    t2.Total_Revenue,
    COALESCE(t2.Profit, 'Unknown') AS Profit,
    COALESCE((t2.Profit / t2.Total_Revenue) * 100, 'Unknown') AS Profit_Margin_Percentage
FROM (
    SELECT 
        t1.Product_Name,
        t1.Total_Revenue,
        t1.Total_Cost,
        (t1.Total_Revenue - t1.Total_Cost) AS Profit
    FROM (
        WITH CTE1 AS (
            SELECT 
                Product_Name,
                SUM(Price * Quantity) AS Total_Revenue
            FROM Sales
            GROUP BY Product_Name
        ),
        CTE2 AS (
            SELECT 
                t.Product_Name,
                SUM(t.Quantity * t.Cost) AS Total_Cost
            FROM (
                SELECT 
                    s.Product_Name,
                    s.Quantity,
                    p.Cost
                FROM Sales AS s
                INNER JOIN Products AS p 
                    ON s.Product_Name = p.Product_Name
            ) AS t
            GROUP BY t.Product_Name
        )
        SELECT 
            c1.Product_Name,
            c1.Total_Revenue,
            c2.Total_Cost
        FROM CTE1 AS c1
        INNER JOIN CTE2 AS c2 
            ON c1.Product_Name = c2.Product_Name
    ) AS t1
) AS t2;
Select* From Sales;
Select * From Products;
-- Task 3.1 For each category, calculate the total monthly revenue.
-- Show: Category ,Month (format as YYYY-MM),Total_Monthly_Revenue

Select 
Category , 
Date_Format(Sales_date,'%Y-%m') AS Month,
Sum( Quantity*Price) As Monthly_Revenue 
From Sales 
Group By Category,Month;

-- Task 3.2 — Add Previous Month’s Revenue
Select 
t.Category,t.Month,t.Monthly_Revenue,
ifnull(Lag (Monthly_Revenue) Over( Partition By Category order By t.Month),'First Month') AS Previous_Month_Revenue
From
(Select 
Category , 
Date_Format(Sales_date,'%Y-%m') AS Month,
Sum( Quantity*Price) As Monthly_Revenue 
From Sales 
Group By Category,Month) AS t;

	-- Task 3.3 — Month-over-Month Growth %
	With CTE AS (Select 
	t.Category,t.Month,t.Monthly_Revenue,
	ifnull(Lag (Monthly_Revenue) Over( Partition By Category order By t.Month),'First Month') AS Previous_Month_Revenue
	From
	(Select 
	Category , 
	Date_Format(Sales_date,'%Y-%m') AS Month,
	Sum( Quantity*Price) As Monthly_Revenue 
	From Sales 
	Group By Category,Month) AS t)
	Select 
	Category,Month,Monthly_Revenue,Previous_Month_Revenue,
	Round(ifnull(((Monthly_Revenue-Previous_Month_Revenue)/Previous_Month_Revenue)*100,'First Month'),2) AS MOM_Growth_Per
	From CTE;
    Select * From Sales;
    Select * From Products;
-- Task 4 — Profitability Ranking by Category.
-- What it does: Calculates Total_Revenue per Category
-- Calculates Total_Cost per Category (using Cost from Products)
-- Calculates Profit = Revenue - Cost
-- Ranks categories by Profit (1 = most profitable)
WIth CTE AS (Select 
t.Product_Name,t.Category,t.Revenue,t.Cost,
(t.Revenue-t.Cost) AS Profit
From
(Select
	s.Product_Name,s.Category,
	Sum(Quantity*Price) Over (Partition By Product_Name) As Revenue,
	p.Cost
From Sales AS s
	Inner Join Products AS p
	On s.Product_Name=p.Product_Name) AS t)
  Select  
  Product_Name,Category,Revenue,Cost, Profit,
  dense_rank () Over(Order BY Profit Desc)
  From CTE;
  -- Calculates Total_Revenue per Category
Select 
Category,
Sum(Quantity*Price) AS Total_Revenue 
From Sales 
Group BY Category;
Select* From Sales;
Select * From Products;
-- Calculates Total_Cost per Category (using Cost from Products)
Select 
t.Category,
Sum(t.Quantity*t.cost) As Total_Cost
From 	
    (Select s.Category,s.Quantity,p.cost
	from sales as s 
	Inner Join Products as p 
	On s.Product_Name=p.Product_Name) AS t
Group By t.Category ;