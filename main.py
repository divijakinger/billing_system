# from utilities.classes.orders import Orders
# from utilities.classes.payment import Payment
# from utilities.classes.people import *
# from utilities.classes.product import Product
from worker import *  
from datetime import date

# print(date.today())
# c = Customer(9637647396,'divija123')
# c.getOrders()

c = Cashier(9909990989,'cutie123');
print(c.login())
print(c.reg('customer','four','cust2@gmail.com',9909918888))
# m = Worker(9619451797,'manager123')
# print(m.get_details())