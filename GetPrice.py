import datetime
import json
import requests
import mysql.connector
from mysql.connector import MySQLConnection, Error
import database.DataBase

mydb = database.DataBase.mydb

print(mydb)

dbcursor = mydb.cursor()

query = "INSERT INTO fuel_auto (date, price, station_id, station, type) VALUES (%s,%s,%s,%s,%s);"

longitudes = range(-39, -33)
latitudes = range(140, 151)

countTotal = 0

for longitude in longitudes:
    for latitude in latitudes:
        north = longitude
        south = longitude - 1
        east = latitude
        west = latitude + 1

        countThisLongLat = 0
        prices = []

        url = "https://petrolspy.com.au/webservice-1/station/box?neLat={}&neLng={}&swLat={}&swLng={}".format(north, east, south, west)

        data = requests.get(url)

        jsonData = json.loads(data.content)

        for entry in jsonData['message']['list']:
            stationID = entry['id']
            station = entry['name'].replace("'", "\'")

            for fuelType, price in entry['prices'].items():
                date = datetime.datetime.fromtimestamp(price['updated']/1000).strftime("%Y-%m-%d %H:%I:%S")

                prices.append((date, price['amount'], stationID, station, price['type']))

                countThisLongLat += 1
                countTotal += 1
        
        print(prices)
        try:
            dbcursor.executemany(query, prices)
        except Error as e:
            pass

        print(countThisLongLat)
print(countTotal)

mydb.commit()