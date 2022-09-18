import json
from flask import jsonify
from flask import Flask,request
from worker import *
from connections import *
from people import *

type = 100
phone = 0
password = ''

@app.route('/',methods=['GET'])
def home():
    print("WORKING")
    return {'message':'hello'}

@app.route('/login',methods=['POST'])
def user_login():
    global type
    global p
    data=request.json
    phone=data['phone']
    password=data['password']
    p = Person(phone,password)
    status=p.login()
    return status

@app.route('/resetPassword',methods=['POST'])
def resetPass():
    data = request.json
    old = data['old_password']
    new = data['new_password']
    p = Person(phone,password)
    valid = p.change_password(old,new)
    return valid

@app.route('/getDetails',methods=['GET'])
def dets():
    data=None
    if (type==0):
        c = Cashier(phone,password)
        data=c.get_details()
    if (type==1):
        m = Manager(phone,password)
        data=m.get_details()
    if (type==2):
        a = Admin(phone,password)
        data=a.admin_get_details()
    if (type==3):
        cust = Customer(phone,password)
        data=cust.get_details()
    return data
        
@app.route('/orderAnalytics',methods=['GET'])
def analytics():
    m = Manager(phone,password)
    data=m.view_analytics()
    return data

@app.route('/getAllOrders',methods=['GET'])
def orders():
    m = Manager(phone,password)
    data=m.view_order()
    return data

@app.route('/getCustomerOrders',methods=['GET'])
def customer_orders():
    cust = Customer(phone,password)
    data = cust.getOrders()
    print(data)
    return (data)

@app.route('/getCashierOrders',methods=['GET'])
def cashier_orders():
    c = Cashier(phone,password)
    data = c.get_todays_order()
    print(data)
    return (data)

@app.route('/getAllProducts',methods=['GET'])
def get_all_products():
    c = Cashier(phone,password)
    data = c.get_all_products()
    return jsonify(data)

@app.route('/checkCoupon',methods=['POST'])
def checkValidCoupon():
    c = Cashier(phone,password)
    data=request.json
    print(data)
    coupon_name = data['coupon']
    validity = c.check_coupon(coupon_name)
    return validity

@app.route('/checkCustomer',methods=['POST'])
def checkValidCustomer():
    c = Cashier(phone,password)
    data=request.json
    print(data)
    cust_phone = data['phone']
    validity = c.check_customer(cust_phone)
    return validity

@app.route('/regCustomer',methods=['POST'])
def register_customer():
    c = Cashier(phone,password)
    data = request.json
    first_name = data['firstname']
    last_name = data['lastname']
    phone = int(data['phone'])
    email = data['email']
    validity = c.reg(first_name,last_name,email,phone)
    return validity

@app.route('/createOrder',methods=['POST'])
def create_new_order():
    c = Cashier(phone,password)
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
    validity = c.create_order(amount,products,coupon_id,cust_id,payment_type,senders_upi,card_no,expiry,cvv)
    print(validity)
    return validity

@app.route('/addCoupon',methods=['POST'])
def add_new_coupon():
    a = Admin(phone,password)
    data = request.json
    coup_name = data['coupon_name']
    disc = data['discount']
    expiry = data['date']
    validity = a.add_coupon(coup_name,disc,expiry)
    return validity

@app.route('/addProduct',methods=['POST'])
def add_new_product():
    a = Admin(phone,password)
    data = request.json
    prod_name = data['name']
    prod_price = data['price']
    prod_qty = data['qty']
    prod_cat = data['category']
    prod_war = data['warranty']
    validity = a.add_product(prod_name,prod_price,prod_qty,prod_cat,prod_war)
    return validity

@app.route('/getAllStores',methods=['GET'])
def get_all_stores():
    a = Admin(phone,password)
    data = a.get_all_stores()
    return data

@app.route('/createWorker',methods=['POST'])
def create_worker():
    a = Admin(phone,password)
    data = request.json
    fn = data['firstname']
    ln = data['lastname']
    phone = int(data['phone'])
    store = int(data['store_id'])
    type = int(data['type'])
    valid = a.create_new_worker(fn,ln,phone,store,type)
    return valid


