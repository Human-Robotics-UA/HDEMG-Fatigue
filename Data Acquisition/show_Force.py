import random
from itertools import count
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
import numpy as np
#plt.style.use('fivethirtyeight')
plt.style.use('dark_background')

x_vals = []
y_vals = []

index = count()

def animate(i):
    data = pd.read_csv('data1.csv')
    x1 = data['x_value']
    y1 = data['total_1']

    maxi=min(y1)
    range1 = maxi*0.7
    range2 = maxi*0.4

    plt.cla()



    plt.plot(x1, -y1, label='Total Force')
    plt.plot(x1,-np.ones(len(x1))*maxi,'--r',label='Maximal Force')
    #plt.plot(x1,np.ones(len(x1))*range1,'--g', label='70% Maximal Force')
    plt.plot(x1,-np.ones(len(x1))*range2,'--g', linewidth = 5, label='40% Maximal Force')
    plt.legend(loc='upper left')
    plt.xlabel("samples")
    plt.ylabel("Force(N)")
    plt.tight_layout()

#plt.figure("Total Force")
ani = FuncAnimation(plt.gcf(), animate, interval=5)
plt.tight_layout()

plt.show()
