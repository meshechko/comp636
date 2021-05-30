from flask import Flask
from config import Config
import git

app = Flask(__name__)
app.config.from_object(Config)

from application import routes