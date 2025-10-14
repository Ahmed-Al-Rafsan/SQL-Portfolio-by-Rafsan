
# Day 6 — SQL JOINS Practice
===



**Practicing INNER, LEFT, RIGHT, and FULL OUTER JOINS using Sales and Products tables.**


use chemist\_warehouse;

Select \* From Sales;

Select \* From Products;



#### /\* 1 Show all products (from both tables) with their supplier names and sales prices \*/

Select p.Product\_Name,s.Price,p.Supplier

From Products As p

Left Join Sales AS s

ON p.Product\_Name=s.Product\_Name;



#### /\* 2 Show all sales even if supplier not found  \*/

Select s.\* , p.Supplier

from Sales As s

Left Join

Products As p

On s.Product\_Name =p.product\_name ;



#### /\* 3 Show all products even if they were never sold \*/

Select s.Product\_Name, s.Category,s.Sales\_date,p.supplier

From Sales As s

Right Join Products As p

On s.Product\_Name=p.Product\_Name;

#### 

#### /\* 4 Show every product and every sale \*/

Select p.Product\_Name,p.Supplier,p.Category,s.Quantity,s.Price,S.sales\_Date

From Sales As s

Left Join

Products As p

On p.Product\_Name=s.Product\_Name

Union

Select p.Product\_Name,p.Supplier,p.Category,s.Quantity,s.Price,S.sales\_Date

From Sales As s

Right Join

Products As p

On p.Product\_Name=s.Product\_Name  ;



#### /\* Show all products that appear in both Sales and Products tables\*/

Select

s.Product\_Name,s.Category,s.Quantity,s.Price,s.sales\_Date,p.supplier

From Sales As s

Inner Join

Products As p

On s.Product\_Name=p.Product\_Name ;

