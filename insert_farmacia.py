import csv
import psycopg2
conn = psycopg2.connect(database="base_farmacia", user="postgres", password="banco", host="localhost",port=5432)
cur = conn.cursor()
with open('/home/vgcc287/Downloads/remedio.csv', 'r') as csv_file:
    csv_reader = csv.reader(csv_file)
    for line in csv_reader:
        x=line
        x[0]=int(x[0])
        x[2]=float(x[2])
        #z = x.split(",")
        print(x)
        cur.execute("INSERT INTO farmacia.remedios VALUES (%s ,%s ,%s)", x)
        conn.commit()
