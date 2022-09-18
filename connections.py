from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import text
from flask import Flask


app = Flask(__name__)



DB_URL = 'postgresql+psycopg2://postgres:divija123@127.0.0.1:5432/billing_system'

app.config['SQLALCHEMY_DATABASE_URI'] = DB_URL
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False # silence the deprecation warning

db = SQLAlchemy(app)

def execute_select_query(query):
    result = db.engine.execute(text(query))
    list = []
    for i in result:
        list.append(i)
    return(list)

def execute_insert_query(query):
    try: 
        ans = db.engine.execute(text(query))
        return True
    except:
        return False
