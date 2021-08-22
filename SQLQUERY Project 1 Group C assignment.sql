USE [UNION BANK]
GO

/****** Object:  Schema [dbo]    Script Date: 8/17/2021 9:18:43 PM ******/
CREATE SCHEMA [dbo]
GO


Create Table CalendarTable (CalendarTable_CalendarDate datetime null);


Create Table US_ZipCodes (IsSurrogateKey int not null,
Zip varchar (5) not null,
Latitude float null,
Longitude float null,
City varchar (255) null,
state_id char (2) null,
population int null,
density decimal (18, 0) null,
county_fips varchar (10) null,
county_name varchar (255) null,
county_name_all varchar (255) null,
County_fips_all varchar (50) null,
timezone varchar (255) null,
CreateDate datetime not null);



Alter table US_ZipCodes
Add constraint CHK_US_ZipCodes_CreateDate Default (Getdate()) FOR CreateDate;
GO

Alter table US_ZipCodes
Add Constraint PK_US_ZipCodes_IsSurrogateKey Primary key (IsSurrogateKey);
Go

Alter table US_ZipCodes
Add constraint UC_US_ZipCodes UNIQUE (ZIP);
GO

Create Table State (StateID char (2) not null,
stateName varchar (255) not null,
CreateDate datetime not null);
GO

Alter Table State
Add constraint PK_State_StateID Primary Key (StateID);
GO

Alter table State
Add constraint CHK_State_CreateDate Default (Getdate()) FOR CreateDate;
GO

Alter table State
Add constraint UC_State UNIQUE (StateName);
GO

There is no underwriterID table to create FOREIGN KEY





/****** Object:  Schema [Loan]    Script Date: 8/17/2021 8:49:50 PM ******/
CREATE SCHEMA [Loan]
GO

Create table Loansetupinformation (isSurrogateKey int not null,
 LoanNumber varchar (10) not null,
 PurchaseAmount Numeric (18, 2) not null,
 PurchaseDAte datetime not null,
 LoanTerm int not null,
 BorrowerID int not null,
 UnderwriterID int not null,
 ProductID Char (2) not null,
 InterestRate decimal (3, 2) not null,
 PaymentFrequency int not null,
 ApprasalValue numeric (18,2) not null,
CreateDate datetime not null,
 LTV decimal (4,2) not null,
 FirstInterestpaymentDate datetime null,
 MaturityDate datetime not null);

 Alter table Loansetupinformation
 Add Constraint CHK_Loansetupinformation_LoanTerm CHECK ((LoanTerm =35) or (LoanTerm = 30) or (LoanTerm = 15) or (LoanTerm = 10));

 Alter table Loansetupinformation
 Add Constraint CHK_Loansetupinformation_InterestRate CHECK (InterestRate BETWEEN 0.01 AND 0.30);

 or

 Alter table Loansetupinformation
 Add Constraint CHK_Loansetupinformation_InterestRate CHECK (InterestRate >= 0.01 AND InterestRate <=0.30);




 Alter table Loansetupinformation
 Add Constraint CHK_Loansetupinformation_CreateDate Default (Getdate()) FOR CreateDate;
 
 Alter table Loansetupinformation
 Add constraint FT_BorrowerID
 FOREIGN KEY (BorrowerID) References BorrowerTable (BorrowerID);

 Alter table Loansetupinformation
 Add constraint FT_PaymentFrequency
 FOREIGN KEY (PaymentFrequency) References LU_PaymentFrequency (PaymentFrequency);

 Alter table Loansetupinformation
 Add constraint FT_UnderwriterID
 FOREIGN KEY (UnderwriterID) References UnderwriterID (UnderwriterID);

 THERE"S NO UNDERWRITERID TABLE

 Alter Table Loansetupinformation
Add constraint PK_Loansetupinformation_LoanNumber PRIMARY KEY(LoanNumber);
GO


 

 Create table LoanPeriodic (IssurrogateKey int not null,
 LoanNumber Varchar (10) not null,
 Cycledate datetime not null,
 Extramonthlypayment numeric (18, 2) not null,
 Unpaidprincipalbalance numeric (18, 2) not null,
 Beginningschedulebalance numeric (18, 2) not null,
 Paidinstallment numeric (18, 2) not null,
 Interestportion numeric (18, 2) not null,
 Principalportion numeric (18, 2) not null,
 Endschedulebalance numeric (18, 2) not null,
 Actualendschedulebalance numeric (18, 2) not null,
 Totalinterestaccrued numeric (18, 2) not null,
 Totalprincipalaccrued numeric (18, 2) not null,
 DEFAULTPENALTY numeric (18, 2) not null,
 Delinquencycode int not null,
 Createdate datetime not null);


 Alter table LoanPeriodic
 Add constraint CHK_LoanPeriodic_Interestportion_Principalportion CHECK (PaidInstallment = (Interestportion+Principalportion));
 GO

 Alter table LoanPeriodic
