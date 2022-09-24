from app import app
from flask import session
from flask_session import Session
from flask_cors import CORS, cross_origin
import os

if "__name__" == "__main__":
    app.config['SECRET_KEY'] = 'testing'
    app.config['SESSION_COOKIE_NAME'] = "my_session"
    app.config["SESSION_PERMANENT"] = True
    app.config["SESSION_TYPE"] = "filesystem"
    app.secret_key = 'testing'
    Session(app)
    CORS(app)
    app.run()