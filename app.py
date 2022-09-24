import json
from flask import jsonify
from flask import Flask,request
from classes.worker import *
from classes.connections import *
from classes.people import *




@app.route('/',methods=['GET'])
def home():
    print("WORKING")
    return {'message':'hello'}

@app.route('/login',methods=['POST'])
def user_login():
    db.engine.execute("TRUNCATE TABLE SESSIONS;")
    data=request.json
    phone=data['phone']
    execute_insert_query(f"INSERT INTO SESSIONS(phone) VALUES {phone};")
    print(f"INSERT INTO SESSIONS(phone) VALUES {phone}")
    password=data['password']
    p = Person()
    status=p.login(password)
    if (status['status']=='FAIL'):
        return status
    elif (status['type']==0):
        c = Cashier()
        type=0
    elif (status['type']==1):
        m = Manager()
        type=1
    elif (status['type']==2):
        a = Admin()
        type=2
    elif (status['type']==3):
        cust = Customer()
        type=3
    return status

@app.route('/resetPassword',methods=['POST'])
def resetPass():
    data = request.json
    old = data['old_password']
    new = data['new_password']
    p=Person()
    valid = p.change_password(old,new)
    return valid

@app.route('/getDetails',methods=['GET'])
def dets():
    data=None
    dummy = Person()
    type = dummy.type
    if (type==0):
        c=Cashier()
        data=c.get_details()
    if (type==1):
        m=Manager()
        data=m.get_details()
    if (type==2):
        a=Admin()
        data=a.admin_get_details()
    if (type==3):
        cust=Customer()
        data=cust.get_details()
    return data
        
@app.route('/orderAnalytics',methods=['GET'])
def analytics():
    m=Manager()
    data=m.view_analytics()
    return data

@app.route('/getAllOrders',methods=['GET'])
def orders():
    m=Manager()
    data=m.view_order()
    return data

@app.route('/getCustomerOrders',methods=['GET'])
def customer_orders():
    cust=Customer()
    data = cust.getOrders()
    print(data)
    return (data)

@app.route('/getCashierOrders',methods=['GET'])
def cashier_orders():
    c=Cashier()
    data = c.get_todays_order()
    print(data)
    return (data)

@app.route('/getAllProducts',methods=['GET'])
def get_all_products():
    c=Cashier()
    data = c.get_all_products()
    return jsonify(data)

@app.route('/checkCoupon',methods=['POST'])
def checkValidCoupon():
    data=request.json
    print(data)
    coupon_name = data['coupon']
    c=Cashier()
    validity = c.check_coupon(coupon_name)
    return validity

@app.route('/checkCustomer',methods=['POST'])
def checkValidCustomer():
    data=request.json
    print(data)
    cust_phone = data['phone']
    c=Cashier()
    validity = c.check_customer(cust_phone)
    return validity

@app.route('/regCustomer',methods=['POST'])
def register_customer():
    data = request.json
    first_name = data['firstname']
    last_name = data['lastname']
    phone = int(data['phone'])
    email = data['email']
    c=Cashier()
    validity = c.reg(first_name,last_name,email,phone)
    return validity

@app.route('/createOrder',methods=['POST'])
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
    c=Cashier()
    validity = c.create_order(amount,products,coupon_id,cust_id,payment_type,senders_upi,card_no,expiry,cvv)
    print(validity)
    return validity

@app.route('/addCoupon',methods=['POST'])
def add_new_coupon():
    data = request.json
    coup_name = data['coupon_name']
    disc = data['discount']
    expiry = data['date']
    a=Admin()
    validity = a.add_coupon(coup_name,disc,expiry)
    return validity

@app.route('/addProduct',methods=['POST'])
def add_new_product():
    data = request.json
    prod_name = data['name']
    prod_price = data['price']
    prod_qty = data['qty']
    prod_cat = data['category']
    prod_war = data['warranty']
    a=Admin()
    validity = a.add_product(prod_name,prod_price,prod_qty,prod_cat,prod_war)
    return validity

@app.route('/getAllStores',methods=['GET'])
def get_all_stores():
    a=Admin()
    data = a.get_all_stores()
    return data

@app.route('/createWorker',methods=['POST'])
def create_worker():
    data = request.json
    fn = data['firstname']
    ln = data['lastname']
    phone_no = int(data['phone'])
    store = int(data['store_id'])
    type = int(data['type'])
    a=Admin()
    valid = a.create_new_worker(fn,ln,phone_no,store,type)
    return valid

