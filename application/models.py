from application.db import conn


def get_borrower(card_no):
    cur = conn.cursor(dictionary=True)
    cur.execute(f"SELECT Name, CardNo, Address, Phone FROM Borrower WHERE CardNo = { card_no };")
    borrower = cur.fetchall()
    return borrower[0]

def get_borrower_loans(card_no):  
    cur = conn.cursor(dictionary=True)
    cur.execute(f"SELECT bl.BookId, bl.CardNo, bl.BranchId, b.Title, bl.DateOut, bl.DueDate, DATEDIFF(DATE(NOW()), Date(bl.DueDate)) as OverDueDays, IF(bl.returned=0, 'On Loan', 'Returned') as Status FROM Book_Loans bl  JOIN Book b ON bl.BookId = b.BookId WHERE bl.CardNo = { card_no }")
    borrower_loans = cur.fetchall()
    return borrower_loans

def get_borrowers(query=None):
    condition = ""
    if query:
        condition = f"WHERE b.CardNo = '{ query }' OR b.Name LIKE '%{ query }%'"
    cur = conn.cursor(dictionary=True)

    cur.execute(f"SELECT b.Name, b.CardNo, b.Address, b.Phone, bl.Count_Books_On_Loan FROM Borrower b LEFT JOIN (SELECT COUNT(BookId) as Count_Books_On_Loan, CardNo FROM Book_Loans WHERE returned = 0 GROUP BY CardNo) bl ON b.CardNo = bl.CardNo {condition};")
    borrowers = cur.fetchall()
    return borrowers

def return_book(book_id, branch_id, card_no, date_out, date_due):
    cur = conn.cursor()
    print(f"UPDATE Book_Loans SET returned=1 WHERE BookId={book_id} AND BranchId = {branch_id} AND CardNo={card_no} AND DateOut='{date_out}' AND DueDate='{date_due}' AND returned = 0 LIMIT 1;")
    cur.execute(f"UPDATE Book_Loans SET returned=1 WHERE BookId={book_id} AND BranchId = {branch_id} AND CardNo={card_no} AND DateOut='{date_out}' AND DueDate='{date_due}' AND returned = 0 LIMIT 1;")
    conn.commit()
    
    return True

def lend_book(book_id, branch_id, card_no, date_due, date_out):
    cur = conn.cursor()
    cur.execute(f"INSERT INTO Book_Loans (BookId, BranchId, CardNo, DateOut, DueDate, returned) VALUES( { book_id }, { branch_id }, { card_no }, '{ date_out }', '{ date_due }', 0 );")
    conn.commit()
    
    return True

def get_all_branches(book_id=None):
    condition_1 = ""
    condition_2 = ""
    if book_id:
        condition_1 = f"bl.BookId = { book_id } AND "
        condition_2 = f" WHERE bc.BookId = { book_id } "
    cur = conn.cursor(dictionary=True)
    cur.execute(f"SELECT bc.BranchId, lb.BranchName, lb.Address, bc.BookId, bc.No_Of_Copies, ol.No_On_Loan, (bc.No_Of_Copies - ol.No_On_Loan) as No_Of_Available, ol.DueDate FROM Book_Copies bc LEFT JOIN ( SELECT bl.BookId, COUNT(bl.BookId) as No_On_Loan, MIN(bl.DueDate) as DueDate, bl.BranchId FROM Book_Loans bl WHERE {condition_1} bl.returned = 0 GROUP BY bl.BookId, bl.BranchId ) as ol ON ol.BranchId = bc.BranchId AND ol.BookId = bc.BookId JOIN Library_Branch lb ON lb.BranchId = bc.BranchId {condition_2}")
    branches = cur.fetchall()
    return branches

def get_books(book_id=None, title=None, author=None, condition_concat=None):
    condition = ""
    where = ""

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

    if book_id:
        condition += f"b.BookId = '{book_id}'"

    cur = conn.cursor(dictionary=True)
    cur.execute(f"SELECT b.BookId, b.Title, b.PublisherName, a.AuthorName FROM Book as b JOIN Author as a ON b.Author=a.AuthorId {where} {condition};")
    books = cur.fetchall()
    return books

def get_overdue():
    cur = conn.cursor(dictionary=True)
    cur.execute(f"SELECT lb.BranchName, b.Name as BorrowerName, b.CardNo, DATEDIFF(DATE(NOW()), Date(bl.DueDate)) as OverDueDays, bl.BookId, book.Title FROM Book_Loans bl JOIN Borrower b ON bl.CardNo = b.CardNo JOIN Library_Branch lb ON lb.BranchId = bl.BranchId JOIN Borrower bor on bor.CardNo=bl.CardNo JOIN Book book ON bl.BookId = book.BookId WHERE bl.returned = 0 AND DATE(DueDate) < DATE(NOW());")
    overdue = cur.fetchall()
    return overdue

def get_book_current_borrowers(book_id, card_no=None):
    condition_by_borrower = ""
    if card_no:
        condition_by_borrower += f" AND bl.CardNo = { card_no }"
    cur = conn.cursor(dictionary=True)
    cur.execute(f"SELECT lb.BranchName, b.Name, b.CardNo, bl.DateOut, DATEDIFF(DATE(NOW()), Date(bl.DueDate)) as OverDueDays, bl.DueDate, bl.BookId, bl.BranchId, IF(bl.returned=0, 'On Loan', 'Returned') as Status FROM Book_Loans bl JOIN Borrower b ON bl.CardNo = b.CardNo JOIN Library_Branch lb ON lb.BranchId = bl.BranchId WHERE bl.BookId = { book_id } AND bl.returned = 0 {condition_by_borrower}")
    borrowers = cur.fetchall()
    return borrowers