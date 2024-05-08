import random
from itertools import count
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

#plt.style.use('fivethirtyeight')
plt.style.use('dark_background')

x_vals = []
y_vals = []

index = count()

def animate2(i):
    data = pd.read_csv('data1.csv')
    x1 = data['x_value']
    y1 = data['total_2']

    plt.cla()

    plt.plot(x1, y1, 'r', label='Trigger')
    plt.legend(loc='upper left')
    plt.tight_layout()

plt.figure("Trigger")
ani = FuncAnimation(plt.gcf(), animate2, interval=1000)
plt.tight_layout()

plt.show()
