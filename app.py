import json
from flask import jsonify
from flask import Flask,request,session
from classes.worker import *
from classes.connections import *
from classes.people import *
from flask_session import Session
from flask_cors import CORS, cross_origin

app.config["SESSION_PERMANENT"] = True
app.config["SESSION_TYPE"] = "filesystem"
Session(app)
CORS(app)

@app.route('/',methods=['GET'])
def home():
    print("WORKING")
    return {'message':'hello'}

@app.route('/login',methods=['POST'])
@cross_origin(supports_credentials=True)
def user_login():
    data=request.json
    phone=data['phone']
    password=data['password']
    session['phone']=phone
    p = Person(phone)
    status=p.login()
    if (status['status']=='FAIL'):
        return status
    elif (status['type']==0):
        c = Cashier(phone)
        type=0
        session['type']=type
    elif (status['type']==1):
        m = Manager(phone)
        type=1
        session['type']=type
    elif (status['type']==2):
        a = Admin(phone)
        type=2
        session['type']=type
    elif (status['type']==3):
        cust = Customer(phone)
        type=3
        session['type']=type
    return status

@app.route('/resetPassword',methods=['POST'])
@cross_origin(supports_credentials=True)
def resetPass():
    data = request.json
    old = data['old_password']
    new = data['new_password']
    phone=session['phone']
    p=Person(phone)
    valid = p.change_password(old,new)
    return valid

@app.route('/getDetails',methods=['GET'])
@cross_origin(supports_credentials=True)
def dets():
    data=None
    phone=session['phone']
    dummy = Person(phone)
    type = dummy.type
    if (type==0):
        c=Cashier(phone)
        data=c.get_details()
    if (type==1):
        m=Manager(phone)
        data=m.get_details()
    if (type==2):
        a=Admin(phone)
        data=a.admin_get_details()
    if (type==3):
        cust=Customer(phone)
        data=cust.get_details()
    return data
        
@app.route('/orderAnalytics',methods=['GET'])
@cross_origin(supports_credentials=True)
def analytics():
    phone=session['phone']
    m=Manager(phone)
    data=m.view_analytics()
    return data

@app.route('/getAllOrders',methods=['GET'])
@cross_origin(supports_credentials=True)
def orders():
    phone=session['phone']
    m=Manager(phone)
    data=m.view_order()
    return data

@app.route('/getCustomerOrders',methods=['GET'])
@cross_origin(supports_credentials=True)
def customer_orders():
    phone=session['phone']
    cust=Customer(phone)
    data = cust.getOrders()
    print(data)
    return (data)

@app.route('/getCashierOrders',methods=['GET'])
@cross_origin(supports_credentials=True)
def cashier_orders():
    phone=session['phone']
    c=Cashier(phone)
    data = c.get_todays_order()
    print(data)
    return (data)

@app.route('/getAllProducts',methods=['GET'])
@cross_origin(supports_credentials=True)
def get_all_products():
    phone=session['phone']
    c=Cashier(phone)
    data = c.get_all_products()
    return jsonify(data)

@app.route('/checkCoupon',methods=['POST'])
@cross_origin(supports_credentials=True)
def checkValidCoupon():
    data=request.json
    print(data)
    coupon_name = data['coupon']
    phone=session['phone']
    c=Cashier(phone)
    validity = c.check_coupon(coupon_name)
    return validity

@app.route('/checkCustomer',methods=['POST'])
@cross_origin(supports_credentials=True)
def checkValidCustomer():
    data=request.json
    print(data)
    cust_phone = data['phone']
    phone=session['phone']
    c=Cashier(phone)
    validity = c.check_customer(cust_phone)
    return validity

@app.route('/regCustomer',methods=['POST'])
@cross_origin(supports_credentials=True)
def register_customer():
    data = request.json
    first_name = data['firstname']
    last_name = data['lastname']
    phone = int(data['phone'])
    email = data['email']
    phone=session['phone']
    c=Cashier(phone)
    validity = c.reg(first_name,last_name,email,phone)
    return validity

@app.route('/createOrder',methods=['POST'])
@cross_origin(supports_credentials=True)
def create_new_order():
    data = request.json
    amount = data['amount']
    products = data['products']
    coupon_id = data['coupon']
    cust_id = data['user_id']
    payment_type = data['payment_type']
    senders_upi = data['senders_upi']
    communication_mode = data['communication_type']
    card_no = data['cardnumber']
    expiry = data['cardexpiry']
    cvv = data['cardcvv']
    phone=session['phone']
    c=Cashier(phone)
    validity = c.create_order(amount,products,coupon_id,cust_id,payment_type,senders_upi,card_no,expiry,cvv)
    print(validity)
    return validity

@app.route('/addCoupon',methods=['POST'])
@cross_origin(supports_credentials=True)
def add_new_coupon():
    data = request.json
    coup_name = data['coupon_name']
    disc = data['discount']
    expiry = data['date']
    phone=session['phone']
    a=Admin(phone)
    validity = a.add_coupon(coup_name,disc,expiry)
    return validity

@app.route('/addProduct',methods=['POST'])
@cross_origin(supports_credentials=True)
def add_new_product():
    data = request.json
    prod_name = data['name']
    prod_price = data['price']
    prod_qty = data['qty']
    prod_cat = data['category']
    prod_war = data['warranty']
    phone=session['phone']
    a=Admin(phone)
    validity = a.add_product(prod_name,prod_price,prod_qty,prod_cat,prod_war)
    return validity

@app.route('/getAllStores',methods=['GET'])
@cross_origin(supports_credentials=True)
def get_all_stores():
    phone=session['phone']
    a=Admin(phone)
    data = a.get_all_stores()
    return data

@app.route('/createWorker',methods=['POST'])
@cross_origin(supports_credentials=True)
def create_worker():
    data = request.json
    fn = data['firstname']
    ln = data['lastname']
    phone = int(data['phone'])
    store = int(data['store_id'])
    type = int(data['type'])
    phone=session['phone']
    a=Admin(phone)
    valid = a.create_new_worker(fn,ln,phone,store,type)
    return valid

