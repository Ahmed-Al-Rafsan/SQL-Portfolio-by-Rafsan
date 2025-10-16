use chemist_warehouse;
Select * from Sales;
Select * From Products;
/*  List products priced below the minimum price in their category */
Select s.Product_Name,s.Category,s.Price From Sales As s  Where s.Price <
(Select min(Price) As Min From Sales where category=s.category)  ;

-- 1. Show all products whose price is above the global average price of all products.
Select s.* From Sales As s 
 WHere Price > (Select avg(Price)  From Sales) ;
 -- 2 Show all products whose price is below the global minimum price.
 Select * From Sales Where Price < (Select Min(Price) From Sales );
 -- 3. Show products that were sold after the latest sale date in the Denture category.
 Select Product_Name, Category,Sales_date From Sales Where Sales_Date >
 (Select Max(Sales_date) From Sales Where Category ='Denture') ;

 -- 4. Show categories whose average price is greater than the global average price
Select Category,avg(Price) As Avg_Price from sales Group By( Category)
 Having Avg_Price >( Select avg(Price) from Sales  ) ;

-- 5. Show the category (not product) that has the highest total revenue among all categories.
Select t.Category,t.Total_Revenue 
From (Select Category,Sum(Quantity*Price) As Total_Revenue 
From Sales Group By category  Order BY total_Revenue  Desc ) As t 
Limit 1; 
 
-- 6.Show all sales for categories whose total revenue exceeds 200.
Select * From Sales 
Where Category IN ( Select Category From Sales Group BY Category Having Sum(Quantity*Price)>200 );

-- 7. Show all sales for products that exist in the Products table.
Select * From Sales Where Exists (Select * From Products where Products.Product_Name=Sales.Product_Name) ;

-- 8. Show all categories that have at least one product with price below 10
Select distinct Category,Product_Name,Price From Sales AS s 
where Exists ( Select 1 From sales as x  WHere s.category =x.category AND x.price < 10);

-- 9.Show suppliers (from the Products table) that don’t have any sales in the Sales table
Select Supplier From Products as p Where Not Exists ( Select 1 From Sales as s Where s.Product_Name =p.Product_Name);

-- 11. Find the top 3 categories by total revenue
Select t.Category,t.Revenue From ( Select Category , sum( Quantity*Price) As Revenue 
From Sales group by category)  as t Order By t.Revenue Desc Limit 3;

-- 12. Show categories where the average price is greater than 50, using a derived table.
Select t.Category,t.Avg_Price AS Avg_Price from
( Select Category ,avg(price) As Avg_Price from sales Group By  Category Having avg(price) > 50 ) AS t ;

-- 13. Show each category’s total revenue and average price in one result, using a derived table.
Select t.Category,t.Total_Revenue,t.Avg_Price From ( Select Category,sum(price*Quantity) as Total_Revenue ,avg(price) as Avg_Price
From Sales Group By Category ) As t;

-- 14.Create a derived table that gives you the total quantity sold per category, 
and use it to filter out categories with quantity less than 5.
Select t.Category, t.Sold_Quantity From (Select Category,Sum(Quantity) AS Sold_Quantity 
from Sales Group By Category) as t where t.Sold_Quantity <=5;

-- 15.Find the difference between each category’s total revenue and the overall average revenue, using a derived table
Select t.category,
t.TR,
T.TR-(Select avg(price*Quantity) As Avg_Qty From Sales ) As Diff_TR_AR From
( Select Category, Sum(Price*Quantity) As TR From Sales Group By Category) As t ;

-- 16. Find the highest-priced product(s) in each category using a correlated subquery.
Select y.Product_Name, y.Category,y.Price From Sales as y WHere price =
 ( Select Max(Price) From Sales As x  Where x.category=y.category );
 
 -- 18. Find all products whose price is above the average price of their category
 Select y.Product_Name,y.Category,y.Price from Sales As y Where Price > 
 ( Select avg(price) From Sales As x Where x.category=y.category)  ;

-- 19. Find products sold on the latest sale date of their category, using a correlated subquery
Select x.Product_Name From Sales As x  WHere Sales_date 
=( Select Max(Sales_Date) From Sales As y where y.Category=x.Category) Order By Sales_date Desc;

-- 20.Find categories where every product has a price ≥ 10
Select x.Category From Sales AS x WHere 
Not Exists ( Select 1  From Sales As y Where y.category =x.category AND y.Price <10);