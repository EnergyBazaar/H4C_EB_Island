import pandas as pd
import itertools as IT

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
merged.to_csv("Power_2017.csv", encoding='utf-8', index=False)

# get the price for all the devices
Power = pd.read_csv("Power_2017.csv")
Power['Prices_1']=Power.Device_1 * Power.prices
Power['Prices_2']=Power.Device_2 * Power.prices
Power.to_csv("Power_2017.csv", encoding='utf-8', index=False)

#set limit for prices
price_limit = Power["Prices_1"].mean()
print(price_limit)

#trade between all the devices





