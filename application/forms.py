from flask_wtf import FlaskForm
from wtforms import StringField, SelectField, HiddenField, SubmitField, validators, ValidationError
import application.models as SQL


class Search_Book(FlaskForm):
    title = StringField(description="Book title",render_kw={"placeholder": "Book title", "class":"form-control"})
    author = StringField(description="Author", render_kw={"placeholder": "Author", "class":"form-control"})
    condition_concat = SelectField(choices=[('OR', 'OR'), ('AND', 'AND')], render_kw={"class":"input-group-text"})
    
    def validate(self):
        if not FlaskForm.validate(self):
            return False

        empty_fields = [field.description for field in self if field.type == "StringField" and bool(field.data) == False]
        concat_field = self.condition_concat.data

        if concat_field == "OR":
            if len(empty_fields) == 2:
                fields = ' or '.join(empty_fields)
                self.title.errors += (ValidationError(f"Please enter { fields }."),)
                return False
        else:
            if len(empty_fields) == 1:
                fields = empty_fields
                self.title.errors += (ValidationError(f"Please enter { fields[0] }."),)
                return False
            elif len(empty_fields) == 2:
                fields = ' and '.join(empty_fields)
                self.title.errors += (ValidationError(f"Please enter { fields }."),)
                return False
        return True

class Search_Borrowers(FlaskForm):
    query = StringField(render_kw={"placeholder": "Card number or Name", "class":"form-control"})

    def validate_query(form, field):
        if bool(field.data) == False:
            raise ValidationError(f"Please enter borrower card number or name.")

class Borrowers_Lend(FlaskForm):
    borrowers_input = StringField('Lend book to: ', render_kw={"placeholder": "Enter borrower name or card number", "class":"form-control"})
    book_id = HiddenField()
    branch_id = HiddenField()
    card_no = HiddenField()
    error = StringField()
    button_lend = SubmitField("Lend", render_kw={"class":"btn btn-primary"})


class Return_Book(FlaskForm):
    book_id = HiddenField()
    status = HiddenField()
    branch_id = HiddenField()
    card_no = HiddenField()
    date_out = HiddenField()
    date_due = HiddenField()
    button_return = SubmitField("Return Book", render_kw={"class":"btn btn-primary btn-sm"})
