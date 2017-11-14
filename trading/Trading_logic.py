import pandas as pd
import numpy as np
from Naked.toolshed.shell import execute_js,muterun_js
import sys
import json, urllib.request
import csv

with urllib.request.urlopen("https://www.energy-charts.de/price/week_2017_45.json") as url:
    data = json.loads(url.read().decode())
all_prices = data[1]["values"]
with open('Prices_2017.csv','w',newline='') as csvfile:
    spamwriter = csv.writer(csvfile)
    spamwriter.writerow(['Timestamp','prices'])
    for i in range(len(all_prices)):
        spamwriter.writerow(all_prices[i])

#get the time and price dataframe
df_prices = pd.read_csv('Prices_2017.csv')
df1_prices = df_prices.set_index("Timestamp")
size_prices = df1_prices.shape

#toggle on off, report power at the instant (rules for the smart meter)
#get the time and power dataframe from devices in one file
total_devices = 2
dfs = []
for num in range(total_devices):
    df = pd.read_csv("Power_2017_"+str(num+1)+".csv")
    df = df.ix[:,1:2]
    df.columns = ["Device_"+str(num+1)]
    dfs.append(df)
merged = pd.concat(dfs,axis=1)
merged['timestamp'] = df_prices.iloc[:,0]
merged['prices'] = df_prices.iloc[:,1]
merged.to_csv('Power_2017.csv')

# get the price and the battery status for all the devices
Power = pd.read_csv("Power_2017.csv")
Power['Prices_1']=Power.Device_1 * Power.prices/1000
Power['Prices_2']=Power.Device_2 * Power.prices/1000
Power['Battery_status_1']=np.random.randint(1,100,Power.shape[0])
Power['Battery_status_2']=np.random.randint(1,100,Power.shape[0])

#set limit for prices and store energy
price_limit = Power["prices"].mean()

#trade between all the devices
time_per_charge_1_percent = 1/15 #1 time interval i.e. takes 1 minutes to charge 1%
energy_per_charge_per_percent = 5 #number of KW energy it takes to charge the device for 1%
Trading_energy=[0]*len(Power)
From = [0]*len(Power)
To = [0]*len(Power)
for i in range(len(Power)):
    price = Power.get_value(i, "prices")
    #Scenario 1: if the price is less than the price limit
    if price < price_limit:
        # check the one with higher consumption need
        if Power.get_value(i,"Device_1") > Power.get_value(i,"Device_2"):
            # if the higher consumption device has has no storage energy, then charge it
            if Power.get_value(i,"Battery_status_1")<70:
                Power.ix[i,"Battery_status_1"] = 70
            # if the higher consumption device has storage energy, then trade to the other device
            if Power.get_value(i,"Battery_status_2")<70:
                Trading_energy[i] = (70 - Power.ix[i,"Battery_status_2"])/energy_per_charge_per_percent
                Power.ix[i,"Battery_status_2"] = 70
                if Trading_energy[i]>0:
                    From[i]="Device-2"
                    To[i]="Device-1"
                else:
                    From[i]=0
                    To[i]=0
            # if the lower consumption device has storage energy, then end-do nothing: triggers js
            # else:
            #     urllib.request.urlopen("http://192.168.1.11/toggle")

        if Power.get_value(i,"Device_1") < Power.get_value(i,"Device_2"):
            # if the higher consumption device has has no storage energy, then charge it
            if Power.get_value(i,"Battery_status_2")<70:
                Power.ix[i,"Battery_status_2"] = 70
            # if the higher consumption device has storage energy, then trade to the other device
            if Power.get_value(i,"Battery_status_1")<70:
                Trading_energy[i] = (70 - Power.ix[i,"Battery_status_1"])/energy_per_charge_per_percent
                Power.ix[i,"Battery_status_1"] = 70
                if Trading_energy[i]>0:
                    From[i]="Device-1"
                    To[i]="Device-2"
                else:
                    From[i]=0
                    To[i]=0
            # if the lower consumption device has storage energy, then switch off the system: triggers js
            # else:
            #     urllib.request.urlopen("http://192.168.1.11/toggle")

Power['Traded_energy']=Trading_energy
Power['From']=From
Power['To']=To
Power.to_csv("Power_2017.csv", encoding='utf-8', index=False)

Power_final = Power.loc[:, ['timestamp','From','To','Traded_energy','prices']]
Power_final = Power_final[Power_final.From != 0]
Power_final.to_csv("Trading_file.csv", encoding='utf-8', index=False)

