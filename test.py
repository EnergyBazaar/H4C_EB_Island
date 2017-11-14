import pandas
import openpyxl
pandas.read_json("https://www.energy-charts.de/price/week_2017_44.json").to_csv("output")