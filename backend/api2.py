import flask
from flask import request, jsonify
import requests as req
import json

app = flask.Flask(__name__)
app.config["DEBUG"] = True



@app.route('/', methods=['GET'])
def home():
    return '''<h1>Welcome to the Asthma Alert Backend</h1>'''


# @app.route('/data/all', methods=['GET'])
# def api_all():
#     return jsonify(books)


@app.route('/data/alert', methods=['GET'])
def api_id():
    lat = lon = 0

    if 'lat' in request.args:
        lat = float(request.args['lat'])
    else:
        return "No latitude field provided. Please specify a latitude."

    if 'lon' in request.args:
        lon = float(request.args['lon'])
    else:
        return "No longitude field provided. Please specify a longitude."

    return ("Latitude = {}, Longitude = {}".format(lat, lon))


@app.route('/data/airquality', methods=['GET'])
def airquality():
    lat = lon = 0

    if 'lat' in request.args:
        lat = float(request.args['lat'])
    else:
        return "No latitude field provided. Please specify a latitude."

    if 'lon' in request.args:
        lon = float(request.args['lon'])
    else:
        return "No longitude field provided. Please specify a longitude."

    with open("airqualitykey.txt", "r") as f:
        test = "http://api.airvisual.com/v2/nearest_city?lat={}&lon={}&key={}".format(
            lat, lon, f.read())
        try: 
            print(lat, lon, f.read())
            x = req.get(test)
            fin = json.loads(x.text)["data"]["current"]["pollution"]["aqius"]
        except:
            return "There was an error processing your request."

    return str(fin)


app.run()
