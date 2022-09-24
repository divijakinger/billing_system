from classes.people import *
from classes.payment import *
from classes.connections import *

class Worker(Person):
  def generate_pass(self,name):
    password = name + '123'
    return password

  def get_details(self):
    print(self.id)
    branch_query = f"SELECT BRANCH FROM STORE WHERE store_id=(SELECT store_id from workers where workers.worker_id={self.id});"
    branch_result = execute_select_query(branch_query)
    branch = branch_result[0][0]
    det_query = f"SELECT firstname,lastname from USERS where USERS.user_id={self.id};"
    det_result = execute_select_query(det_query)
    details = det_result[0]
    firstname=details[0]
    lastname=details[1]
    return {'id':self.id,'branch':branch,'firstname':firstname,'lastname':lastname}

class Admin(Worker):
  def admin_get_details(self):
      det_query = f"SELECT firstname,lastname from USERS where USERS.user_id={self.id};"
      det_result = execute_select_query(det_query)
      details = det_result[0]
      firstname=details[0]
      lastname=details[1]
      return {'id':self.id,'firstname':firstname,'lastname':lastname}

  def add_coupon(self,coupon_name,discount,expiry):
    insert_coupon_query = f"INSERT INTO COUPONS(coupon_name,discount,expiry) VALUES ('{coupon_name}',{discount},'{expiry}');"
    result = execute_insert_query(insert_coupon_query);
    if (result):
      return {'status':'SUCCESS'}
    return{'status':'FAIL'}


  def add_product(self,p_name,p_price,p_qty,p_cat,warranty_months):
    add_query = f"INSERT INTO PRODUCT(prod_name,category_id,warranty_months,prod_price,prod_qty) VALUES ('{p_name}',{p_cat},{warranty_months},{p_price},{p_qty});"
    print(add_query)
    result = execute_insert_query(add_query)
    if (result):
      return {'status':'SUCCESS'}
    return{'status':'FAIL'}
  
  def get_all_stores(self):
    find_query = f"SELECT STORE_ID,BRANCH FROM STORE"
    stores = execute_select_query(find_query)
    final = []
    for i in stores:
      final.append(list(i))
    return {'status':'SUCCESS','data':final}
  
  def create_new_worker(self,firstname,lastname,phone,store_id,type):
    generated_pass = self.generate_pass(firstname);
    print(generated_pass)
    insert_query = f"INSERT INTO USERS(user_type,phone,lastname,firstname,pass) VALUES ({type},{phone},'{lastname}','{firstname}','{generated_pass}');"
    print(insert_query);
    if (execute_insert_query(insert_query)):
      w = Worker(phone,generated_pass)
      worker_query = f"INSERT INTO WORKERS(WORKER_ID,WORKER_TYPE,STORE_ID) VALUES ({w.id},{type},{store_id});"
      print(worker_query)
      if (execute_insert_query(worker_query)):
        return {'status':'SUCCESS'}
      else:
        execute_insert_query(f"DELETE FROM USERS WHERE USER_ID={w.id}")
    else :
      return {'status':'FAIL'}

