import sklearn
import random
import matplotlib.pyplot as plt
import numpy as np
from io import BytesIO


# data = [{"Thing1": random.uniform(0, 1) < 0.5, "Thing2": random.uniform(
#     0, 1) < 0.5, "Thing3": random.uniform(0, 1) < 0.5} for i in range(10)]


def makeCounts(data):
    arr = [0 for i in data[0]]
    for i in data:
        for j in range(len(i)):
            arr[j]+=i[j]
    return arr

# print(data)
# print(makeCounts(data))

def makeHistogram(data):
    dat = makeCounts(data)
    val_array = dat
    label_array = ["pollen_level", "humidity_level", "aq", "temp", "elevation"]
    # print(label_array)
    fig = plt.figure()
    plt.bar(label_array, val_array)
    figdata = BytesIO()
    fig.savefig(figdata, format='png')
    return figdata

# makeHistogram(data)

def mostLikely(data):
    dat = makeCounts(data)
    x = np.array(dat)
    y = ["pollen_level", "humidity_level", "aq", "temp", "elevation"]
    q75, q25 = np.percentile(x, [75, 25])
    iqr = q75 - q25
    print(iqr)
    q90 = np.percentile(x, 90)
    print(q90)
    li = []
    for i in range(len(list(x))):
        if x[i] > q90:
            li.append(y[i])
    return str(set(li))

# print(mostLikely(data))
