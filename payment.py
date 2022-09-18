from connections import *

class Payment():
  def __init__(self,payment_id):
    self.pay_id = payment_id
  
  def insert_cash(self):
    insert_query = f"INSERT INTO PAYMENT(PAY_ID,PAY_TYPE) VALUES {self.pay_id,0};"
    if (execute_insert_query(insert_query)):
      return True
    return False

  


class Upi(Payment):
  def __init__(self,payment_id,senders_upi_id):
    super().__init__(payment_id)
    self.senders_upi_id = senders_upi_id

    
  def insert_upi(self):
    insert_query = f"INSERT INTO PAYMENT(PAY_ID,PAY_TYPE,SENDER_UPI) VALUES {self.pay_id,1,self.senders_upi_id};"
    print(insert_query)
    if (execute_insert_query(insert_query)):
      return True
    return False

class Card(Payment):
  def __init__(self, payment_id,card_no,expiry,cvv):
    super().__init__(payment_id)
    self.card_no = card_no
    self.expiry = expiry
    self.cvv = cvv
  
  def insert_card(self):
        insert_query = f"INSERT INTO PAYMENT(PAY_ID,PAY_TYPE,CARD,EXPIRY,CVV) VALUES {self.pay_id,2,self.card_no,self.expiry,self.cvv};"
        if (execute_insert_query(insert_query)):
          return True
        return False

