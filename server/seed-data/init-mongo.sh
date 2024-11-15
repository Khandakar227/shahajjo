#!/bin/bash
echo "Initializing MongoDB with sample data..."

# Use mongoimport to load JSON data into a database and collection
mongoimport --host localhost --db shahajjov2 --collection stationdatas --file /docker-entrypoint-initdb.d/shahajjov2.stationdatas.json --jsonArray
mongoimport --host localhost --db shahajjov2 --collection flooddatas --file /docker-entrypoint-initdb.d/shahajjov2.flooddatas.json --jsonArray

echo "Data import completed."