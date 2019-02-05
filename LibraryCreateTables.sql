
CREATE DATABASE db_cmt_library;
GO

USE db_cmt_library;
GO


begin transaction;

-- Create Table Library_Branch

CREATE TABLE tbl_LibraryBranch (
	BranchID int PRIMARY KEY IDENTITY (1,1) NOT NULL,
	BranchName varchar(256), 
	[Address] varchar(256)
);


-- Create Table Publisher

CREATE TABLE tbl_Publisher (
	PublisherName varchar(256) PRIMARY KEY NOT NULL,
	[Address] varchar(256),
	Phone varchar(50)
)


-- Create table Books

CREATE TABLE tbl_Books (
	BookID int PRIMARY KEY IDENTITY (1,1) NOT NULL,
	Title varchar(256),
	PublisherName varchar(256) FOREIGN KEY REFERENCES tbl_Publisher(PublisherName) NOT NULL
)


-- Create table Book_Authors

CREATE TABLE tbl_BookAuthors (
	BookID int FOREIGN KEY REFERENCES tbl_Books(BookID) NOT NULL,
	AuthorName varchar(256)
)


-- Create Table Book Copies

CREATE TABLE tbl_BookCopies (
	BookID int FOREIGN KEY REFERENCES tbl_Books(BookID) NOT NULL,
	BranchID int FOREIGN KEY REFERENCES tbl_LibraryBranch(BranchID) NOT NULL,
	Number_Of_Copies int NOT NULL
)


-- Create Table Borrower
CREATE TABLE tbl_Borrower (
	CardNo int PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Name] varchar(256) NOT NULL,
	[Address] varchar(256) NOT NULL,
	Phone varchar(50)
)

-- Create Table Book_Loans

CREATE TABLE tbl_BookLoans (
	BookID int FOREIGN KEY REFERENCES tbl_Books(BookID) NOT NULL,
	BranchID int FOREIGN KEY REFERENCES tbl_LibraryBranch(BranchID) NOT NULL,
	CardNo int FOREIGN KEY REFERENCES tbl_Borrower(CardNo) NOT NULL,
	DateOut datetime NOT NULL,
	DateDue datetime NOT NULL
)

COMMIT;


