from application import app
from flask import render_template, request
import application.models as SQL
from application.forms import Search_Book, Search_Borrowers, Return_Book, Borrowers_Lend, ValidationError
from datetime import timedelta, date
import uuid
import git

def helper_books_catalogue(form, admin_catalogue = False):
    title = None
    author = None
    condition_concat = None
    is_post = None

    if request.method == "POST" and form.validate():
        is_post = True
        title = form.title.data
        author = form.author.data
        condition_concat = form.condition_concat.data
    books = SQL.get_books(title=title, author=author, condition_concat=condition_concat)
    branches = SQL.get_all_branches()
    return {"books":books, "branches":branches, "admin_catalogue":admin_catalogue, "is_post":is_post, "admin_catalogue":admin_catalogue}

def helper_return_book(form=None):
    book_id = form.book_id.data
    branch_id = form.branch_id.data
    card_no = form.card_no.data
    date_out = form.date_out.data
    date_due = form.date_due.data
    SQL.return_book(book_id=book_id, branch_id=branch_id, card_no=card_no, date_out=date_out, date_due=date_due)

    return True

def helper_generate_return_book_forms(list):
    return_book_forms = []
    for book in list:
        form = Return_Book()
        form.card_no.data = book["CardNo"]
        form.book_id.data = book["BookId"]
        form.status.data = book["Status"]
        return_book_forms.append(form)
    return return_book_forms

@app.route("/", methods=["GET", "POST"])
def catalogue():
    form = Search_Book()
    catalogue = helper_books_catalogue(form=form, admin_catalogue=False)
    return render_template("catalogue.html", admin_catalogue=catalogue["admin_catalogue"], books=catalogue["books"], branches=catalogue["branches"], form=form, is_post=catalogue["is_post"], is_not_admin_page = True)

@app.route("/admin", methods=["GET", "POST"])
def admin_catalogue():
    form = Search_Book()
    catalogue = helper_books_catalogue(form=form, admin_catalogue=True)
    return render_template("catalogue.html", admin_catalogue=catalogue["admin_catalogue"], books=catalogue["books"], branches=catalogue["branches"], form=form, is_post=catalogue["is_post"])

@app.route("/admin/book/<int:book_id>", methods=["GET", "POST"])
def admin_book(book_id=None):
    branch_forms = []

    for branch in SQL.get_all_branches(book_id):
        form = Borrowers_Lend(prefix=str(branch["BranchId"]))
        form.branch_id.data = branch["BranchId"]
        branch_forms.append(form)

    for form in branch_forms:
        if request.method == "POST" and form.validate_on_submit():
            borrowersss = [borrower['Name']+" | " +str(borrower['CardNo']) for borrower in SQL.get_borrowers()]
    
            try:
                book_id = int(form.book_id.data)
                branch_id = int(form.branch_id.data)
                book_id = int(form.book_id.data)
                card_no = int(form.borrowers_input.data.split("|",1)[1].strip())
                date_out = date.today()
                date_due = date_out + timedelta(days=28)
                borrower_already_lended_book = bool(len(SQL.get_book_current_borrowers(book_id=book_id, card_no=card_no)))
                if borrower_already_lended_book:
                    form.borrowers_input.errors.append("Borrower has already leded this book. Only one book per borrower is allowed.")
                else:
                    SQL.lend_book(book_id=book_id, branch_id=branch_id, card_no=card_no, date_due=date_due, date_out=date_out)
                form.borrowers_input.data = ""
            except:
                if bool(form.borrowers_input.data) == False:
                    form.borrowers_input.errors.append("Please enter borrower card number or name.")
                   
                elif "|" not in form.borrowers_input.data:
                    form.borrowers_input.errors.append("Borrower not found.")
                elif "|" in form.borrowers_input.data:
                    if form.borrowers_input.data not in borrowersss:
                        form.borrowers_input.errors.append("Borrower not found.")
            
    return_book_forms = helper_generate_return_book_forms(SQL.get_book_current_borrowers(book_id))
    print(SQL.get_book_current_borrowers(book_id))
    for form in return_book_forms:
        if request.method == "POST" and form.validate_on_submit():
            helper_return_book(form=form)

    book = SQL.get_books(book_id)
    borrowers = SQL.get_borrowers() 
    branches = SQL.get_all_branches(book_id)
    current_borrowers = SQL.get_book_current_borrowers(book_id)
    
    return render_template("book.html", book = book[0], branches=branches, borrowers=borrowers, current_borrowers=current_borrowers, admin_book_page=True, return_book_forms=return_book_forms, branch_forms=branch_forms)

@app.route("/admin/borrower/<int:card_no>", methods=["GET", "POST"])
def admin_borrower(card_no = None):
    borrower_loans  = SQL.get_borrower_loans(card_no=card_no)
    return_book_forms = helper_generate_return_book_forms(borrower_loans)

    for form in return_book_forms:
        if request.method == "POST" and form.validate_on_submit():
            helper_return_book(form=form)

    borrower = SQL.get_borrower(card_no=card_no)
    borrower_loans  = SQL.get_borrower_loans(card_no=card_no)
    return render_template("borrower.html", admin_borrower_page=True, borrower=borrower, borrower_loans=borrower_loans, return_book_forms=return_book_forms)

@app.route("/admin/borrowers", methods=["GET", "POST"])
def admin_borrowers():
    search_form = Search_Borrowers()
    query = None
    is_post = None
    if request.method == "POST" and search_form.validate():
        query = search_form.query.data
        is_post = True
    borrowers = SQL.get_borrowers(query=query)
    return render_template("borrowers.html", admin_borrowers_page=True, borrowers=borrowers, form=search_form, is_post=is_post)

@app.route("/admin/overdue")
def admin_overdue():
    books = SQL.get_overdue()
    return render_template("overdue.html", admin_overdue_page=True, books=books)

@app.errorhandler(404)
def page_not_found(e):
    return render_template('404.html'), 404
