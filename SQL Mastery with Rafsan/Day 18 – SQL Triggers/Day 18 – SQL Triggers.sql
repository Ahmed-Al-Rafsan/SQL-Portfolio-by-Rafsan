Select* From Sales;
Select * From Products;
ALTER TABLE Sales ADD COLUMN Total DECIMAL(10,2);

-- Task 1: BEFORE INSERT Trigger Goal: Automatically calculate and set the Total column when a new sale is inserted.
Delimiter // 
Create Trigger Auto_Total 
Before Insert On Sales 
For each Row 
Begin 
Set New.Total = New.Price*New.Quantity;
End //
Delimiter ;
-- Examine Trigger
Insert Into Sales (Sales_ID,Product_Name,Category,Quantity,Price,Sales_date)
Values(10029,'Gummies','Vitamin',15,5,'2025-05-15');

Select* From Sales;
Select * From Products;
-- Task 2: BEFORE UPDATE Trigger
-- Goal:
-- Whenever someone edits a sale row and changes Quantity or Price, we don’t want the Total column to become wrong.
Delimiter // 
Create Trigger Update_Trigger_1 
Before Update On Sales 
For Each Row 
Begin 
Set New.Total =New.Quantity*New.Price ;
End //
Delimiter ;
-- Examine Trigger
Update Sales 
Set Quantity =20
Where Sales_ID =10029;

Select* From Sales;
Select * From Products;


-- Task 3: AFTER INSERT Trigger (automatic logging to Sales_Log)
Alter Table Sales Add Column
Action_Time int (20);
Alter Table Sales Drop Column Action_Time ;
Delimiter // 
Create Trigger Action_Time 
After Insert On Sales 
For Each Row 
Begin 
	Insert Into Sales_Log (Product_Name,Action_taken,Action_Time)
    Values ( New.Product_Name,'New Product Added',Now ());
End // 
Delimiter ;

Select* From Sales;
Select * From Products;
-- Task 4: AFTER UPDATE trigger, which will log old vs new values whenever a product’s quantity or price is changed.
Create Table Updated_Sales_Log (
Product_Name Varchar (20),
Prev_Quantity int (10),
New_Quantity int(10),
Prev_Price int(10),
New_Price int(10));

Delimiter // 
Create Trigger tt
After Update On Sales 
For Each Row 
Begin 
Insert Into Updated_Sales_Log ( Product_Name, Prev_Quantity,New_Quantity,Prev_Price,New_Price)
Values(New.Product_Name,old.Quantity,New.Quantity,Old.Price,New.Price) ;
End // 
Delimiter ;
-- Check tt 
Update Sales 
Set Product_Name ='Soap',Quantity =10,Price=2
Where Sales_ID =10005;
Select * from Updated_Sales_Log ;


Select* From Sales;
Select * From Products;

-- Task 5A. BEFORE DELETE trigger
-- Block deletes if rule is violated
-- Business rule: “Don’t allow deleting a sale older than 30 days.”
Delimiter // 
Create Trigger aa
Before Delete On Sales 
For Each Row 
Begin 
If old.Sales_date < ( Current_Date - Interval 30 Day) Then 
 Signal SQLSTate '45000'
 Set Message_text ='Can noy delete' ;
 End If ;
 End // 
 Delimiter ;
 
 -- Task 5B: AFTER DELETE trigger — to log deleted records automatically in a Deleted_Sales_Log
 Create Table Sales_Backup 
 (Product_Name Varchar (20) ,Quantity int(10),Price int (10), Deleted_Time time);
 Delimiter //
 Create Trigger aaa 
 After Delete On Sales 
 For Each Row 
 Begin 
 Insert Into Sales_Backup (Product_Name,Quantity,Price,Deleted_Time)
 Values( old.Product_Name,old.Quantity,old.Price,Now());
 End //
 Delimiter ;
 