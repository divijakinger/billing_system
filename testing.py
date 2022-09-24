import requests

response = requests.post("http://127.0.0.1:5000/login",json={'phone':9231456879,'password':'admin1'})

print(response.json())