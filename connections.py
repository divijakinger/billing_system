from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import text
from flask import Flask


app = Flask(__name__)



DB_URL = 'postgres://ktuubilltlnyrg:1b70da51ac2094134cfddb59cbedbe66bce37a11a2aab82e468b6c813ff2034a@ec2-44-209-158-64.compute-1.amazonaws.com:5432/d56g97aa7iciem'

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
