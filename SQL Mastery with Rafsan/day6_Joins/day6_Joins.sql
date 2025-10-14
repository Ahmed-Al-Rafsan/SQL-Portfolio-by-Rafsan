use chemist_warehouse;
Select * From Sales;
Select * From Products;

/* 1 Show all products (from both tables) with their supplier names and sales prices */
Select p.Product_Name,s.Price,p.Supplier
From Products As p
Left Join Sales AS s 
ON p.Product_Name=s.Product_Name;

/* 2 Show all sales even if supplier not found  */
Select s.* , p.Supplier
from Sales As s 
Left Join 
Products As p
On s.Product_Name =p.product_name ;

/* 3 Show all products even if they were never sold */
Select s.Product_Name, s.Category,s.Sales_date,p.supplier
From Sales As s
Right Join Products As p
On s.Product_Name=p.Product_Name;

/* 4 Show every product and every sale */
Select p.Product_Name,p.Supplier,p.Category,s.Quantity,s.Price,S.sales_Date 
From Sales As s
Left Join 
Products As p
On p.Product_Name=s.Product_Name 
Union 
Select p.Product_Name,p.Supplier,p.Category,s.Quantity,s.Price,S.sales_Date 
From Sales As s
Right Join 
Products As p
On p.Product_Name=s.Product_Name  ;

/* Show all products that appear in both Sales and Products tables*/
Select 
s.Product_Name,s.Category,s.Quantity,s.Price,s.sales_Date,p.supplier
From Sales As s
Inner Join 
Products As p 
On s.Product_Name=p.Product_Name ;
