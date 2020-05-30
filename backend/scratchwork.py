import requests as req 
import json

url = 'https://www.w3schools.com/python/demopage.php'
myobj = {'somekey': 'somevalue'}

LATITUDE = 29
LONGITUDE = -98
KEY = "H6XyiCT0w1t9GgTjqhRXxDMrVj9h78ya3NuxlwM7XUs"

test = "http://api.airvisual.com/v2/nearest_city?lat={}&lon={}&key={}".format(LATITUDE, LONGITUDE, KEY)

test2 = "https://weather.ls.hereapi.com/weather/1.0/report.json?product=observation&latitude={}&longitude={}&oneobservation=true&apiKey={}".format(LATITUDE, LONGITUDE, KEY)

test3 = "http://api.openweathermap.org/data/2.5/weather?lat=35&lon=139&key=f10eb0c33732395b3ae7d8298c240f6a"

x = req.get(test3)

print(json.loads(x.text))


