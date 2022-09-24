import requests
response = requests.post("https://mibillingsystem.herokuapp.com/login",json={'phone':9231456879,'password':'Admin1'})
response = requests.get("https://mibillingsystem.herokuapp.com/getDetails")