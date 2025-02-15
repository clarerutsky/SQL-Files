-- TASK 1:  WRITE A PROCEDURE TO REPORT DATA (using above table) IN BELOW FORMAT BASED ON INPUT VALUES?
			-- THERE ARE n RESERVATIONS IN THE TABLE WITH NUMBER OF SEATS ABOVE m
			-- EXAMPLE OUTPUT: 
				-- THERE ARE 4 RESERVATIONS WITH NUMBER OF SEATS ABOVE 1
				-- THERE ARE 7 RESERVATIONS WITH NUMBER OF SEATS ABOVE 2

-- TASK 2:  WRITE A PROCEDURE TO ACCEPT TABLENAME AS PARAMETER AND REPORT LIST OF CONSTRAINTS IN THAT TABLE ?

-- TASK 3:  WRITE A PROCEDURE TO IDENTIFY THE LIST OF DUPLICATE ROWS IN A TABLE?  CLUE:  GROUP BY CHAPTER

-- TASK 4:  WRITE A PROCEDURE TO REMOVE THE DUPLICATED ROWS IN A TABLE?






Create Database TableValueDB
Use TableValueDB





----------------------SOLUTION 1-----------------------------------------------

CREATE PROCEDURE  SPListSeat (@Seats INT, @countOut INT OUT)
as 
Select  @countOut = COUNT(*)  from RESERVATION1 Where NO_OF_SEATS > @Seats

Declare @countOutVarchar1 INT
Exec SPListSeat 1, @countOutVarchar1 OUT
Select 'THERE ARE ' + cast(@countOutVarchar1 AS varchar(40)) + ' RESERVATIONS WITH NUMBER OF SEATS ABOVE 1 ' 
-------------------
Declare @countOutVarchar2 INT
Exec SPListSeat 11, @countOutVarchar2 OUT
Select 'THERE ARE ' + cast(@countOutVarchar2 AS varchar(40)) + ' RESERVATIONS WITH NUMBER OF SEATS ABOVE 2 ' 

Drop PROCEDURE SPListSeat


----------------------SOLUTION 2-----------------------------------------------

-- TASK 2:  WRITE A PROCEDURE TO ACCEPT TABLENAME AS PARAMETER AND REPORT LIST OF CONSTRAINTS IN THAT TABLE ?


Create Table  tableValueConst(
	tblKey INT Primary Key,
	Name varchar(60),
	Gender varchar(10) NOT NULL CHECK(Gender IN ('F','M','OTHER')) default 'F',
	Age INT CHECK(Age >= 18),
	Salary bigint Not Null Default 2000,
	Location varchar(30),
	ResumeDate DATE,
	Bonus decimal NOT NULL default 13.7

	
)


CREATE TYPE TvalueParameter
as Table
(

    tblKey INT Primary Key,
	Name varchar(60),
	Gender varchar(10) NOT NULL CHECK(Gender IN ('F','N','OTHER')),
	Age INT CHECK(Age >= 18),
	Salary bigint Not Null Default 2000,
	Location varchar(30),
	ResumeDate DATE,
	Bonus decimal NOT NULL default 13.7
	
)


CREATE PROCEDURE SP_tableValueConst(@TVP TvalueParameter READONLY)
AS
BEGIN
BEGIN TRY
BEGIN TRANSACTION
Select CONSTRAINT_NAME, CONSTRAINT_TYPE from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where TABLE_NAME = 'tableValueConst'
COMMIT TRANSACTION
END TRY
BEGIN CATCH
Print 'Contraints Not Found '
ROLLBACK TRANSACTION
END CATCH
END

----
Declare @tableV TvalueParameter
Exec SP_tableValueConst  @tableV


-------------------------------
----------------------SOLUTION 3-----------------------------------------------


-- TASK 3:  WRITE A PROCEDURE TO IDENTIFY THE LIST OF DUPLICATE ROWS IN A TABLE?  CLUE:  GROUP BY CHAPTER

Create Table  tableData(
	tblKey INT NOT NULL,
	Name varchar(60),
	Gender varchar(10) NOT NULL CHECK(Gender IN ('F','M','OTHER')) default 'F',
	Age INT CHECK(Age >= 18),
	Salary bigint Not Null Default 2000,
	Location varchar(30),
	ResumeDate DATE,
	Bonus decimal NOT NULL default 13.7

	
)
Insert into tableData Values( 23,'John Amar' ,'F' , 34,2800,'London','2017-04-07',16.3),
( 25,'Smith Amara' ,'M' , 30,3800,'London','2014-04-07',14.0),
( 23,'John Amar' ,'F' , 34,2800,'London','2017-04-09',16.3),
( 21,'Loveth Haige' ,'F' , 28,2800,'Berlin','2017-04-07',15.3),
( 56,'Ben Ben' ,'M' , 42,2200,'Berlin','2019-04-07',17.3),
( 42,'Geophy Donwe' ,'M' , 28,3000,'Greenwood','2019-04-07',14.3),
( 23,'John Amar' ,'M' , 34,2800,'London','2017-04-07',15.3),
( 24,'Martha Marve' ,'F' , 32,4500,'Berlin','2014-04-07',14.3),
( 23,'John Amar' ,'F' , 34,2800,'London','2017-04-07',15.3),
( 56,'Ben Ben' ,'M' , 42,2200,'Berlin','2019-04-07',17.3),
( 56,'Ben Ben' ,'M' , 42,2200,'Berlin','2019-04-07',17.3),
( 21,'Loveth Haige' ,'F' , 28,2800,'Berlin','2017-04-07',15.3)

Select * from tableData

----------TVP------
CREATE TYPE TParameter
as Table
(

    tblKey INT NULL,
	Name varchar(60),
	Gender varchar(10) NOT NULL CHECK(Gender IN ('F','N','OTHER')),
	Age INT CHECK(Age >= 18),
	Salary bigint Not Null Default 2000,
	Location varchar(30),
	ResumeDate DATE,
	Bonus decimal NOT NULL default 13.7
	
)

--------------CREATE PROCEDURE------------
Create Proc SP_Duplicate_Rows(@TVP TvalueParameter READONLY)
as 
begin
begin try
begin transaction
Select * from vw_Duplicate where RowsNumber > 1 
commit transaction
end try
begin catch
print 'No Duplicate Found'
Rollback transaction
end catch
end

Create view vw_Duplicate
as
select *, ROW_NUMBER() over(partition by tblKey, Location order by tblKey, Location) as RowsNumber from tableData

Declare @varDuplicate TvalueParameter
Exec SP_Duplicate_Rows @varDuplicate




-----------------------------------------------------------------------------
----------------------SOLUTION 4-----------------------------------------------
-- TASK 4:  WRITE A PROCEDURE TO REMOVE THE DUPLICATED ROWS IN A TABLE?

Create Proc SP_Delete_Duplicate (@countDuplicate int)
As 
Begin
Delete from vw_Duplicate where RowsNumber > @countDuplicate
End
--Execut procedure
Exec SP_Delete_Duplicate @countDuplicate = 1

--display table data
Select * from tableData
