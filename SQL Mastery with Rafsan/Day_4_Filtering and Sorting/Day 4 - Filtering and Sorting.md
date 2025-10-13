**/\* 1️⃣ Show all sales where quantity > 3 \*/**

SELECT \* FROM Sales WHERE Quantity > 3;



**/\* 2️⃣ Show all Medicine items sorted by price ASC \*/**

SELECT Product\_Name, Price FROM Sales WHERE Category='Medicine' ORDER BY Price ASC;



**/\* 3️⃣ Show all products priced between 10 and 100 \*/**

SELECT \* FROM Sales WHERE Price BETWEEN 10 AND 100 ORDER BY Price;



**/\* 4️⃣ Show all products not in the Medicine category \*/**

SELECT Product\_Name, Category, Price FROM Sales WHERE Category!='Medicine' ORDER BY Price;



**/\* 5️⃣ Show all products whose name starts with 'P' \*/**

SELECT Product\_Name, Category, Price FROM Sales WHERE Product\_Name LIKE 'P%' ORDER BY Price;



