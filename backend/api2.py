# import flask
from flask import request, jsonify
from flask_pymongo import PyMongo
import requests as req
import json

app = flask.Flask(__name__)
app.config["DEBUG"] = True

KEY = "mongodb+srv://dbUser:jCx!zG3X6HzqsT*@asthmaalert-q46ku.mongodb.net/test?retryWrites=true&w=majority"

app.config["MONGO_URI"] = KEY
client = PyMongo(app)
db = client.db.users
EMAIL = ""


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

'''
Adds a user: user and triggers
'''
@app.route("/data/newUser", methods=["POST"])
def createUser():
    global EMAIL
    if 'user' in request.args:
        EMAIL = (request.args['user'])
    else: 
        return "No Email Provided. Please Provide an Email"
    if 'triggers' in request.args:
        trig = (request.args['triggers'])
    else:
        return "No Triggers Provided. Please Provide a Trigger"
    user = {"email": EMAIL, "triggers": trig, "past_attacks": []}

'''
Adds new trigger data given input
'''
@app.route("/data/newTrigger", methods=["POST"])
def addTrigger():
    global EMAIL
    if 'triggers' in request.args:
        trig = request.args['triggers']
    else:
        return "No Triggers Provided. Please Provide a Trigger"
    x = db.find_one({"email": EMAIL})
    x["past_attacks"].append(trig)
    

app.run()
