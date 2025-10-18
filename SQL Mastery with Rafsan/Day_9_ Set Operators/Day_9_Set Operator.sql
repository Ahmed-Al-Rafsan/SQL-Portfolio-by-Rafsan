use chemist_warehouse;
Select * From Sales;
Select * From Products;
-- 1. Show all product names from both Products and Sales tables (avoid duplicates).
Select Product_Name,Category From Sales 
Union 
Select Product_Name,Category From Products ;

-- 2. Show all product names from both tables, including duplicates.
Select Product_Name,Category From Sales 
Union All
Select Product_Name,Category From Products ;

-- 3. Show all product names that exist in the Products table but were never sold (not present in the Sales table).
Select Product_Name From Products
Where Product_Name Not In ( Select Product_Name From Sales) ;
-- another solution , which is in sales table but not in product table
Select s.Product_Name From Sales as s
Left Join Products as p
On s.Product_Name = p.product_name
Where p.product_name is null ;

-- 4. Show the product names that appear in both Products and Sales.
Select s.Product_Name From Sales as s 
Inner Join Products as p 
On s.product_Name =p.product_Name ;
-- Solution with subquerry 
Select Product_Name From Sales 
Where Product_Name In ( Select Product_Name From Products ) ;