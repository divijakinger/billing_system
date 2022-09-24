from app import app
from flask import session
from flask_session import Session
from flask_cors import CORS, cross_origin
import os

if "__name__" == "__main__":
    app.config['SECRET_KEY'] = os.urandom(24)
    app.config['SESSION_COOKIE_NAME'] = "my_session"
    app.config["SESSION_PERMANENT"] = True
    app.config["SESSION_TYPE"] = "filesystem"
    app.secret_key = os.urandom(24)
    Session(app)
    CORS(app)
    app.run()