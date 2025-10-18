**Day 9 SET Operators**



use chemist\_warehouse;

Select \* From Sales;

Select \* From Products;

**-- 1. Show all product names from both Products and Sales tables (avoid duplicates).**

Select Product\_Name,Category From Sales 

Union 

Select Product\_Name,Category From Products ;



**-- 2. Show all product names from both tables, including duplicates.**

Select Product\_Name,Category From Sales 

Union All

Select Product\_Name,Category From Products ;



**-- 3. Show all product names that exist in the Products table but were never sold (not present in the Sales table).**

Select Product\_Name From Products

Where Product\_Name Not In ( Select Product\_Name From Sales) ;

**-- Another solution , which is in sales table but not in product table**

Select s.Product\_Name From Sales as s

Left Join Products as p

On s.Product\_Name = p.product\_name

Where p.product\_name is null ;



**-- 4. Show the product names that appear in both Products and Sales.**

Select s.Product\_Name From Sales as s 

Inner Join Products as p 

On s.product\_Name =p.product\_Name ;

**-- Solution with subquerry** 

Select Product\_Name From Sales 

Where Product\_Name In ( Select Product\_Name From Products ) ;

