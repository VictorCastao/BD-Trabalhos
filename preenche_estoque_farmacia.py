import csv
import psycopg2
import numpy as np
import random
num=1

conn = psycopg2.connect(database="base_farmacia", user="postgres", password="banco", host="localhost",port=5432)
cur = conn.cursor()
with open('/home/vgcc287/Downloads/remedios.csv', 'r') as csv_file:
    csv_reader = csv.reader(csv_file)
    for line in csv_reader:
        acc=[]
        aleatorio=random.randint(11,100)
        acc.append(num)
        acc.append(aleatorio)
        print(acc)
        cur.execute("INSERT INTO farmacia.estoque (id_remedio, quantidade) VALUES ((SELECT codigo from farmacia.remedios WHERE codigo='%s'),%s)",acc)
        num=num+1
        conn.commit()