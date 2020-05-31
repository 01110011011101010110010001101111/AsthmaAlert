# AsthmaAlert
A mobile application that helps asthmatics by alerting them when they are in high risk areas and helping them identify the factors that contribute most to their asthma. 

## Inspiration
When I was in middle school, I went on a trip to India. On the plane ride back, my sister had an attack. As soon as we landed, we rushed her to the ER in America. To this day, we still don't know what caused the attack. It could've been the altitude or it could've been the bad air pollution in India or a combination of both; if we were to go again, we would be unprepared like we were in the plane. <br>
<br>
Many of our team members have had asthma affect our lives personally. Two experienced asthma at a young age and have family members who have asthma. We've noticed that many members of our community—friends, colleagues, and family—have experienced asthma and have had potentially life-threatening attacks, taking them to the ER. 

## What it does
Our application has three main purposes:<br>
<ol>
<li>An emergency button which a user can press during an attack to contact their loved one.</li>
<li>Real-time APIs which collect data from your location and uses machine learning to alert you when you're in a potentially hazardous location (i.e. the chance of you having an attack is high).</li>
<li>Machine learning to predict what triggers your unique asthma attacks.</li>
</ol>

## How we built it
In order to develop our project, we used Flutter for the frontend mobile app, and created our own Flask REST API from scratch for the backend. We also integrated several APIs such as Google Cloud’s Elevation API to gain access to the environmental factors that affect Asthma such as elevation, pollen levels, humidity, temperature, and air quality index. Finally, we used both two database services: Firebase for user authentication and login and MongoDB to store data related to the environmental factors 

### Alert
The first core feature is the alert feature. In order to predict and alert the user of a potential attack, we used flutter’s geolocator plugin to retrieve the coordinates of the user asynchronously. Then, after finding the pollen level, humidity, temperature, elevation, and air quality index at the user’s location, we used a random forest classification algorithm trained on 10,000 observations with 99.5% accuracy to predict whether the user is prone to an asthma attack at his current location.

### Factor Identification
In order to identify the most important contributing factors, we read through the factors which were present at high levels during the recorded attacks. We used a second machine learning algorithm and performed a statistical analysis to determine outliers from the data which could be potential triggers that the user didn’t know. This algorithm creates a confidence interval. If a value is statistically significant, the algorithm proposes that the factor could be a trigger. This data is also displayed in a bar graph. Overall, this feature helps users understand why they had an attack and gives them data to be prepared for future attacks.

## Challenges we ran into
Our major challenge was combining the Flask with Flutter. To do this, we created an API using Flask. One of our first challenges was mounting our Flask server on Heroku. We kept on getting errors, so we ended up having to add the functions one by one to debug. In addition, we had to find a way to change the matplotlib.pyplot graph to a base64 string to send it to Dart to be compatible. We also had to figure out how to get Dart to send the requests and access the data from the Python and DB. Finally, the most challenging part of the project was that our team learned the new language flutter as well as how to build REST API's in order to develop the mobile application and the backend.

## Accomplishments that we're proud of
We're proud that we were able to get the app functional after many trials and errors. The integration of the flask api and the flutter was really challenging, but we are proud to have learned how to accomplish that successfully. Finally, we are proud of learning how to build a complete REST API with Flask from scratch for the first time, incorporating 2 machine learning algorithms with our API and Flutter, and and getting our api deployed on a web server succesfully!

## What we learned
Overall, we learned:
<ul>
<li>How to connected Flask and Flutter together to create a nice mobile app with powerful machine learning.</li>
<li>We learned how to use Flask as an API.</li>
<li>We discovered new APIs and accessed them.</li>
</ul>

## What's next for Asthma Alert
We hope to create a more robust version of our application. Once we iron out some bugs through testing, we hope to see if we can make it a startup and push it out for our community and the world to us.