Add constraint CHK_LoanPeriodic_CreateDate Default (Getdate()) FOR CreateDate;
GO

Alter Table LoanPeriodic
Add constraint CHK_LoanPeriodic_Extramonthlypayment Default (0) FOR Extramonthlypayment;
GO
 
Alter Table LoanPeriodic
Add constraint FK_LoanNumber 
FOREIGN KEY (LoanNumber) References LoanSetupinformation (LoanNumber);

Alter Table LoanPeriodic
Add constraint FK_DelinquencyCode
FOREIGN KEY (DelinquencyCode) References LU_Delinquency (DeliquencyCode);

Alter Table LoanPeriodic
Add constraint PK_LoanPeriodic_LoanNumber_Cycledate PRIMARY KEY(LoanNumber, Cycledate);
GO

 Create Table LU_Delinquency (DeliquencyCode int not null,
Delinquency varchar (255) not null);

Alter Table LU_Delinquency
Add constraint PK_LU_Deliquency_DelinquencyCode PRIMARY KEY(DeliquencyCode);
GO




Create table LU_PaymentFrequency (PaymentFrequency int not null,
PaymentIsMadeEvery int not null,
PaymentFrequency_Description varchar (255) not null);

Alter Table LU_PaymentFrequency
Add constraint PK_LU_PaymentFrequency_PaymentFrequency PRIMARY KEY(PaymentFrequency);
GO


Create table Underwriter (UnderwriterID int not null,
UnderwriterFirstName varchar (255) null,
UnderwriterMiddleInitial char (1) null,
UnderwriterLastName varchar (255) not null,
PhoneNumber varchar (14) null,
Email varchar (255) not null,
CreateDate datetime not null);

Alter table Underwriter
Add constraint CHK_Underwriter_Email CHECK (Email like '@');
GO

Alter table Underwriter
Add constraint CHK_UnderwriterID_CreateDate Default (Getdate()) FOR CreateDate;
GO


Alter Table Underwriter
Add constraint PK_Underwriter_UnderwriterID PRIMARY KEY(UnderwriterID);
GO





/****** Object:  Schema [Borrower]    Script Date: 8/17/2021 8:40:52 PM ******/
CREATE SCHEMA [Borrower]
GO

Create table BorrowerTable (BorrowerID int not null,
BorrowerFirstName varchar (255) not null,
BorrowerMiddleInitial char (1) not null,
BorrowerLastName varchar (255) not null,
DoB datetime not null,
Gender char (1) null,
TaxPayerID_SSN varchar (9) not null,
PhoneNumber varchar (10) not null,
Email varchar (255) not null,
Citizenship varchar (255) null,
BeneficiaryName varchar (255) null,
IsUScitizen bit null,
Createdate datetime not null);

Alter table BorrowerTable
Add constraint CHK_Borrower_DOB CHECK (DOB<=DATEADD(YEAR,-18,GETDATE()));
GO

Alter table BorrowerTable
Add constraint CHK_Borrower_Email CHECK (Email like '@');

Alter table BorrowerTable
Add constraint CHK_Borrower_PhoneNumber CHECK (LEN(PhoneNumber)=10);
GO

Alter table BorrowerTable
Add constraint CHK_Borrower_SSN CHECK(LEN(TaxPayerID_SSN)=9);
GO

Alter table BorrowerTable
Add constraint CHK_Borrower_CreateDate Default ( Getdate()) FOR CreateDate;
GO

The Unique Identifier on this table is the Primary key BorrowerID

Alter table BorrowerTable
Add Constraint PK_Borrower_BorrowerID Primary key (BorrowerID)
Go



Select * from BorrowerTable

Create table BorrowerAddress (AddressID int not null,
BorrowerID int not null,
StreetAddress varchar (255) not null,
Zip varchar (5) not null,
CreateDate datetime not null);

Alter table BorrowerAddress 
Add constraint CHK_BorrowerAddress_CreateDate Default (Getdate()) FOR CreateDate;
GO

Alter table BorrowerAddress
Add constraint FT_BorrowerID
FOREIGN KEY (BorrowerID) References BorrowerTable (BorrowerID);
GO

Alter table BorrowerAddress
Add constraint FT_Zip
FOREIGN KEY (Zip) References US_ZipCodesTable (Zip);
GO

Alter table BorrowerAddress
Add Constraint PK_Borrower_BorrowerID Primary key (BorrowerID);
Go

