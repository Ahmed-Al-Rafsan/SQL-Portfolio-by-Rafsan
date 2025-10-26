# Day\_14\_ Data\_ Cleaning 



use chemist\_warehouse;

Select \* From customers\_dirty ;

CREATE TABLE customers\_dirty (

&nbsp; Customer\_ID INT AUTO\_INCREMENT PRIMARY KEY,

&nbsp; Customer\_Name VARCHAR(50),

&nbsp; Email VARCHAR(100),

&nbsp; Phone VARCHAR(20),

&nbsp; City VARCHAR(50)

);



INSERT INTO customers\_dirty (Customer\_Name, Email, Phone, City) VALUES

('   Rafsan Ahmed  ', '  rafsan @gmail.com  ', '0412345678', 'Melbourne'),

('nisha', NULL, NULL, '  SYDNEY  '),

('   JON DOE', 'jon.doe @gmail.com', '', '  adelaide  '),

('maria', 'maria NULL @yahoo.com', '0456789123', 'HOBART  '),

('  Liam   ', NULL, '  ', ' PERTH '),

('   NULL   ', '   ', NULL, ' '),

('aisha ', 'aisha  @  yahoo.com  ', NULL, 'melBourne'),

(' tania  ', 'tania@gmail.com', 'NULL', '  darwin ');




**-- 1. Return Customer\_ID, Customer\_Name, and a new column called Clean\_Name**

-- where all names are converted to UPPERCASE and extra spaces are removed.

Select 

Ifnull(Customer\_ID,'Unknown') AS Customer\_ID,

ifnull(Trim(Customer\_Name),'Unkonwn') AS Customer\_Name,

Upper(Trim(Customer\_Name)) AS Clean\_Name

From customers\_dirty;




**-- 2. Create a new column Clean\_Email that:**

**-- Removes extra spaces from the start and end of the email**

**-- Removes spaces inside the email (e.g., 'rafsan @gmail.com' → 'rafsan@gmail.com')**

**-- Replaces any 'NULL' text or real NULL with 'NO EMAIL'**

Select 

Customer\_ID,Coalesce(nullif(Upper(Replace(Email,' ','')),'Null'),'No Email') AS Clean\_Email

&nbsp;From customers\_dirty;

&nbsp;

 **-- 3. Using customers\_dirty, return:**

**-- Customer\_ID**

**-- Phone (original value)**

**-- Clean\_Phone where:**

**-- Empty string ('') → treat as NULL**

**-- Text 'NULL' → treat as NULL**

**-- Actual NULL → stays NULL**

**-- Then replace any NULL with 'NO PHONE'** 


Select Customer\_ID,

Coalesce(Nullif(Nullif(Trim(Phone),''),'NULL'),'NO PHONE')

From customers\_dirty;




**-- 4. Write a query to return: Customer\_ID ,Email and a new column Final\_Email which:** 

**-- removes extra spaces inside and outside the email** 

**-- converts text 'NULL' → real NULL**

**-- replaces any NULL with 'NO EMAIL'.**

Select Customer\_ID,Email,

&nbsp;	Coalesce(Nullif(Replace(Trim(Email),' ',''),'NULL'),'No Email') AS Final\_Email

From customers\_dirty ;



