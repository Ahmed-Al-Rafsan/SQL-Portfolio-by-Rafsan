# Day 18 – SQL Triggers





Select\* From Sales;

Select \* From Products;

ALTER TABLE Sales ADD COLUMN Total DECIMAL(10,2);



**-- Task 1: BEFORE INSERT Trigger Goal: Automatically calculate and set the Total column when a new sale is inserted.**



Delimiter // 

Create Trigger Auto\_Total 

Before Insert On Sales 

For each Row 

Begin 

Set New.Total = New.Price\*New.Quantity;

End //

Delimiter ;

-- Examine Trigger

Insert Into Sales (Sales\_ID,Product\_Name,Category,Quantity,Price,Sales\_date)

Values(10029,'Gummies','Vitamin',15,5,'2025-05-15');



Select\* From Sales;

Select \* From Products;







**-- Task 2: BEFORE UPDATE Trigger**

**-- Goal:**

**-- Whenever someone edits a sale row and changes Quantity or Price, we don’t want the Total column to become wrong.**



Delimiter // 

Create Trigger Update\_Trigger\_1 

Before Update On Sales 

For Each Row 

Begin 

Set New.Total =New.Quantity\*New.Price ;

End //

Delimiter ;

-- Examine Trigger

Update Sales 

Set Quantity =20

Where Sales\_ID =10029;



Select\* From Sales;

Select \* From Products;





**-- Task 3: AFTER INSERT Trigger (automatic logging to Sales\_Log)**

**Alter Table Sales Add Column**

**Action\_Time int (20);**

**Alter Table Sales Drop Column Action\_Time ;**





Delimiter // 

Create Trigger Action\_Time 

After Insert On Sales 

For Each Row 

Begin 

&nbsp;	Insert Into Sales\_Log (Product\_Name,Action\_taken,Action\_Time)

&nbsp;   Values ( New.Product\_Name,'New Product Added',Now ());

End // 

Delimiter ;



Select\* From Sales;

Select \* From Products;







**-- Task 4: AFTER UPDATE trigger, which will log old vs new values whenever a product’s quantity or price is changed**.





Create Table Updated\_Sales\_Log (

Product\_Name Varchar (20),

Prev\_Quantity int (10),

New\_Quantity int(10),

Prev\_Price int(10),

New\_Price int(10));



Delimiter // 

Create Trigger tt

After Update On Sales 

For Each Row 

Begin 

Insert Into Updated\_Sales\_Log ( Product\_Name, Prev\_Quantity,New\_Quantity,Prev\_Price,New\_Price)

Values(New.Product\_Name,old.Quantity,New.Quantity,Old.Price,New.Price) ;

End // 

Delimiter ;

-- Check tt 

Update Sales 

Set Product\_Name ='Soap',Quantity =10,Price=2

Where Sales\_ID =10005;

Select \* from Updated\_Sales\_Log ;





Select\* From Sales;

Select \* From Products;



**-- Task 5A. BEFORE DELETE trigger**

**-- Block deletes if rule is violated**

**-- Business rule: “Don’t allow deleting a sale older than 30 days.”**







Delimiter // 

Create Trigger aa

Before Delete On Sales 

For Each Row 

Begin 

If old.Sales\_date < ( Current\_Date - Interval 30 Day) Then 

&nbsp;Signal SQLSTate '45000'

&nbsp;Set Message\_text ='Can noy delete' ;

&nbsp;End If ;

&nbsp;End // 

&nbsp;Delimiter ;

&nbsp;

&nbsp;**-- Task 5B: AFTER DELETE trigger — to log deleted records automatically in a Deleted\_Sales\_Log**



&nbsp;Create Table Sales\_Backup 

&nbsp;(Product\_Name Varchar (20) ,Quantity int(10),Price int (10), Deleted\_Time time);

&nbsp;Delimiter //

&nbsp;Create Trigger aaa 

&nbsp;After Delete On Sales 

&nbsp;For Each Row 

&nbsp;Begin 

&nbsp;Insert Into Sales\_Backup (Product\_Name,Quantity,Price,Deleted\_Time)

&nbsp;Values( old.Product\_Name,old.Quantity,old.Price,Now());

&nbsp;End //

&nbsp;Delimiter ;

&nbsp;

