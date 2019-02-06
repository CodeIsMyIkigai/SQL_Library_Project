USE db_cmt_library;
GO

-- 1) How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?

CREATE PROC dbo.getBookCopiesByTitleAndBranch @Title nvarchar(256) = NULL, @BranchName varchar(256) = NULL
AS

select tbl_Books.Title, BranchName, Number_Of_Copies from tbl_BookCopies
LEFT JOIN tbl_Books on tbl_BookCopies.BookID = tbl_Books.BookID
LEFT JOIN tbl_LibraryBranch on tbl_BookCopies.BranchID = tbl_LibraryBranch.BranchID
WHERE
tbl_Books.Title = ISNULL(@Title, tbl_Books.Title) and tbl_LibraryBranch.BranchName = ISNULL(@BranchName, tbl_LibraryBranch.BranchName);

GO

-- Tests

exec dbo.getBookCopiesByTitleAndBranch @Title = 'The Lost Tribe', @BranchName = 'Sharpstown';
exec dbo.getBookCopiesByTitleAndBranch @BranchName = 'Sharpstown';
exec dbo.getBookCopiesByTitleAndBranch @Title = 'The Lost Tribe';
exec dbo.getBookCopiesByTitleAndBranch;


-- 2 Number of Books by Branch
select BranchName, Number_Of_Copies from tbl_LibraryBranch
LEFT JOIN tbl_BookCopies on tbl_LibraryBranch.BranchID = tbl_BookCopies.BranchID
LEFT JOIN tbl_Books on tbl_BookCopies.BookID = tbl_Books.BookID 
where tbl_Books.Title = 'The Lost Tribe' order by tbl_LibraryBranch.BranchName;


-- 3 Names of borrowers who do not have any books checked out
select Name from tbl_Borrower where CardNo not in (select distinct(CardNo) from tbl_BookLoans where DateDue >= GETDATE());

-- 4 Books Due today from a library branch (Not Likely that this will work because of random dates)

select b.Title, tb.[Name], tb.Address from tbl_BookLoans tbl
LEFT JOIN tbl_Borrower tb on tbl.CardNo = tb.CardNo
LEFT JOIN tbl_Books b on tbl.BookID = b.BookID
LEFT JOIN tbl_LibraryBranch lb on tbl.BranchID = lb.BranchID
WHERE 
	lb.BranchName = 'Center'
	AND convert(varchar, DateDue, 112) = convert(varchar, GETDATE(),112)

Select * from tbl_BookLoans where  convert(varchar, DateDue, 112) = convert(varchar, GETDATE(),112)
select * from tbl_LibraryBranch where BranchName = 'Sharpstown';


-- 5 Total number of loaned books by branch

select BranchName, count(DateOut) from tbl_LibraryBranch
LEFT JOIN tbl_BookLoans on tbl_LibraryBranch.BranchID = tbl_BookLoans.BranchID
group by BranchName
order by tbl_LibraryBranch.BranchName;

-- 6 Retreive Borrower information for those with more than 5 books checked out.

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


-- 7 For Get number of copies owned by a branch for author and branch

select b.Title, bc.Number_Of_Copies from tbl_Books as b
LEFT JOIN tbl_BookAuthors ba on b.BookID = ba.BookID
LEFT JOIN tbl_BookCopies bc on b.BookID = bc.BookID
LEFT JOIN tbl_LibraryBranch lb on bc.BranchID = lb.BranchID
where ba.AuthorName = 'Stephen King' and lb.BranchName = 'Central';





