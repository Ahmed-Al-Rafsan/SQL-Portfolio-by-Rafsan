/\* 1️⃣ Show all unique categories \*/

SELECT DISTINCT Category

FROM Sales

ORDER BY Category;



/\* 2️⃣ Show total revenue for each category \*/

SELECT Category, SUM(Quantity\*Price) AS Total\_Revenue

FROM Sales

GROUP BY Category

ORDER BY Total\_Revenue;



/\* 3️⃣ Show only categories whose total revenue > 200 \*/

SELECT Category, SUM(Price\*Quantity) AS Total\_Revenue

FROM Sales**\\**

GROUP BY Category

HAVING Total\_Revenue > 200;



/\* 4️⃣ Categories having more than 2 products \*/

/\* Method 1 (Simpler) \*/

SELECT Category, COUNT(Category) AS Category\_Count

FROM Sales

GROUP BY Category

HAVING COUNT(Category) > 2;

/\* Method 2 (Advanced – Subquery) \*/

SELECT Category, Category\_Count

FROM (

&nbsp; SELECT Category, COUNT(Category) AS Category\_Count

&nbsp; FROM Sales

&nbsp; GROUP BY Category

) AS t

HAVING Category\_Count > 2;



/\* 5️⃣ Show unique products \*/

SELECT DISTINCT Product\_Name, Category, Price

FROM Sales

ORDER BY Price;



/\* Bonus: Show product counts by category \*/

SELECT Product\_Name, Category, COUNT(\*) AS Total\_Count

FROM Sales

GROUP BY Product\_Name, Category

ORDER BY Category, Product\_Name;



