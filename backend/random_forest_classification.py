
#####################
# RANDOM FOREST CLASSIFICATION
#####################

# Importing the libraries
def random_forest(filename):
    import numpy as np
    import matplotlib.pyplot as plt
    import pandas as pd
    import time
    import pickle

    # Importing the dataset
    dataset = pd.read_csv('data.csv')
    X = dataset.iloc[:, :-1].values
    y = dataset.iloc[:, -1].values

    # Splitting the dataset into the Training set and Test set
    from sklearn.model_selection import train_test_split
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.2, random_state = 0)

    # # Feature Scaling
    # from sklearn.preprocessing import StandardScaler
    # sc = StandardScaler()
    # X_train = sc.fit_transform(X_train)
    # X_test = sc.transform(X_test)

    # Training the Random Forest Classification model on the Training set
    from sklearn.ensemble import RandomForestClassifier
    classifier = RandomForestClassifier(n_estimators = 2, criterion = 'entropy', random_state = 0)
    classifier.fit(X_train, y_train)

    filename = filename
    pickle.dump(classifier, open(filename, 'wb'))
  

# print(classifier.predict([[1,1,1,1,1]])[0])

# Predicting the Test set results
# y_pred = classifier.predict(X_test)

# # Making the Confusion Matrix
# from sklearn.metrics import confusion_matrix, accuracy_score
# cm = confusion_matrix(y_test, y_pred)
# score = accuracy_score(y_test, y_pred)
# print("Random Forest", score)