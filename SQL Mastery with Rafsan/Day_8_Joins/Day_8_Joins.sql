use chemist_warehouse;
Select * From Sales;
Select * From Products;
-- 1. Show all products with their sales quantity (INNER JOIN)
Select p.product_Id,p.Product_Name,s.quantity,s.price, s.sales_date
From products As p 
Inner Join Sales As s 
On p.product_Name=s.product_Name;

-- 2.Show all products even if they were not sold (LEFT JOIN).
Select p.product_Name,p.product_Id,s.sales_date,p.Supplier,s.category,s.price
from products as p 
left join sales as s
on s.product_name =p.product_Name ;

-- 3. Show all sales records, including those where the product information is missing in the Products table.
Select s.sales_Id,s.product_Name,s.category,s.price,s.sales_Date,p.product_ID,p.Supplier
from Sales as s 
left join products as p 
on s.product_name=p.product_name;

-- 4. Show every possible combination of products and sales — even if they don’t match. 
Select s.sales_ID,s.product_Name,s.category,s.quantity,s.price,s.sales_date,p.Product_Id,p.supplier
from sales as s 
left join products as p 
on s.product_Name= p.product_Name 
union 
Select s.sales_ID,s.product_Name,s.category,s.quantity,s.price,s.sales_date,p.Product_Id,p.supplier
from sales as s 
right join products as p 
on s.product_Name= p.product_Name ;

-- 5. List every category from the Products table with: total revenue ,number of sales transactions,
-- If a category has no sales, show 0 for both.
Select 
p.Category,
coalesce(sum(Quantity*Price),0) AS total_revenue,
coalesce(count(Sales_ID),0) As No_Sales_Transactions
From Products As p
Left join Sales as s 
on p.Product_Name =s.Product_Name 
Group By p.category;

-- 6. Show only those categories whose total revenue is greater than 200
Select 
p.category, 
sum(s.Quantity*s.Price) > 200 AS More_Category
From sales as s
Left Join products As p 
on p.product_name=s.product_name
Group By p.category
Having sum(s.price*s.quantity)>200 ;

-- 7.Show only those categories whose average product price
--  (from the Sales table) is higher than the overall average price of all products
Select s.Category,
avg(s.price) As cat_avg_Price 
from sales as s
group by s.category 
Having avg(s.price) > (Select avg(Price) From Sales);

-- 8.Show all products whose price is above their category’s average price
Select s.Product_name, s.category,s.price
 From Sales as s 
where s.price >( Select avg(price) from sales where category=s.category);
