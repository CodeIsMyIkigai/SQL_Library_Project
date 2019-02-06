USE db_cmt_library;
GO

-- 1) How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?

-- I used a generic solution to avoid writing excess code.  Note that query 2 of this exercise uses this stored proc as well.
-- This proc can be run with any umber of parameters and gives the expected result.  Give it a book and a branch and you get the number
-- of copies of that book at that branch.  Give it only the branch and it gives you the number of copies for all books at the branch.
-- Give it only a book and it gives you the number of copies of that book at each branch.

GO
CREATE PROC dbo.getBookCopiesByTitleAndBranch @Title nvarchar(256) = NULL, @BranchName varchar(256) = NULL
AS
	select tbl_Books.Title, BranchName, Number_Of_Copies from tbl_BookCopies
	LEFT JOIN tbl_Books on tbl_BookCopies.BookID = tbl_Books.BookID
	LEFT JOIN tbl_LibraryBranch on tbl_BookCopies.BranchID = tbl_LibraryBranch.BranchID
	WHERE
	tbl_Books.Title = ISNULL(@Title, tbl_Books.Title) and tbl_LibraryBranch.BranchName = ISNULL(@BranchName, tbl_LibraryBranch.BranchName)
GO

-- Solution executions

exec dbo.getBookCopiesByTitleAndBranch @Title = 'The Lost Tribe', @BranchName = 'Sharpstown';
exec dbo.getBookCopiesByTitleAndBranch @BranchName = 'Sharpstown';
exec dbo.getBookCopiesByTitleAndBranch @Title = 'The Lost Tribe';
exec dbo.getBookCopiesByTitleAndBranch;


-- 2) How many copies of the book titled "The Lost Tribe" are owned by each library branch?
-- Solution: Using stored proc from the first deliverable, we achieve the result.
exec dbo.getBookCopiesByTitleAndBranch @Title = 'The Lost Tribe';


-- 3 Names of borrowers who do not have any books checked out
-- Assumes that any entry in the tbl_BookLoans is actively checked out even if it is after DateDue.
GO
	CREATE PROC dbo.getBorrowersWithNoLoans
	AS
	select Name from tbl_Borrower where CardNo not in (select distinct(CardNo) from tbl_BookLoans)
GO
--Solution executions
exec dbo.getBorrowersWithNoLoans;

-- 4) For each book that is loaned out from the "Sharpstown" branch and whose DueDate is today, retrieve the book title, the borrower's name, and the borrower's address.

GO
CREATE PROC dbo.getBooksDueTodayByBranch @BranchName varchar(256) = NULL
AS
	select b.Title, tb.[Name], tb.Address from tbl_BookLoans tbl
	LEFT JOIN tbl_Borrower tb on tbl.CardNo = tb.CardNo
	LEFT JOIN tbl_Books b on tbl.BookID = b.BookID
	LEFT JOIN tbl_LibraryBranch lb on tbl.BranchID = lb.BranchID
	WHERE 
		lb.BranchName = ISNULL(@BranchName, lb.BranchName)
		AND convert(varchar, DateDue, 112) = convert(varchar, GETDATE(),112)
GO

exec dbo.getBooksDueTodayByBranch @Branchname = 'Sharpstown';   -- All books due today at 'Sharpstown'
exec dbo.getBooksDueTodayByBranch;                              -- All books due today at all branches


-- 5.) For each library branch, retrieve the branch name and the total number of books loaned out from that branch.

GO
CREATE PROC dbo.getTotalBooksLoanedByBranch
AS
	select BranchName, count(DateOut) from tbl_LibraryBranch
	LEFT JOIN tbl_BookLoans on tbl_LibraryBranch.BranchID = tbl_BookLoans.BranchID
	group by BranchName
	order by tbl_LibraryBranch.BranchName
GO

-- Solution execution
exec dbo.getTotalBooksLoanedByBranch;


-- 6) Retrieve the names, addresses, and the number of books checked out for all borrowers who have more than five books checked out.

GO
CREATE PROC dbo.getBorrowerInformationFromBorrowersWithMoreThanFiveBooks
AS
	select tb.Name, tb.Address, Count(*) as Num from tbl_BookLoans tbl
	LEFT JOIN tbl_Borrower tb on tbl.CardNo = tb.CardNo
	where tb.CardNo in (
		select CardNo 
		from tbl_BookLoans 
		where convert(varchar, DateDue, 112) >= convert(varchar, GETDATE(),112)
		group by CardNo Having COUNT(*) > 5 
	)
	group by tbl.CardNo,tb.Name, tb.Address Having count(*) > 5 
	order by tb.Name
GO
-- Solution execution
exec.dbo.getBorrowerInformationFromBorrowersWithMoreThanFiveBooks;


-- 7) For each book authored (or co-authored) by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".

GO
CREATE PROC dbo.getStephenKingCopiesOwnedByBranchCentral
AS
	select b.Title, bc.Number_Of_Copies from tbl_Books as b
	LEFT JOIN tbl_BookAuthors ba on b.BookID = ba.BookID
	LEFT JOIN tbl_BookCopies bc on b.BookID = bc.BookID
	LEFT JOIN tbl_LibraryBranch lb on bc.BranchID = lb.BranchID
	where ba.AuthorName = 'Stephen King' and lb.BranchName = 'Central'
GO

-- Solution execution
exec dbo.getStephenKingCopiesOwnedByBranchCentral;

