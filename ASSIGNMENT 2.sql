USE [master]
GO

/****** Object:  Database [SkyBarrelBank_UAT]    Script Date: 8/24/2021 8:31:57 PM ******/
CREATE DATABASE [SkyBarrelBank_UAT]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'SkyBarrelBank_UAT', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.OLUREMI\MSSQL\DATA\SkyBarrelBank_UAT.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'SkyBarrelBank_UAT_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.OLUREMI\MSSQL\DATA\SkyBarrelBank_UAT_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [SkyBarrelBank_UAT].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO


--SELECT column_name(s)
--FROM table1
--INNER JOIN table2
--ON table1.column_name = table2.column_name;

Report 1:The Director of Credit Analytics wants a report of ALL borrower who HAVE taken a loan with the bank. (We are only interested in borrowers who have a loan in the LoanSetup table). For each borrower, return the below fields:


SELECT	L.BorrowerID,
		CONCAT((B.BorrowerFirstName), (B.[BorrowerMiddleInitial]), (B.[BorrowerLastName])) AS [BORROWER NAME],
		CONCAT (('*****'),RIGHT(B.TaxPayerID_SSN, 4)) AS SSN,
		ROUND (L.PurchaseAmount, 3 ) AS [PURCHASE AMOUNT (IN THOUSANDS)],
		[YEAR OF PURCHASE] = YEAR (L.PurchaseDate)
	

FROM Borrower AS B
INNER JOIN LoanSetupInformation AS L
ON B.BorrowerID = L.BorrowerID;


Report 1 (B):Generate a similar list to the one above, this time, show all customers, EVEN THOSE WITHOUT LOANS. Return it with similar columns as above

SELECT	L.BorrowerID,
		CONCAT((B.BorrowerFirstName), (B.[BorrowerMiddleInitial]), (B.[BorrowerLastName])) AS [BORROWER NAME],
		CONCAT (('*****'),RIGHT(B.TaxPayerID_SSN, 4)) AS SSN,
		ROUND (L.PurchaseAmount, 3 ) AS [PURCHASE AMOUNT (IN THOUSANDS)],
		[YEAR OF PURCHASE] = YEAR (L.PurchaseDate)
	

FROM [SkyBarrelBank_UAT]
Where LoanNumber>0;

Select * from Borower

Report 2:  Aggregate borrowers by country, and show per country;

SELECT [Citizenship],
       [Total Purchase Amount] = FORMAT (SUM([PurchaseAmount]),'ca'),
	   [AVG Purchase Amount] = FORMAT (AVG ([PurchaseAmount]),'co'),
	   [No. of Borrowers] = COUNT([Borrower]. BorrowerID),
	   [AVERAGE AGE OF BORROWER]=AVG(Datediff(year,DOB,GETDATE())),
	   [AVG LTV] = FORMAT(AVG([LTV]), 'P'),
	   [MIN LTV] = FORMAT(MIN([LTV]), 'P1'),
	   [MAX LTV] = FORMAT(MAX([LTV]), 'P1')
	   FROM [dbo].[Borrower]
	   INNER JOIN [dbo].[LoanSetupInformation]
	   ON [Borrower].[BorrowerID] = [LoanSetupInformation].[BorrowerID]
	   GROUP BY [Citizenship];


	   Report 2 (b):  Aggregate the borrowers by gender ( If the gender is missing or is blank, please replace it with X) and show, per country,
	  
	  
	  SELECT Citizenship,
	   [gender]=COUNT([Gender]),
       [Total Purchase Amount] = FORMAT (SUM([PurchaseAmount])/'10000.000', 'c4'),
	   [AVG Purchase Amount] = FORMAT (AVG ([PurchaseAmount]),'100000.000','c0'),
	   [No. of Borrowers] = COUNT([Borrower]. BorrowerID),
	   [AVERAGE AGE OF BORROWER]=AVG(Datediff(year,DOB,GETDATE())),
	   [AVG LTV] = FORMAT(AVG([LTV]), 'P'),
	   [MIN LTV] = FORMAT(MIN([LTV]), 'P1'),
	   [MAX LTV] = FORMAT(MAX([LTV]), 'P1')
	   FROM [dbo].[Borrower]
	   INNER JOIN [dbo].[LoanSetupInformation]
	   ON [Borrower].[BorrowerID] = [LoanSetupInformation].[BorrowerID]
	   Where Gender In ('M', 'F')
	   GROUP BY [Citizenship];
	  
	  
	  SELECT Citizenship,
	   COUNT( Case when [Gender] ='M'
					then 1 end ) Male,
	   COUNT( Case when [Gender] ='f'
					then 1 end ) Female,
	   COUNT( Case when [Gender] =''
					then 1 end ) 'Gender x';

