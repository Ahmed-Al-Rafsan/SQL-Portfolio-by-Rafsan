use chemist_warehouse;
Select * From Sales ;
create Table Sales 
( Sales_ID INT Primary Key,
Product_Name Varchar (20),
Category Varchar ( 20),
Quantity INT,
Price Decimal (10,2),
Sales_date Date);
Insert Into Sales Values 
(10001,'Penadol','Medicine',1,15,'2025-10-05'),
(10002,'Volterine','Medicine',5,45,'2025-08-08'),
(10003,'Penadol Rapid','Medicine',5,115,'2025-07-02'),
(10004,'Tooth Paste','Denture',1,4.5,'2025-10-05'),
(10005,'Perfume','Cosmetics',2,150,'2025-10-05'),
(10006,'Band Aid','Medicine',5,18,'2025-10-05'),
(10007,'Chips','Confectionaery',1,6,'2025-8-05'),
(10008,'Deep Heat Patch','Daily Usage',4,16,'2025-07-15'),
(10009,'Pregnancy Kit','Medicine',1,33,'2025-09-12'),
(10010,'Mask','Medicine',4,80,'2025-01-14'),
(10011,'Protein','Suppliment',1,120,'2025-02-15'),
(10012,'Protein Bar','Suppliment',10,130,'2025-04-20'),
(10013,'Vitamin D','Vitamin',2,60,'2025-05-15');
/*Show all products sorted by highest price*/
Select Sales_ID,Product_Name,Category,Quantity,Price,Sales_date
 From Sales Order By Price Desc ;
 /*Show all unique categories */
 Select Distinct Category From Sales;
 /* Show all sales between August and October 20258*/
 Select Sales_ID,Product_Name,Category,Quantity,Price,Sales_date
 From Sales Where Sales_Date Between '2025-08-01' AND '2025-10-31' ;
 /* Show products from categories “Medicine” and “Vitamin”*/
Select * From Sales Where Category In ('Medicine','Vitamin') ;
/*Show all products whose names contain the word “Pro”*/
Select * From Sales Where Product_Name Like 'Pro%';
/*Show all “Medicine” products with price > 50*/
Select * From Sales Where Category ='Medicine' And Price > 50;


