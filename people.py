from datetime import date, timedelta
from connections import *
import json

class Person():
  def __init__(self,phone,password):
    self.phone = phone
    self.password = password
    id_query = f"SELECT USER_ID from USERS WHERE PHONE={(phone)} and PASS='{str(password)}';"
    # query = 'SELECT worker_id,branch from workers INNER JOIN store ON workers.store_id=store.store_id where phone='+ str(self.phone);
    id_result = execute_select_query(id_query);
    if (len(id_result)!=0):
      id = id_result[0][0]
      self.id = id

  def login(self):
    login_query = f"SELECT USER_TYPE from USERS WHERE PHONE={(self.phone)} and PASS='{str(self.password)}';"
    login_result = execute_select_query(login_query)
    if (len(login_result) == 0 ):
      return({'status':'FAIL'})
    else:
      return({'status':'SUCCESS','type':login_result[0][0]})

  def change_password(self,old_pass,new_pass):
    if (old_pass==self.password):
        self.password = new_pass
        change_pass_query = f"UPDATE USERS SET PASS='{new_pass}' where USER_ID={self.id};"
        if (execute_insert_query(change_pass_query)):
          print("working")
          return {'status':'SUCCESS'}
        return {'status':'FAIL'}


class Customer(Person):
  
  def getOrders(self):
    orders_query = f"Select ORDER_DATE,PROD_NAME,PROD_PRICE,CAT_NAME,WARRANTY_MONTHS FROM ORDERS,ORDER_PRODUCT,PRODUCT,CATEGORY WHERE ORDER_PRODUCT.PRODUCT_ID=PRODUCT.PROD_ID and PRODUCT.CATEGORY_ID=CATEGORY.CAT_ID and ORDERS.ORDER_ID=ORDER_PRODUCT.ORDER_ID AND CUSTOMER_ID={self.id};"
    customer_orders = execute_select_query(orders_query)
    todays_date = date.today()
    result = {}
    count = 1
    for row in customer_orders:
      days_since = (todays_date - row[0])
      waranty_left = json.dumps(days_since-timedelta(days=row[4]),default=str)
      waranty = int(waranty_left.split(',')[0].split()[0][1:])
      if (waranty<0):
        waranty = 0
      result[count] = {
        'product_name' : row[1],
        'warranty' : waranty,
        'price' : row[2],
        'category' : row[3]
      }
      count+=1
    final = []
    for i in result.keys():
      final.append(result[i])
    return {'status':'SUCCESS','data':final}
  
  def get_details(self):
    id_query = f"SELECT USER_ID from USERS WHERE PHONE={(self.phone)} and PASS='{str(self.password)}';"
    id_result = execute_select_query(id_query);
    id = id_result[0][0]
    self.id = id
    det_query = f"SELECT firstname,lastname,loyalty_pts from USERS,CUSTOMERS where USERS.user_id = CUSTOMERS.cust_id and USERS.user_id={id}"
    det_result = execute_select_query(det_query)
    details = det_result[0]
    firstname=details[0]
    lastname=details[1]
    loyalty_pts=details[2]
    return {'firstname':firstname,'lastname':lastname,'loyalty_points':loyalty_pts}
