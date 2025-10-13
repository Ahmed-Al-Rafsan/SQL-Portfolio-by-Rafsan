use chemist_warehouse;
Select * From Sales;
/*Find the total revenue generated from all sales*/
Select 
round(Sum(Quantity*Price)) AS Total_Sales_Revenue
 From Sales ;
 
/* 2️ Calculate the total revenue for each category*/
Select Category,
Sum(Quantity*Price) As Total_Revenue
From Sales
Group BY Category ;

/* 3️ Find the average product price per category.*/
Select category,
round(Avg(Price)) As Average_Price 
From Sales
Group By Category;

/* 4 Show the total number of sales transactions for each category */
Select Category,
Count(*) AS Total_No_Of_Sales_Transaction
From Sales 
Group By Category ;

/* Identify the highest and lowest product price in the entire dataset */
Select
Max(Price) As Highest_Price,
Min(Price) As Lowest_Price
From Sales ;


/* Show only the categories whose total revenue exceeds $200 */
Select 
Category ,
Sum(Quantity*Price) AS Revenue 
From Sales 
Group By Category 
Having Revenue > 200 Order by Revenue Desc ;

/*Display the categories in descending order of total revenue*/
Select Category ,
Sum(Price* Quantity) As Total_Revenue 
From Sales
Group BY Category Order BY Total_Revenue Desc;

/* Find the average quantity sold per category */
Select Category,
Round(Avg(Quantity)) As Avg_Quantity 
From Sales 
Group By Category;

/* Count how many different products were sold in each category */
Select 
Category ,
Count(Distinct(Product_Name)) AS Product_Variety
From Sales 
Group By Category ;

/*Find which single category contributed the highest total revenue. */
Select Category,
Round(Sum(Quantity*Price)) AS Highest_Contribution
From Sales 
Group By Category 
Order By Highest_Contribution Desc;