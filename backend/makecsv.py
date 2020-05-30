import csv
import random

records=1000
print("Making %d records" % records)

fieldnames=['Pollen','Elevation','Temperature','Air quality',"Humidity","Asthma attack"]
writer = csv.DictWriter(open("data.csv", "w"), fieldnames=fieldnames)

names=['Deepak', 'Sangeeta', 'Geetika', 'Anubhav', 'Sahil', 'Akshay']
cities=['Delhi', 'Kolkata', 'Chennai', 'Mumbai']

writer.writerow(dict(zip(fieldnames, fieldnames)))
for i in range(0, records):
    pollen = random.randint(1,5)
    elevation = random.randint(1,2000)
    humidity = random.randint(1,100)
    aq = random.randint(1,120)
    temp = random.randint(255,327)
    attack = 0

    temp_high = False
    humidity_high = False
    elevation_high = False
    aq_high = False
    pollen_high = False

    if temp <= 260.928 or temp >= 322.039:
        temp_high = True 
    if humidity >= 90:
        humidity_high = True
    if elevation >= 1524:
        elevation_high = True
    if aq >= 101:
        aq_high = True
    if pollen == 5:
        pollen_high = True
    
    # if temp_high == True or elevation_high == True or humidity_high == True or aq_high == True or pollen_high == True:
    if aq_high == True or pollen_high == True:
        attack = 1

    writer.writerow(dict([
    ('Pollen', pollen),
    ('Elevation', elevation),
    ('Temperature', temp),
    ('Air quality', aq),
    ('Humidity', humidity),
    ('Asthma attack', attack)]))