Select * from sales;
/* 1.Show all unique categories */
Select Distinct Category 
From Sales
Order BY Category;

/* 2. Show the total revenue for each category*/
Select Category,
Sum(Quantity*Price) AS Total_Revenue 
From Sales 
Group By Category Order By Total_Revenue ;
/* 3.Show only those categories whose total revenue is greater than 200 */
Select Category ,
Sum(Price*Quantity) AS Total_Revenue 
From Sales 
Group BY Category
Having  Total_Revenue >200;
/* 4. “Show only those categories having more than 2 products.*/
Select Category , Category_Count From (Select Category,
Count(Category) AS Category_Count From Sales Group By Category ) AS t Having Category_Count > 2;
/* 5. Remove duplicate product names and show each name only once */
Select Distinct Product_Name,Category , Price 
From Sales 
Group By Product_Name,Category , Price 
Order BY Price ;