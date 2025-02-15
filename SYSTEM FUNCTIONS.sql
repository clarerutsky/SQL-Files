USE [PRODUCT DATABASE]

/******************  STRING OPERATIONS  **********************/
SELECT EnglishProductName  FROM PRODUCTS_DATA
SELECT  EnglishProductName, REPLACE(EnglishProductName, 'Race', 'Racing') AS REPLACED_Output  FROM PRODUCTS_DATA
SELECT  EnglishProductName, reverse(EnglishProductName) AS reverse_name FROM PRODUCTS_DATA
SELECT  EnglishProductName, LEN(EnglishProductName) AS number_of_characters  FROM PRODUCTS_DATA
SELECT  EnglishProductName, UPPER(EnglishProductName) AS UPPERCASE_NAME  FROM PRODUCTS_DATA
SELECT  EnglishProductName, LOWER(EnglishProductName) AS LOWERCASE_NAME  FROM PRODUCTS_DATA
SELECT ltrim ('  SQLserVer')	-- TO TRUNCATE EXTRA SPACES IN GIVEN STRING OUTPUT. LEFT TO THE VALUE
SELECT Rtrim ('SQLserVer    ')	-- TO TRUNCATE EXTRA SPACES IN GIVEN STRING OUTPUT. RIGHT TO THE VALUE
SELECT LEFT(EnglishProductName,3) AS Name FROM PRODUCTS_DATA
SELECT RIGHT(EnglishProductName,3) AS Name FROM PRODUCTS_DATA
SELECT UPPER(LEFT(EnglishProductName,3)) AS TitleCase FROM PRODUCTS_DATA
SELECT SUBSTRING(EnglishProductName, 5, 20) AS EnglishProductName  FROM PRODUCTS_DATA 


-- STUFF(string, start, length, new_string)
-- Delete 1 character from a string, starting in position 13, and then insert " is fun!" in position 13:
SELECT STUFF('SQL Servers', 11, 1, ' is fun!');


SELECT STUFF('SQL Servers', 11, 1, ' is fun!');


-- PARSE() : RETURNS THE RESULT OF THE EXPRESSION, TRANSLATED TO THE REQUESTED DATA TYPE IN SQL SERVER.
SELECT PARSE ('Monday, 13 December 2023' AS datetime2 USING 'en-US') AS Result;


SELECT PARSE ('Jabberwokkie' AS datetime2 USING 'en-US') AS Result;

SELECT PARSE ('12/1/2019' AS datetime2 USING 'en-US') AS Result;



-- TRY_PARSE() : RETURNS THE RESULT OF THE EXPRESSION, TRANSLATED TO THE REQUESTED DATA TYPE, OR NULL IF THE CAST FAILS. 
-- USE TRY_PARSE ONLY FOR CONVERTING FROM STRING TO DATE/TIME AND NUMBER TYPES. 

SELECT TRY_PARSE ('Monday, 13 December 2023' AS datetime2 USING 'en-US') AS Result;


SELECT TRY_PARSE ('Jabberwokkie' AS datetime2 USING 'en-US') AS Result;

SELECT TRY_PARSE ('12/1/2019' AS datetime2 USING 'en-US') AS Result;



-- RETURNS A VALUE CAST TO THE SPECIVIED DATA TYPE IF THE CAST SUCCEEDS. OTHERWISE, RETURNS NULL.
SET DATEFORMAT day;
SELECT TRY_CAST('12/31/2010' AS DATETIME2) AS RESULT;
GO



-- RETURNS A VALUE CAST TO THE SPECIVIED DATA TYPE IF THE CAST SUCCEEDS. OTHERWISE, RETURNS NULL.
SET DATEFORMAT day;
SELECT TRY_COVNERT(DATETIME2, '12/31/2010') AS RESULT;
GO



/*********  DATE AND TIME OPERATIONS *****************/
SELECT DATEPART (Toffset, '2023-05-10 00:00:01.1234567 +05:10')


SELECT 	DATEPART(YEAR, '12:10:30.123')
	, 	DATEPART(month, '12:10:30.123')
	,	DATEPART(day, '12:10:30.123')
	,	DATEPART(dayofyear, '12:10:30.123')
	,	DATEPART(weekday, '12:10:30.123');
	
	
SELECT DATEPART(MILLISECOND, GETDATE()) AS 'MilliSecond'; 
SELECT DATEPART(MICROSECOND, GETDATE()) AS 'MicroSecond'; 
SELECT DATEPART(NANOSECOND, GETDATE())  AS 'NanoSecond';   


SELECT DATEPART(YEAR, 0),  DATEPART(MONTH, 0), DATEPART (day, 0);


SELECT 		DATENAME (year, '12:10:30.123')
		, 	DATENAME (month, '12:10:30.123')
		, 	DATENAME (day, '12:10:30.123')
		, 	DATENAME (dayofyear, '12:10:30.123')
		, 	DATENAME (weekday, '12:10:30.123')


DECLARE @date DATEIMTE = GETDATE();
SELECT EOMONTH(@date) AS 'THIS MONTH';
SELECT EOMONTH(@date, 1) AS 'NEXT MONTH';
SELECT EOMONTH(@date, -1) AS 'LAST MONTH';


SELECT 'SYSDATETIME()  ', SYSDATETIME();
SELECT 'SYSTIMEOFFSET()  ', SYSTIMEOFFSET();
SELECT 'SYSUTCDATETIME()  ', SYSUTCDATETIME();
SELECT 'CURRENT_TIMESTAMP()  ', CURRENT_TIMESTAMP();
SELECT 'GETDATE()  ', GETDATE();
SELECT 'GETUTCDATE()  ', GETUTCDATE();



/* CALENDAR DATE VALUE GENERATION*/
 
create table DimDate
( DateKey int not null primary key,
 [Year] varchar(7), [Month] varchar(7), [Date] date, 
 DateString varchar(10))
go
 

declare @i int, @Date date, @StartDate date, @EndDate date, @DateKey int,
 @DateString varchar(10), @Year varchar(4),
 @Month varchar(7), @Date1 varchar(20)
set @StartDate = '2000-01-01'
set @EndDate = '2020-12-31'
set @Date = @StartDate
 
while @Date <= @EndDate
begin
 set @DateString = convert(varchar(10), @Date, 20)
 set @DateKey = convert(int, replace(@DateString,'-',''))
 set @Year = left(@DateString,4)
 set @Month = left(@DateString, 7)
 insert into DimDate (DateKey, [Year], [Month], [Date], DateString)
 values (@DateKey, @Year, @Month, @Date, @DateString)
 set @Date = dateadd(d, 1, @Date)
end
go
 
select * from DimDate

