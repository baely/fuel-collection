import datetime
import json
import requests
import time
import mysql.connector
from mysql.connector import MySQLConnection, Error
import database.database

mydb = database.database.mydb

dbcursor = mydb.cursor()

entry_query = "INSERT IGNORE INTO fuel_auto (date, price, station_id, station, type) VALUES (%s,%s,%s,%s,%s);"
meta_query = "INSERT INTO run_meta (duration, found, inserted, total_post_run) VALUES (%s,%s,%s,%s);"

longitudes = range(-39, -33)
latitudes = range(140, 151)

countTotal = 0
prices = []

start = time.time()
for longitude in longitudes:
    for latitude in latitudes:
        north = longitude
        south = longitude - 1
        east = latitude
        west = latitude + 1

        countThisLongLat = 0

        url = "https://petrolspy.com.au/webservice-1/station/box?neLat={}&neLng={}&swLat={}&swLng={}".format(north, east, south, west)

        data = requests.get(url)

        jsonData = json.loads(data.content)

        for entry in jsonData['message']['list']:
            stationID = entry['id']
            station = entry['name'].replace("'", "\'")

            for fuelType, price in entry['prices'].items():
                date = datetime.datetime.fromtimestamp(price['updated']/1000).strftime("%Y-%m-%d %H:%I:%S")

                prices.append((date, price['amount'], stationID, station, price['type']))

                countTotal += 1

try:
    dbcursor.executemany(entry_query, prices)
    totalthisrun = dbcursor.rowcount
except Error as e:
    print(e)

end = time.time()

duration = int(end - start)

dbcursor.execute("SELECT total_post_run FROM run_meta ORDER BY id DESC LIMIT 1")

total_pre_run = dbcursor.fetchone()[0]

total_post_run = total_pre_run + totalthisrun

dbcursor.execute(meta_query, (duration, countTotal, totalthisrun, total_post_run))

mydb.commit()
mydb.close()