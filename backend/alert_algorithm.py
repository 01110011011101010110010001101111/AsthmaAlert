import pickle
from retrieve_parameters import pollen_level, humidity_level, elevation_level, airquality, temperature
from flask import request, jsonify
from makecsv import create_data
from random_forest_classification import random_forest



def alert(lat, lon, trigs, trained):
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

    if 'pollen' not in trigs:
        pollen_high = False
    if 'aq' not in trigs:
        aq_high = False
    if 'elevation' not in trigs:
        elevation_high = False
    if 'humidity' not in trigs:
         humidity_high = False
    if 'temp' not in trigs:
        temp_high = False
    
    high = []
    if pollen_high:
        high.append('pollen')
    if elevation_high:
        high.append('elevation')
    if aq_high:
        high.append('air pollution')
    if humidity_high:
        high.append('humidity')
    if temp_high:
        high.append('temperature')

    filename = 'Alert-ML-model.pkl'
    if trained == False:
        print("nottrained")
        create_data(10000, trigs)
        random_forest(filename)
        
    loaded_model = pickle.load(open(filename, 'rb'))
    result = loaded_model.predict([[pollen_val,elevation,temp, aq, humidity]])[0]

    if result == 0:
        alertStatus = False
        message = ""
    elif result == 1:
        alertStatus = True
        if len(high) > 3:
            message = "Be careful of an Asthma Attack!"
        elif len(high) == 3 :
            message = "Be careful of the high {}, {}, and {}!".format(high[0], high[1], high[2])
        elif len(high) == 2 :
            message = "Be careful of the high {} and {}!".format(high[0], high[1])
        else:
            if 'pollen' in high and len(pollen_high_plant) == 1:
                message = "Be careful of the high levels of pollen, especially {}!".format(pollen_high_plant[0])
            elif 'pollen' in high and len(pollen_high_plant) == 2:
                message = "Be careful of the high levels of pollen, especially {} and {}!".format(pollen_high_plant[0], pollen_high_plant[1])
            elif 'pollen' in high and len(pollen_high_plant) > 2:
                string = ""
                for i in range(len(pollen_high_plant)-1):
                    string += pollen_high_plant[i] + ", "
                print(string)
                message = "Be careful of the high levels of pollen, especially {}and {}!".format(string, pollen_high_plant[-1])
            elif 'air pollution' in high:
                message = "Be careful of the high air pollution!"
            elif 'elevation' in high:
                message = "Be careful of the high elevation!"
            elif 'temperature' in high:
                message = "Be careful of the high temperature!"
            elif 'humidity' in high:
                message = "Be careful of the high humidity!"
            else:
                message = "Be careful of an Asthma Attack!"

    
    results = {
                  'Alert' : alertStatus,
                  'Message' : message,
              }
    return jsonify(results)