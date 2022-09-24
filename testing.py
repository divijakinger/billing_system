from urllib import response
import requests

response = requests.post("https://mibillingsystem.herokuapp.com/login",json={'phone':9231456879,'password':'admin1'})
print(response.json())

response = requests.get("https://mibillingsystem.herokuapp.com/getDetails")

print(response.json())

