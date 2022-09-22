import requests

response = requests.get("https://mibillingsystem.herokuapp.com/getDetails",json={'phone':9231456879,'password':'Admin1'})