class Orders():

  def __init__(self,prod_dict,total_amount,customer_id,coupon_id,is_loyal):
    self.prod_dict = prod_dict
    self.total_amount = total_amount
    self.customer_id = customer_id
    self.coupon_id = coupon_id

  def create(order_id,Order):
    #Query to connect to db and create order
    return

  def cancel_order(order_id):
    #Query to cancel order
    return

  def give_loyalty(customer_id,order_id):
    # Query to deduct loyalty points
    return