import requests as req 
import json

url = 'https://www.w3schools.com/python/demopage.php'
myobj = {'somekey': 'somevalue'}

LATITUDE = 29
LONGITUDE = -98

test = "http://api.airvisual.com/v2/nearest_city?lat={}&lon={}&key={}".format(LATITUDE, LONGITUDE, YOUR_API_KEY)

x = req.get(test)

print(json.loads(x.text)["data"]["current"]["pollution"]["aqius"])