class Cashier(Worker):

  def get_todays_order(self):
    order_query = f"Select ORDERS.ORDER_ID,AMOUNT,PAY_TYPE,PROD_NAME FROM ORDERS,PAYMENT,ORDER_PRODUCT,PRODUCT where ORDERS.ORDER_ID=ORDER_PRODUCT.ORDER_ID and ORDER_PRODUCT.PRODUCT_ID= PRODUCT.PROD_ID and ORDERS.PAYMENT_ID = PAYMENT.PAY_ID and cashier_id={self.id} and order_date=current_date;"
    orders_all = execute_select_query(order_query)
    print(orders_all)
    if (len(orders_all)==0):
      print("I AM HERE")
      return {'status':'SUCCESS','data':[]}
    orders = {}
    for row in orders_all:
      if (row[2]==0):
        pay = 'cash'
      elif(row[2]==1):
        pay = 'upi'
      else :
        pay = 'card'
      if(row[0] in orders.keys()):
        orders[row[0]]['products'].append(row[3])
      else:
        orders[row[0]]={'products':[row[3]],'amount':row[1],'payment_method':pay}
    final = []
    for i in orders.keys():
      final.append(orders[i])
    return {'status':'SUCCESS','data':final}

  def get_all_products(self):
    products_query = "Select PROD_ID,PROD_NAME,PROD_PRICE FROM PRODUCT;"
    print(products_query)
    products = execute_select_query(products_query);
    final = []
    for i in products:
      final.append(list(i))
    print(final)
    return {'status':'SUCCESS','data':final}

  def reg(self,firstname,lastname,email,phone):
    generated_pass = self.generate_pass(firstname);
    print(generated_pass)
    users_query = f"Insert into USERS(user_type,phone,lastname,firstname,pass) VALUES (3,{phone},'{lastname}','{firstname}','{generated_pass}');"
    print(users_query)
    if (execute_insert_query(users_query)):
      find_id = execute_select_query(f"SELECT USER_ID from USERS WHERE PHONE={phone}")[0][0]
      customer_query = f"INSERT INTO CUSTOMERS(CUST_ID,EMAIL,LOYALTY_PTS) VALUES ({find_id},'{email}',0);"
      print(customer_query)
      if (execute_insert_query(customer_query)):
        return {'status':'SUCCESS','user_id':find_id}
      else :
        execute_insert_query(f"DELETE FROM USERS WHERE USER_ID={find_id}")
    return {'status':'FAIL'}
    
  def check_customer(self,phone_no):
    customer_query = f"SELECT USER_ID,FIRSTNAME,LASTNAME,EMAIL,LOYALTY_PTS FROM USERS,CUSTOMERS where USERS.USER_ID = CUSTOMERS.CUST_ID and PHONE={phone_no}"
    customer_details = execute_select_query(customer_query)
    if (len(customer_details)==0):
      return {'status':'FAIL'}
    return {'status':'SUCCESS','data':[customer_details[0][0],customer_details[0][1],customer_details[0][2],customer_details[0][3],customer_details[0][4]]}
  
  def generate_invoice(order_id):
    #generate invoice of order
    return

  def check_coupon(self,coupon_name):
    coupon_query = f"Select coupon_id,discount from coupons where coupon_name='{coupon_name}' and expiry>current_date;"
    valid_coupon = execute_select_query(coupon_query);
    if (len(valid_coupon)>=1):
      return {'status':'SUCCESS','data':[valid_coupon[0][0],valid_coupon[0][1]]}
    return {'status':'FAIL'}

  def create_order(self,amount,products,coupon_id,cust_id,payment_type,senders_upi,card,expiry,cvv):
    order_query = f"INSERT INTO ORDERS (cashier_id,coupon_id,amount,customer_id,order_date) VALUES ({self.id},{coupon_id},{amount},{cust_id},current_date);"
    if (execute_insert_query(order_query)):
      find_order_id_query = "SELECT ORDER_ID,PAYMENT_ID FROM ORDERS where order_id=(SELECT MAX(ORDER_ID) from ORDERS);"
      order_details = execute_select_query(find_order_id_query);
      order_id = order_details[0][0]
      payment_id = order_details[0][1]
      if(payment_type==0):
        pay = Payment(payment_id)
        success = pay.insert_cash()
      elif (payment_type==1):
        pay = Upi(payment_id,senders_upi)
        success = pay.insert_upi();
      else:
        pay = Card(payment_id,card,expiry,cvv)
        success = pay.insert_card();
      
      if (success):
        for i in products:
          insert_into_op_query = f"INSERT INTO ORDER_PRODUCT(ORDER_ID,PRODUCT_ID) VALUES ({order_id},{i});"
          successful = execute_insert_query(insert_into_op_query);
          if (successful):
            continue
          else:
            try:
              order_try = execute_insert_query(f"DELETE FROM ORDERS WHERE ORDER_ID={order_id};")
              pay_try = execute_insert_query(f"DELETE FROM PAYMENT WHERE PAYMENT_ID={pay.pay_id};")
            except:
              pass
            return {'status':'FAIL'}
        return {'status':'SUCCESS'}
      else : return {'status':'FAIL'}
    else : return {'status':'FAIL'}
            
class Manager(Worker):
  def view_order(self):
    #Query to view all orders
    store_query = f"SELECT STORE_ID FROM WORKERS WHERE WORKER_ID={self.id}"
    store_id = execute_select_query(store_query)[0][0]
    all_orders = f"SELECT ORDERS.ORDER_ID,PROD_NAME,AMOUNT FROM ORDERS,ORDER_PRODUCT,PRODUCT WHERE CASHIER_ID=ALL(SELECT CASHIER_ID FROM WORKERS WHERE STORE_ID={store_id}) AND ORDERS.ORDER_ID=order_product.ORDER_ID AND PRODUCT.PROD_ID=ORDER_PRODUCT.PRODUCT_ID;"
    get_all_orders = execute_select_query(all_orders)
    orders = {}

    for row in get_all_orders:
      if(row[0] in orders.keys()):
        orders[row[0]]['product'].append(row[1])
      else:
        orders[row[0]]={'product':[row[1]],'price':row[2]}
    
    final = []
    for i in orders.keys():
      orders[i]['order_id'] = i
      final.append(orders[i])
    return {'status':'SUCCESS','data':final}
  
  def view_analytics(self):
    try:
      branch_query = f"SELECT BRANCH from STORE,WORKERS where worker_id={self.id} and WORKERS.store_id=STORE.store_id;"
      branch_results = execute_select_query(branch_query)
      branch = branch_results[0][0]
      print(branch)
      sales_query = f"SELECT SUM(AMOUNT) FROM ORDERS,WORKERS,STORE where ORDERS.CASHIER_ID=WORKERS.WORKER_ID and WORKERS.STORE_ID=STORE.STORE_ID and BRANCH='{branch}'"
      sales_results = execute_select_query(sales_query)
      total_sales = (sales_results[0][0])
      max_product_query_1= f"select PRODUCT_ID from ORDER_PRODUCT group by PRODUCT_ID order by count(*) desc LIMIT 1"
      max_product_id = execute_select_query(max_product_query_1)[0][0]
      max_product_query_2 = f"SELECT PROD_NAME from PRODUCT WHERE prod_id={max_product_id}"
      max_product_name = execute_select_query(max_product_query_2)[0][0]
      return {'status':'SUCCESS','total_sales':float(total_sales),'bestselling_product':max_product_name}
    except:
      return {'status':'FAIL'}
