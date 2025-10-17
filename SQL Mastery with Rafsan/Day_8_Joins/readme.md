## **Day\_8 \_ Joins**



use chemist\_warehouse;

Select \* From Sales;

Select \* From Products;



-- 1. Show all products with their sales quantity (INNER JOIN)

Select p.product\_Id,p.Product\_Name,s.quantity,s.price, s.sales\_date

From products As p 

Inner Join Sales As s 

On p.product\_Name=s.product\_Name;



-- 2.Show all products even if they were not sold (LEFT JOIN).

Select p.product\_Name,p.product\_Id,s.sales\_date,p.Supplier,s.category,s.price

from products as p 

left join sales as s

on s.product\_name =p.product\_Name ;



-- 3. Show all sales records, including those where the product information is missing in the Products table.

Select s.sales\_Id,s.product\_Name,s.category,s.price,s.sales\_Date,p.product\_ID,p.Supplier

from Sales as s 

left join products as p 

on s.product\_name=p.product\_name;



-- 4. Show every possible combination of products and sales — even if they don’t match. 

Select s.sales\_ID,s.product\_Name,s.category,s.quantity,s.price,s.sales\_date,p.Product\_Id,p.supplier

from sales as s 

left join products as p 

on s.product\_Name= p.product\_Name 

union 

Select s.sales\_ID,s.product\_Name,s.category,s.quantity,s.price,s.sales\_date,p.Product\_Id,p.supplier

from sales as s 

right join products as p 

on s.product\_Name= p.product\_Name ;



-- 5. List every category from the Products table with: total revenue ,number of sales transactions,

-- If a category has no sales, show 0 for both.

Select 

p.Category,

coalesce(sum(Quantity\*Price),0) AS total\_revenue,

coalesce(count(Sales\_ID),0) As No\_Sales\_Transactions

From Products As p

Left join Sales as s 

on p.Product\_Name =s.Product\_Name 

Group By p.category;



-- 6. Show only those categories whose total revenue is greater than 200

Select 

p.category, 

sum(s.Quantity\*s.Price) > 200 AS More\_Category

From sales as s

Left Join products As p 

on p.product\_name=s.product\_name

Group By p.category

Having sum(s.price\*s.quantity)>200 ;



-- 7.Show only those categories whose average product price

--  (from the Sales table) is higher than the overall average price of all products

Select s.Category,

avg(s.price) As cat\_avg\_Price 

from sales as s

group by s.category 

Having avg(s.price) > (Select avg(Price) From Sales);



-- 8.Show all products whose price is above their category’s average price

Select s.Product\_name, s.category,s.price

&nbsp;From Sales as s 

where s.price >( Select avg(price) from sales where category=s.category);



