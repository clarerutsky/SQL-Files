
-- EXAMPLE 1:				REPORTS ERROR						
DECLARE @VAR1 INT			-- VARIABLE : A PLACEHOLDER TO STORE DATA IN MEMORY
SET @VAR1 = 'ABC'
SELECT @VAR1 


-- EXAMPLE 2:				REPORTS MESSAGE
BEGIN TRY
DECLARE @VAR1 INT
SET @VAR1 = 'ABC'
SELECT @VAR1 
END TRY
BEGIN CATCH
PRINT 'ERROR DURING BATCH EXECUTION'
END CATCH


-- EXAMPLE 3:				REPORTS ERROR  + REPORTS MESSAGE
BEGIN TRY
DECLARE @VAR1 INT
SET @VAR1 = 'ABC'
SELECT @VAR1 
END TRY
BEGIN CATCH
PRINT 'ERROR DURING SP EXECUTION'
;THROW
END CATCH


-- REQ: ASSUME YOU HAVE 1m ROWS IN THE A TABLE. HOW TO COPY DATA FROM THIS TABLE TO ANOTHER TABLE. 
-- CONDITION: YOU NEED TO EITHER COMPLETELY LOAD THE DATA OR NOTHING OR ALL.
use tempdb 

CREATE TABLE RESERVATION1
(
CRAFT_CODE VARCHAR(30),
NO_OF_SEATS INT,
CLASS VARCHAR(30)
)

INSERT INTO RESERVATION1 VALUES 	('AI01', 11, 'EC'), 	('AI02', 12, 'EC'), 
									('AI03', 13, 'EC'), 	('AI04', 14, 'EC')

SELECT * FROM RESERVATION1


CREATE TABLE RESERVATION2
(
CRAFT_CODE VARCHAR(30),
NO_OF_SEATS INT,
CLASS VARCHAR(30)
)


-- REQ: ASSUME YOU HAVE 1m ROWS IN THE A TABLE. HOW TO COPY DATA FROM THIS TABLE TO ANOTHER TABLE. 
-- CONDITION: YOU NEED TO EITHER COMPLETELY LOAD THE DATA OR NOTHING OR ALL.

-- IMPLEMENTATION STEPS:
-- STEP 1:	CREATE USER DEFINED TABLE DATA TYPE
-- STEP 2:	CREATE PROCEDURE TO ACCEPT TABLE DATA AS INPUT AND COPY DATA TO TARGET TABLE
-- STEP 3:	DEFINE TABLE VARIABLE, INPUT 1ST TABLE DATA INTO THIS TABLE VARIABLE
-- STEP 4:	SUPPLY TABLE VARIABLE AS PARAMETER TO STORED PROCEDURE.

CREATE TYPE tblTypeRsv
AS TABLE 
(
CRAFT_CODE VARCHAR(30),
NO_OF_SEATS INT,
CLASS VARCHAR(30)
)

CREATE PROC spReplicateData (@TVP tblTypeRsv READONLY)			-- TVP : TABLE VALUED PARAMETER
AS
BEGIN			-- TO MARK START OF THE PROCEDURE CODE
BEGIN TRY
BEGIN TRANSACTION
INSERT INTO RESERVATION2 SELECT * FROM @TVP
COMMIT TRANSACTION
END TRY 

BEGIN CATCH 
PRINT  'ERROR DURING TABLE COPY OPERATION.'
ROLLBACK TRANSACTION
END CATCH 
END				-- TO MARK END OF THE PROCEDURE CODE

-- EXECUTING ABOVE STORED PROCEDURE:
DECLARE @TABVAR tblTypeRsv
INSERT INTO @TABVAR SELECT * FROM RESERVATION1
EXEC spReplicateData @TABVAR

-- VERIFY THE RESULT:
SELECT   * FROM RESERVATION2


-- EXAMPLE #2:  OUTPUT PARAMETERS

-- OUTPUT PARAMETERS:	ALSO CALLED "OUT" PARAMETERS. 
-- SUCH PARAMETERS THAT RETURN ONE OR MORE VALUES "FROM" THE GIVEN STORED PROCEDURE.

