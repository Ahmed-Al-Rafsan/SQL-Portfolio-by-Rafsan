use chemist_warehouse;
Select * from Sales;
Select* from Products ;
/* 1.Show all products with prices greater than the overall average */
Select Product_Name,Price 
From Sales Where Price > (Select  Avg(Price) As Overall_Avg From Sales) ;

/* 2. Show categories whose total revenue is above the average category revenue */

Select Category , Sum(Price*Quantity) As Larger_Total_Rev 
From Sales 
Group By Category
Having Sum(Price*Quantity) >
/* Findout Average Category Revenue*/
(Select Avg( Total_Revenue) As Average_Cat_Rev From 
/* Findout Category Wise Total Revenue */
(Select Sum(Price*Quantity) As Total_Revenue 
From Sales 
Group By Category) As temp_Table  ); 

/*  Task 3 — Top-priced product in each category */
Select s. Category,S.Product_Name,s.Price 
From Sales As s 
Where s.price= (Select Max(Price) From Sales Where Category=s.category);

/* Task 4 — Products Whose Price Is Higher than Their Category’s Average Price */
Select s.Product_Name,s.category,s.Price, (select avg(Price) As Avg_Cat_Price From Sales Where Category =s.category) As Avg_Cat_Price 
From Sales As s 
Where s.Price >
(select avg(Price) As Avg_Cat_Price From Sales Where Category =s.category);

/* Task 5 -Show all categories whose total revenue is greater than 200,
using a subquery in the FROM clause (not HAVING)*/
Select * From 
( Select Category,Sum(Price*Quantity) As Total_Revenue 
From Sales
Group By Category ) As T
where Total_Revenue >200 ;