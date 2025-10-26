use chemist_warehouse;
Select * From customers_dirty ;
CREATE TABLE customers_dirty (
  Customer_ID INT AUTO_INCREMENT PRIMARY KEY,
  Customer_Name VARCHAR(50),
  Email VARCHAR(100),
  Phone VARCHAR(20),
  City VARCHAR(50)
);

INSERT INTO customers_dirty (Customer_Name, Email, Phone, City) VALUES
('   Rafsan Ahmed  ', '  rafsan @gmail.com  ', '0412345678', 'Melbourne'),
('nisha', NULL, NULL, '  SYDNEY  '),
('   JON DOE', 'jon.doe @gmail.com', '', '  adelaide  '),
('maria', 'maria NULL @yahoo.com', '0456789123', 'HOBART  '),
('  Liam   ', NULL, '  ', ' PERTH '),
('   NULL   ', '   ', NULL, ' '),
('aisha ', 'aisha  @  yahoo.com  ', NULL, 'melBourne'),
(' tania  ', 'tania@gmail.com', 'NULL', '  darwin ');

-- 1. Return Customer_ID, Customer_Name, and a new column called Clean_Name
-- where all names are converted to UPPERCASE and extra spaces are removed.
Select 
Ifnull(Customer_ID,'Unknown') AS Customer_ID,
ifnull(Trim(Customer_Name),'Unkonwn') AS Customer_Name,
Upper(Trim(Customer_Name)) AS Clean_Name
From customers_dirty;

-- 2. Create a new column Clean_Email that:
-- Removes extra spaces from the start and end of the email
-- Removes spaces inside the email (e.g., 'rafsan @gmail.com' → 'rafsan@gmail.com')
-- Replaces any 'NULL' text or real NULL with 'NO EMAIL'
Select 
Customer_ID,Coalesce(nullif(Upper(Replace(Email,' ','')),'Null'),'No Email') AS Clean_Email
 From customers_dirty;
 
 -- 3. Using customers_dirty, return:
-- Customer_ID
-- Phone (original value)
-- Clean_Phone where:
-- Empty string ('') → treat as NULL
-- Text 'NULL' → treat as NULL
-- Actual NULL → stays NULL
-- Then replace any NULL with 'NO PHONE' 
Select Customer_ID,
Coalesce(Nullif(Nullif(Trim(Phone),''),'NULL'),'NO PHONE')
From customers_dirty;

-- 4. Write a query to return: Customer_ID ,Email and a new column Final_Email which: 
-- removes extra spaces inside and outside the email 
-- converts text 'NULL' → real NULL
-- replaces any NULL with 'NO EMAIL'.
Select Customer_ID,Email,
	Coalesce(Nullif(Replace(Trim(Email),' ',''),'NULL'),'No Email') AS Final_Email
From customers_dirty ;
