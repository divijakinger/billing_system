import requests

r=requests.post(url='http://127.0.0.1:5000/login',json={'phone':9909990989,'password':'cutie123'})
print(r.json())
r=requests.post(url='http://127.0.0.1:5000/createOrder',json={'products': [1,2,3,4], 'amount': 1300, 'coupon': -1, 'user_id': 19, 'payment_type': 0, 'senders_upi': '', 'communication_type': 'whatsapp','cardnumber': '', 'cardexpiry': '', 'cardcvv': ''})
print(r.json())
# r=requests.post(url='http://127.0.0.1:5000/regCustomer',json={'firstname': 'h', 'lastname': 'h', 'email': 'h', 'phone': '9'})
# print(r.json())

# # r=requests.get(url='http://127.0.0.1:5000/getDetails')
# print(r.json())
