import flask
from flask import request, jsonify
from retrieve_parameters import pollen_level, humidity_level, elevation_level, airquality, temperature

app = flask.Flask(__name__)
app.config["DEBUG"] = True

# Create some test data for our catalog in the form of a list of dictionaries.
books = [
    {'id': 0,
     'title': 'A Fire Upon the Deep',
     'author': 'Vernor Vinge',
     'first_sentence': 'The coldsleep itself was dreamless.',
     'year_published': '1992'},
    {'id': 1,
     'title': 'The Ones Who Walk Away From Omelas',
     'author': 'Ursula K. Le Guin',
     'first_sentence': 'With a clamor of bells that set the swallows soaring, the Festival of Summer came to the city Omelas, bright-towered by the sea.',
     'published': '1973'},
    {'id': 2,
     'title': 'Dhalgren',
     'author': 'Samuel R. Delany',
     'first_sentence': 'to wound the autumnal city.',
     'published': '1975'}
]


@app.route('/', methods=['GET'])
def home():
    return '''<h1>Welcome to the Asthma Alert Backend</h1>'''


@app.route('/data/all', methods=['GET'])
def api_all():
    return jsonify(books)


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

    pollen = pollen_level(lat, lon)
    humidity = humidity_level(lat, lon)
    elevation = elevation_level(lat, lon)
    aq = airquality(lat, lon)
    temp = temperature(lat, lon)
    
    results = {
                  'Pollen': pollen,
                  'Humidity': humidity,
                  'Elevation': elevation,
                  'Air Quality': aq,
                  'Temperature': temp
              }
    return jsonify(results)


    # results = {
    #               "status":""
    #           }
    # results["status"] = "True"
    # results = []

    # return jsonify(results)

app.run()