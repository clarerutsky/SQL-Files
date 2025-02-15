/*
JSON (JavaScript Object Notation) is a lightweight data-interchange format. 
It is easy for humans to read and write. It is easy for machines to parse and generate. 
It is based on a subset of the JavaScript Programming Language.

JSON is an open-standard file format used to to transmit any type of data from one platform to another. 
 
Microsoft introduced native support for JSON from SQL Server in version 2016.

*/

USE [PRODUCTDATABASE]

DROP TABLE IF EXISTS SheepCountingWords 
  CREATE TABLE SheepCountingWords
    (
    Number INT NOT NULL,
    Word VARCHAR(40) NOT NULL
    );
  GO


/*
json input data:
 [{
    "number": 11,  "word": "Yan-a-dik"
  }, {
    "number": 12,  "word": "Tan-a-dik"
  }, {
    "number": 13,  "word": "Tethera-dik"
  }, {
    "number": 14,  "word": "Pethera-dik"
  }, {
    "number": 15,  "word": "Bumfit"
  }, {
    "number": 16,  "word": "Yan-a-bumtit"
  }, {
    "number": 17,  "word": "Tan-a-bumfit"
  }, {
    "number": 18,  "word": "Tethera-bumfit"
  }, {
    "number": 19,  "word": "Pethera-bumfit"
  }, {
    "number": 20,  "word": "Figgot"
  }] 
  */

  
  SELECT  Number, Word
      FROM
      OpenJson(
				'[
				{"number": 11,  "word": "Yan-a-dik"}, 
				{"number": 12,  "word": "Tan-a-dik"}, 
				{"number": 13,  "word": "Tethera-dik"}, 
				{"number": 14,  "word": "Pethera-dik"}, 
				{"number": 15,  "word": "Bumfit"}, 
				{"number": 16,  "word": "Yan-a-bumtit"}, 
				{"number": 17,  "word": "Tan-a-bumfit"}, 
				{"number": 18,  "word": "Tethera-bumfit"}, 
				{"number": 19,  "word": "Pethera-bumfit"}, 
				{"number": 20,  "word": "Figgot"}
				] '
			) WITH (Number INT '$.number', Word VARCHAR(30) '$.word')

  
  
  insert into SheepCountingWords (Number, Word)
  SELECT  Number, Word
      FROM
      OpenJson(
				'[
				{"number": 11,  "word": "Yan-a-dik"}, 
				{"number": 12,  "word": "Tan-a-dik"}, 
				{"number": 13,  "word": "Tethera-dik"}, 
				{"number": 14,  "word": "Pethera-dik"}, 
				{"number": 15,  "word": "Bumfit"}, 
				{"number": 16,  "word": "Yan-a-bumtit"}, 
				{"number": 17,  "word": "Tan-a-bumfit"}, 
				{"number": 18,  "word": "Tethera-bumfit"}, 
				{"number": 19,  "word": "Pethera-bumfit"}, 
				{"number": 20,  "word": "Figgot"}
				] '
			) WITH (Number INT '$.number', Word VARCHAR(30) '$.word')


  select * from SheepCountingWords