-- REQUIREMENT 1:		HOW TO REPORT LIST OF ALL RESERVATIONS FOR SEATS ABOVE 10?
SELECT * FROM RESERVATION1 WHERE NO_OF_SEATS > 10


-- REQUIREMENT 2:		HOW TO REPORT LIST OF ALL RESERVATIONS FOR SEATS ABOVE A GIVEN NUMBER?
CREATE PROCEDURE spReportRsvs (@seats int)
AS
SELECT * FROM RESERVATION1 WHERE NO_OF_SEATS > @seats

EXEC spReportRsvs 10


-- REQUIREMENT 3:		HOW TO REPORT NUMBER RESERVATIONS FOR SEATS ABOVE A GIVEN NUMBER?
ALTER PROCEDURE spReportRsvs (@seats int, @RWCOUNT INT OUT)
AS
SELECT @RWCOUNT = COUNT(*) FROM RESERVATION1 WHERE NO_OF_SEATS > @seats


DECLARE @RWCOUNTVAR INT 
EXEC spReportRsvs 10, @RWCOUNTVAR OUT 
SELECT 'THE NUMBER OF RESERVATIONS ARE ' + CONVERT (VARCHAR(30), @RWCOUNTVAR)

DECLARE @RWCOUNTVAR INT 
EXEC spReportRsvs 10, @RWCOUNTVAR OUT 
SELECT 'THE NUMBER OF RESERVATIONS ARE ' + CAST (@RWCOUNTVAR AS VARCHAR(30))




-- TASK 1:  WRITE A PROCEDURE TO REPORT DATA (using above table) IN BELOW FORMAT BASED ON INPUT VALUES?
			-- THERE ARE n RESERVATIONS IN THE TABLE WITH NUMBER OF SEATS ABOVE m
			-- EXAMPLE OUTPUT: 
				-- THERE ARE 4 RESERVATIONS WITH NUMBER OF SEATS ABOVE 1
				-- THERE ARE 7 RESERVATIONS WITH NUMBER OF SEATS ABOVE 2

-- TASK 2:  WRITE A PROCEDURE TO ACCEPT TABLENAME AS PARAMETER AND REPORT LIST OF CONSTRAINTS IN THAT TABLE ?

-- TASK 3:  WRITE A PROCEDURE TO IDENTIFY THE LIST OF DUPLICATE ROWS IN A TABLE?  CLUE:  GROUP BY CHAPTER

-- TASK 4:  WRITE A PROCEDURE TO REMOVE THE DUPLICATED ROWS IN A TABLE?











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

----------------------SOLUTION FROM CHATGPT------------------------------------------------

CREATE PROCEDURE SPSeatReport (@Seated INT) 
AS
BEGIN
Declare @seatCount int;  -- Declaring the variable to store the count
Select  @seatCount = COUNT(*)  from RESERVATION1 Where NO_OF_SEATS > @Seated -- Counting the number of reservations with NumberOfSeats greater than @Seats

print 'THERE ARE ' + cast( @seatCount as varchar(30) ) + ' RESERVATIONS WITH NUMBER OF SEATS ABOVE ' + cast( @Seated as varchar(30))
END
Exec SPSeatReport 2

----------------------SOLUTION 2-----------------------------------------------

-- TASK 2:  WRITE A PROCEDURE TO ACCEPT TABLENAME AS PARAMETER AND REPORT LIST OF CONSTRAINTS IN THAT TABLE ?

Create Database TableValueDB
Drop Database TableValueDB
Use tempdb
Use TableValueDB

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

DROP PROCEDURE SP_Delete_Duplicate

-------------------------------
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

drop table tableData
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

Drop PROCEDURE SP_Duplicate_Rows



-----------------------------------------------------------------------------
-- TASK 4:  WRITE A PROCEDURE TO REMOVE THE DUPLICATED ROWS IN A TABLE?

Create Proc SP_Delete_Duplicate (@countDuplicate int)
As 
Begin
Delete from vw_Duplicate where RowsNumber > @countDuplicate
End
--Execut procedure
Exec SP_Delete_Duplicate @countDuplicate = 1

--display report
Select * from tableData

--Drop PROCEDURE SP_Delete_Duplicate





