from mysql.connector import connection
import connect
import mysql.connector
connection = None
dbconn = None

def get_cursor():
    global dbconn
    global connection
    if dbconn == None:
        connection = mysql.connector.connect(user=connect.dbuser, password=connect.dbpassword, host=connect.dbhost, database=connect.dbname, autocommit=True)
        dbconn = connection.cursor(dictionary=True)
        return dbconn
    else:
        return dbconn

#returns borrower data
def get_borrower(card_no):
    cur = get_cursor()
    cur.execute("SELECT Name, CardNo, Address, Phone FROM Borrower WHERE CardNo =%s;", (int(card_no),))
    borrower = cur.fetchone()
    return borrower

#returns all borrower loans (past and present)
def get_borrower_loans(card_no):  
    cur = get_cursor()
    cur.execute("SELECT bl.BookId, bl.CardNo, bl.BranchId, b.Title, bl.DateOut, bl.DueDate, DATEDIFF(DATE(NOW()), Date(bl.DueDate)) as OverDueDays, IF(bl.returned=0, 'On Loan', 'Returned') as Status FROM Book_Loans bl  JOIN Book b ON bl.BookId = b.BookId WHERE bl.CardNo =%s;", (int(card_no),))
    borrower_loans = cur.fetchall()
    return borrower_loans

#TODO
#returns a list of borrowers
def get_borrowers(query=None):

    condition = ""
    if query:
        condition = f"WHERE b.CardNo = '{ query }' OR b.Name LIKE '%{ query }%'"
    cur = get_cursor()
    cur.execute(f"SELECT b.Name, b.CardNo, b.Address, b.Phone, bl.Count_Books_On_Loan FROM Borrower b LEFT JOIN (SELECT COUNT(BookId) as Count_Books_On_Loan, CardNo FROM Book_Loans WHERE returned = 0 GROUP BY CardNo) bl ON b.CardNo = bl.CardNo {condition};")
    borrowers = cur.fetchall()
    return borrowers

#executes UPDATE query when borrower returns a book
def return_book(book_id, branch_id, card_no, date_out, date_due):
    cur = get_cursor()
    cur.execute("UPDATE Book_Loans SET returned=1 WHERE BookId=%s AND BranchId =%s AND CardNo=%s AND DateOut=%s AND DueDate=%s AND returned = 0 LIMIT 1;", (book_id, branch_id, card_no, date_out, date_due))
    return True

#executes INSERT query when a book is lent
def lend_book(book_id, branch_id, card_no, date_due, date_out):
    cur = get_cursor()
    cur.execute("INSERT INTO Book_Loans (BookId, BranchId, CardNo, DateOut, DueDate, returned) VALUES( %s, %s, %s, %s, %s, 0 );", (book_id, branch_id, card_no, date_out, date_due))    
    return True

#TODO
#returns a list of branches. If book ID is supplied then returns branches that have a copy of the book, otherwise returns a list of all branches.
def get_all_branches(book_id=None):
    condition_1 = ""
    condition_2 = ""
    if book_id:
        condition_1 = f"bl.BookId = { book_id } AND "
        condition_2 = f" WHERE bc.BookId = { book_id } "
    cur = get_cursor()
    cur.execute(f"SELECT bc.BranchId, lb.BranchName, lb.Address, bc.BookId, bc.No_Of_Copies, ol.No_On_Loan, (bc.No_Of_Copies - ol.No_On_Loan) as No_Of_Available, ol.DueDate FROM Book_Copies bc LEFT JOIN ( SELECT bl.BookId, COUNT(bl.BookId) as No_On_Loan, MIN(bl.DueDate) as DueDate, bl.BranchId FROM Book_Loans bl WHERE {condition_1} bl.returned = 0 GROUP BY bl.BookId, bl.BranchId ) as ol ON ol.BranchId = bc.BranchId AND ol.BookId = bc.BookId JOIN Library_Branch lb ON lb.BranchId = bc.BranchId {condition_2}")
    branches = cur.fetchall()
    return branches

#TODO
#returns a list of books. If not params supplied then returns all books, if only book ID is supplied than shows only one book data and also used to search books by author and/or book name
def get_books(book_id=None, title=None, author=None, condition_concat=None):
   
    condition = ""
    where = ""

    #if only book ID is supplied than shows only one book data 
    if book_id:
        condition += f"b.BookId = '{book_id}'"

    # the below is a query builder that is used to find a book by author and/or book name
    if title or author or book_id:
        where = "WHERE"

    if condition_concat:
        if title and author:
            condition_concat = condition_concat
        else:
            condition_concat = ""

        if title:
            condition += f"b.Title LIKE '%{title}%' {condition_concat} "
        
        if author:
            condition += f"a.AuthorName LIKE '%{author}%'"

    

    cur = get_cursor()
    cur.execute(f"SELECT b.BookId, b.Title, b.PublisherName, a.AuthorName FROM Book as b JOIN Author as a ON b.Author=a.AuthorId {where} {condition};")
    books = cur.fetchall()
    return books

#returns a list of overdue books
def get_overdue():
    cur = get_cursor()
    cur.execute("SELECT lb.BranchName, b.Name as BorrowerName, b.CardNo, DATEDIFF(DATE(NOW()), Date(bl.DueDate)) as OverDueDays, bl.BookId, book.Title FROM Book_Loans bl JOIN Borrower b ON bl.CardNo = b.CardNo JOIN Library_Branch lb ON lb.BranchId = bl.BranchId JOIN Borrower bor on bor.CardNo=bl.CardNo JOIN Book book ON bl.BookId = book.BookId WHERE bl.returned = 0 AND DATE(DueDate) < DATE(NOW());")
    overdue = cur.fetchall()
    return overdue

#TODO
#returns a list of borrowers that currently have book on loan
def get_book_current_borrowers(book_id, card_no=None):
    condition_by_borrower = ""
    if card_no:
        condition_by_borrower += f" AND bl.CardNo = { card_no }"
    cur = get_cursor()
    cur.execute(f"SELECT lb.BranchName, b.Name, b.CardNo, bl.DateOut, DATEDIFF(DATE(NOW()), Date(bl.DueDate)) as OverDueDays, bl.DueDate, bl.BookId, bl.BranchId, IF(bl.returned=0, 'On Loan', 'Returned') as Status FROM Book_Loans bl JOIN Borrower b ON bl.CardNo = b.CardNo JOIN Library_Branch lb ON lb.BranchId = bl.BranchId WHERE bl.BookId = { book_id } AND bl.returned = 0 {condition_by_borrower}")
    borrowers = cur.fetchall()
    return borrowers