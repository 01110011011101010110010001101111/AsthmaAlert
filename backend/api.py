import flask
from flask import request, jsonify
from retrieve_parameters import pollen_level, humidity_level, elevation_level, airquality, temperature
import pickle
from flask_pymongo import PyMongo

app = flask.Flask(__name__)
app.config["DEBUG"] = True

KEY = "mongodb+srv://dbUser:jCx!zG3X6HzqsT*@asthmaalert-q46ku.mongodb.net/test?retryWrites=true&w=majority"

app.config["MONGO_URI"] = KEY
client = PyMongo(app)
db = client.db.users
EMAIL = ""

app.config["MONGO_URI"] = KEY
client = PyMongo(app)
db = client.db.users
EMAIL = ""

@app.route('/', methods=['GET'])
def home():
    return '''<h1>Welcome to the Asthma Alert Backend</h1>'''

@app.route('/data/alert', methods=['GET'])
def api_id():
    lat = lon = 0

    triggers = ["Pollen"]

    if 'lat' in request.args:
        lat = float(request.args['lat'])
    else:
        return "No latitude field provided. Please specify a latitude."

    if 'lon' in request.args:
        lon = float(request.args['lon'])
    else:
        return "No longitude field provided. Please specify a longitude."

    pollen = pollen_level(lat, lon)
    humidity = humidity_level(lat, lon)
    elevation = elevation_level(lat, lon)
    aq = airquality(lat, lon)
    temp = temperature(lat, lon)


    pollen_high_plant = []
    pollen_high = False
    pollen_val = 0
    if pollen != None:
        for plant in pollen:
            if pollen[plant] > pollen_val:
                pollen_val = pollen[plant]
            if pollen[plant] == 5:
                pollen_high_plant.append(plant)
                pollen_high = True

    
    humidity_high = False
    if humidity != None:
        if humidity >= 90:
            humidity_high = True

    elevation_high = False
    if elevation != None:
        if elevation >= 1524:
            elevation_high = True
    
    aq_high = False
    if aq != None:
        if aq >= 101:
            aq_high = True

    temp_high = False
    if temp != None:
        if temp <= 260.928 or temp >= 322.039:
            temp_high = True    

    filename = 'Alert-ML-model.pkl'
    loaded_model = pickle.load(open(filename, 'rb'))
    result = loaded_model.predict([[pollen_val,elevation,temp, aq, humidity]])[0] 

    if result == 0:
        alertStatus = False
        message = ""
    elif result == 1:
        alertStatus = True
        if pollen_high == True and aq_high == True:
            message = "Be careful of the high AQI and the high levels of Pollen!"
        elif pollen_high == True:
            if len(pollen_high_plant) == 1:
                message = "Be careful of the high levels of pollen, especially {}!".format(pollen_high_plant[0])
            elif len(pollen_high_plant) == 2:
                message = "Be careful of the high levels of pollen, especially {} and {}!".format(pollen_high_plant[0], pollen_high_plant[1])
            else:
                string = ""
                for i in range(len(pollen_high_plant)-1):
                    string += pollen_high_plant[i] + ", "
                print(string)
                message = "Be careful of the high levels of pollen, especially {}and {}!".format(string, pollen_high_plant[-1])
        elif aq_high == True:
            message = "Be careful of the high AQI!"

    
    results = {
                  'Alert' : alertStatus,
                  'Message' : message,
              }
    return jsonify(results)


'''
Adds a user: user and triggers
'''


@app.route("/newUser", methods=["POST"])
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
    db.insert_one(user)


'''
Adds new trigger data given input
'''


@app.route("/newAttack", methods=["POST"])
def addAttack():
    global EMAIL
    if 'triggers' in request.args:
        trig = request.args['triggers']
    else:
        return "No Triggers Provided. Please Provide a Trigger"
    x = db.find_one_or_404({"email": EMAIL})
    x["past_attacks"].append(trig)
    x = {"$set": x}
    db.update_one(db.find_one_or_404({"email": EMAIL}), x)


app.run()
