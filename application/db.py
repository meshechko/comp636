import mysql.connector
from application import app

conn = mysql.connector.connect(user=app.config['DB_USER'], password=app.config['DB_PASSWORD'], host=app.config['DB_HOST'], database=app.config['DB_NAME'], autocommit=True)

