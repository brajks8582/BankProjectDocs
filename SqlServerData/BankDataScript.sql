create database BankData
on 
(Name = BankData,
FileName = 'E:\SqlServer\Project\BankData.mdf',
size=10,
MaxSize = 50,
FileGrowth = 5
)

Log on
(Name = BankData_log,
FileName = 'E:\SqlServer\Project\BankData.ldf',
size=5,
MaxSize = 25,
FileGrowth = 5
)
GO
USE BankData
GO

--CUSTOMER TABLE
CREATE TABLE Customer(
CustomerID BIGINT IDENTITY(1000000000,1) PRIMARY KEY,
UserID VARCHAR(20),
Password VARCHAR(20),
TransactionPassword VARCHAR(20),
FirstName VARCHAR(20) NOT NULL,
LastName VARCHAR(20) NOT NULL,
FatherName VARCHAR(20) NOT NULL,
Address VARCHAR(30) NOT NULL,
Gender VARCHAR(10) NOT NULL,
Email VARCHAR(20) NOT NULL,
DOB DATE NOT NULL,
AadharID VARCHAR(12) NOT NULL,
PanID VARCHAR(10) NOT NULL,
KYCStatus VARCHAR(10) NOT NULL,	
CONSTRAINT chk_Gender CHECK (Gender IN('Male','Female','Others')),
CONSTRAINT chk_DOB CHECK (DATEDIFF(year,DOB,GETDATE())>18),
CONSTRAINT chk_KYC CHECK (KYCStatus IN('Completed','Pending'))
)
GO
--ACCOUNT TABLE
CREATE TABLE AccountDetails(
AccountNo BIGINT IDENTITY(1000000000,1) PRIMARY KEY,
CustomerID BIGINT NOT NULL FOREIGN KEY REFERENCES Customer(CustomerID),
FirstName VARCHAR(20) NOT NULL,
LastName VARCHAR(20) NOT NULL,
FatherName VARCHAR(20) NOT NULL,
Address VARCHAR(30) NOT NULL,
Gender VARCHAR(10) NOT NULL,
Email VARCHAR(20) NOT NULL,
DOB DATE NOT NULL,
NominationDetails VARCHAR(30),
OpenDate DATE,
Balance INT,
)
GO

--SERVICES SUBSCRIBED TABLE
CREATE TABLE ServicesSubscribed(
ServiceID INT IDENTITY(1,1) PRIMARY KEY,
AccountNo BIGINT NOT NULL FOREIGN KEY (AccountNo) REFERENCES AccountDetails(AccountNo),
SubscriptionName VARCHAR(20) NOT NULL,
SubscriptionDescription VARCHAR(20) NOT NULL,
SubscriptionStartDate DATETIME NOT NULL,
SubscriptionEndDate DATETIME NOT NULL,
SubscriptionAmount INT NOT NULL,
)
GO
--ATM CARD TABLE
CREATE TABLE AtmCumDebitCard(
DebitCardNo BIGINT IDENTITY(1000000000000000,1) PRIMARY KEY,
AccountNo BIGINT NOT NULL FOREIGN KEY REFERENCES AccountDetails(AccountNo),
PIN INT NOT NULL,
Status VARCHAR(20) NOT NULL ,
CVV INT NOT NULL,
ExpiryDate Date NOT NULL,
DisplayName VARCHAR(20) NOT NULL,
CONSTRAINT chk_CardStatus CHECK (Status IN('Active','Dormant'))
)
GO

-- Beneficiary Table
CREATE TABLE Beneficiary(
BeneficiaryID INT PRIMARY KEY,
AccountNo BIGINT NOT NULL,
FirstName VARCHAR(20) NOT NULL,
LasttName VARCHAR(20) NOT NULL,
Email VARCHAR(20) NOT NULL,
BankName VARCHAR(20) NOT NULL,
BankIFSC VARCHAR(20) NOT NULL,
ConfirmationStatus VARCHAR(10),
BeneficiaryType VARCHAR(10),
CONSTRAINT chk_ConfirmationStatus CHECK (ConfirmationStatus IN('Completed','Pending')),
CONSTRAINT chk_BeneficiaryType CHECK (BeneficiaryType IN('Internal','External'))
)
GO

-- Transaction Table
CREATE TABLE  Transactions(
TransactionID int primary key,
TransactionDate datetime not null,
AccountNo BIGINT NOT NULL FOREIGN KEY REFERENCES AccountDetails(AccountNo),
TransactionAmount int not null,
TransactionType Varchar(10) not null,
TransactionMode Varchar(10) not null,
BeneficiaryID int not null FOREIGN KEY REFERENCES Beneficiary(BeneficiaryID),
TransactionStatus Varchar(10),
CONSTRAINT chk_TransactionType CHECK (TransactionType IN('Credit','Debit')),
CONSTRAINT chk_TransactionMode CHECK (TransactionMode IN('NEFT','IMPS')),
CONSTRAINT chk_TransactionStatus CHECK (TransactionStatus IN('Completed','Pending'))
)
GO

-- SERVICEREQUESTNO TABLE
CREATE TABLE ServiceRequestNo(
ServiceRequestId INT primary key,
AccountNo BIGINT NOT NULL FOREIGN KEY REFERENCES AccountDetails(AccountNo),
DateOfRequest DATETIME NOT NULL,
DateOfCompletion DATETIME NOT NULL,
ServiceType VARCHAR(20) NOT NULL,
ServiceRequestStatus VARCHAR(10) NOT NULL,
CONSTRAINT chk_ServiceType CHECK (ServiceType IN('Block ATM','PIN Generation','ChequeIssue')),
CONSTRAINT chk_ServiceStatus CHECK (ServiceRequestStatus IN('Inprogress','Completed','New'))
)
GO

--InsertInCustomerP
CREATE PROCEDURE InsertInCustomer (@UserID VARCHAR(20),
									@Password VARCHAR(20),
									@TransactionPassword VARCHAR(20),
									@FirstName VARCHAR(20) ,
									@LastName VARCHAR(20) ,
									@FatherName VARCHAR(20),
									@Address VARCHAR(30) ,
									@Gender VARCHAR(10) ,
									@Email VARCHAR(20) ,
									@DOB DATE ,
									@AadharID VARCHAR(12) ,
									@PanID VARCHAR(10) ,
									@KYCStatus VARCHAR(10)
									 )  
AS  
  BEGIN 
		INSERT INTO Customer  
                        (UserID ,
						Password ,
						TransactionPassword ,
						FirstName  ,
						LastName  ,
						FatherName,
						Address  ,
						Gender  ,
						Email ,
						DOB  ,
						AadharID  ,
						PanID  ,
						KYCStatus )  
            VALUES     ( @UserID ,
						@Password ,
						@TransactionPassword ,
						@FirstName  ,
						@LastName  ,
						@FatherName,
						@Address  ,
						@Gender  ,
						@Email ,
						@DOB  ,
						@AadharID  ,
						@PanID  ,
						@KYCStatus)  
      END


GO

--UpdateAccountDetailsP
CREATE PROCEDURE UpdateAccountDetails (@CustomerID BIGINT)  
AS  
  BEGIN 
	INSERT INTO AccountDetails(CustomerID,
									FirstName,
									LastName  ,
									FatherName,
									Address  ,
									Gender  ,
									Email ,
									DOB)  
            SELECT CustomerID,FirstName ,LastName ,FatherName,Address ,Gender ,Email,DOB  
			FROM Customer
			WHERE CustomerID = @CustomerID
	END
GO