Report 2 (c):  Aggregate the borrowers by gender (Only for F and M gender) and show, per country,  o)

	   

	   SELECT [Citizenship],
	   [gender]=CHECK ([Male, Female]),
       [Total Purchase Amount] = FORMAT (SUM([PurchaseAmount]),'ca'),
	   [AVG Purchase Amount] = FORMAT (AVG ([PurchaseAmount]),'co'),
	   [No. of Borrowers] = COUNT([Borrower]. BorrowerID),
	   [AVERAGE AGE OF BORROWER]=AVG(Datediff(year,DOB,GETDATE())),
	   [AVG LTV] = FORMAT(AVG([LTV]), 'P'),
	   [MIN LTV] = FORMAT(MIN([LTV]), 'P1'),
	   [MAX LTV] = FORMAT(MAX([LTV]), 'P1')
	   FROM [Borrower]
	   INNER JOIN [LoanSetupInformation]
	   ON [Borrower].[BorrowerID] = [LoanSetupInformation].[BorrowerID]
	   Where Gender In ('M', 'F')
	   GROUP BY [Citizenship];






Report3  Calculate the years to maturity for each loan( Only loans that have a maturity date in the future) 
and then categorize them in bins of years (0-5, 6-10, 11-15, 16-20, 21-25, 26-30, >30). 
Show the number of loans in each bins and the total purchase amount for each bin in billions HINT: SELECT FORMAT(10000457.004, '$0,,,.000B') 

SELECT
	CASE
	   WHEN Year(MaturityDate) - Year(PurchaseDate) <= 5 then '0-5'
	   WHEN Year(MaturityDate) - Year(PurchaseDate) <= 10 then '6-10'
	   WHEN Year(MaturityDate) - Year(PurchaseDate) <= 15 then '11-15'
	   WHEN Year(MaturityDate) - Year(PurchaseDate) <= 20 then '16-20'
	   WHEN Year(MaturityDate) - Year(PurchaseDate) <= 25 then '21-25'
	   WHEN Year(MaturityDate) - Year(PurchaseDate) <= 30 then '26-30'
	   WHEN Year(MaturityDate) - Year(PurchaseDate) > 30 then '>30'
End AS [Year left to Maturity],
COUNT (LoanNumber) AS [ NO. of Loans],
[Total Purchase Amount] = FORMAT(SUM( PurchaseAmount/1000000000), 'c4', 'en-us')+ 'B'
FROM [LoanSetupInformation]
GROUP BY Year(MaturityDate) - Year( PurchaseDate)

SELECT Year(MaturityDate) , Year( PurchaseDate), Year(MaturityDate) - Year( PurchaseDate)
FROM [LoanSetupInformation]
WHERE Year(MaturityDate) - Year( PurchaseDate)>1;

Report Aggregate the Number Loans by Year of Purchase and the Payment frequency description column found in the LU_Payment_Frequency table 

SELECT [Year of Purchase] = Year(setup.PURCHASEDATE)
(PaymentFrequency_Description)
[No. of Loans] = Count(Setup. BorrowerID)
FROM Borrower AS Borr
INNER JOIN [LoanSetupInformation] AS setup
ON borr.BorrowerID = setup.BorrowerID
INNER JOIN SkyBarrelBank_UAT.dbo.LU_PaymentFrequency AS PF
ON SETUP.PaymentFrequency = PF.PaymentFrequency
GROUP BY [PurchaseDate], PF.PaymentFrequency_Description
Order By [PurchaseDate]









