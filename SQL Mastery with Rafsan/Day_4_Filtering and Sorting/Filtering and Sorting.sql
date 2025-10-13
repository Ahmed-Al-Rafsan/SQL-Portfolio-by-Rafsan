use chemist_warehouse;
Select * from sales;
/* 1 Show all sales where the quantity sold is greater than 3 */
Select *
From Sales 
Where Quantity > 3;

/* 2. Show all items from the Medicine category, sorted by price from lowest to highest.)*/
Select 
Product_Name, Price
From Sales
Where Category ='medicine' 
Order By Price Asc ;

/* 3️ Show all products priced between 10 and 100 */
Select * 
From Sales 
Where Price between 10 And 100
Order By Price ;

/* 4️ Show all products that are not in the Medicine category. */
Select Product_Name,Category,Price 
From Sales 
Where Category != 'Medicine'
Order by Price ;


/* 5 Show all products whose name starts with the letter ‘P’*/
Select Product_Name, Category, Price 
From Sales 
Where Product_name Like ('P%')
Order By Price ;