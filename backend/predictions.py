import sklearn
import random
import matplotlib.pyplot as plt
import numpy as np

data = [{"Thing1": random.uniform(0, 1) < 0.5, "Thing2": random.uniform(
    0, 1) < 0.5, "Thing3": random.uniform(0, 1) < 0.5} for i in range(10)]


def makeCounts(data):
    obj = [0 for i in data[0]]
    for i in data:
        q = 0
        for j in i:
            if i[j]: obj[q]+=1
            q+=1
    q = 0
    hold = data[0]
    for i in hold:
        hold[i] = obj[q]
        q+=1
    return hold

print(data)
print(makeCounts(data))

def makeHistogram(data):
    dat = makeCounts(data)
    val_array = [dat[label] for label in dat]
    label_array = [label for label in dat]
    # print(label_array)
    plt.bar(label_array, val_array)
    plt.show()

# makeHistogram(data)

def mostLikely(data):
    dat = makeCounts(data)
    x = np.array([dat[label] for label in dat])
    y = [label for label in dat]
    q75, q25 = np.percentile(x, [75, 25])
    iqr = q75 - q25
    print(iqr)
    q90 = np.percentile(x, 90)
    print(q90)
    li = []
    for i in range(len(list(x))):
        if x[i] > q90:
            li.append(y[i])
    return set(li)

print(mostLikely(data))
