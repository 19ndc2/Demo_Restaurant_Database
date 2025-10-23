# app.py
from flask import Flask, jsonify, request
from flask_cors import CORS
from datetime import datetime, timedelta
import mysql.connector

app = Flask(__name__)
CORS(app) # enable CORS

#configure database
db_config = {
    "host": "localhost",
    "port": 3307,
    "user": "root",
    "password": "database1840",
    "database": "restaurantDB"
}

@app.route('/')
def home():
    return "flask is connected to MySQL"


#get all restaurant data
@app.route('/restaurants')
def get_restaurants():
    connection = mysql.connector.connect(**db_config)
    cursor = connection.cursor(dictionary=True)
    cursor.execute("SELECT * FROM restaurant;")
    rows = cursor.fetchall()
    cursor.close()
    connection.close()
    return jsonify(rows)


#Add customer from form data
@app.route('/add_customer', methods=['POST'])
def add_customer():
    data = request.get_json() #get data from frontend
    firstName = data.get('firstName')
    lastName = data.get('lastName')
    email = data.get('email')
    phone = data.get('phone')
    streetAddress = data.get('streetAddress')
    postalCode = data.get('postalCode')
    province = data.get('province')

    #connect to database
    connection = mysql.connector.connect(**db_config)
    cursor = connection.cursor(dictionary=True)

    try:
        cursor.execute("""
            INSERT INTO customer (email, phone, firstName, lastName, streetAddress, postalCode, province)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """, (email, phone, firstName, lastName, streetAddress, postalCode, province))
        connection.commit()
        message = {"status": "success", "message": "Customer added successfully"}
    except mysql.connector.Error as err:
        message = {"status": "error", "message": str(err)}
    finally:
        cursor.close()
        connection.close()

    print(message)
    return jsonify(message)


#send list of all customer first names, last names, and emails
@app.route('/get_customer_names')
def customer_names():
    connection = mysql.connector.connect(**db_config)
    cursor = connection.cursor(dictionary=True)
    cursor.execute("Select firstName, lastName, email FROM customer;")
    rows = cursor.fetchall()
    cursor.close()
    connection.close()
    return jsonify(rows)


#get full information of customer given email
@app.route('/customer/<email>')
def get_customer(email):
    connection = mysql.connector.connect(**db_config)
    cursor = connection.cursor(dictionary=True)
    cursor.execute("SELECT * FROM customer WHERE email=%s;", (email,))
    row = cursor.fetchone()
    cursor.close()
    connection.close()
    if row is None:
        return jsonify({"error": "Customer not found"}), 404
    return jsonify(row)


#get full information of customer given email
@app.route('/order/<date>')
def get_order(date):
    connection = mysql.connector.connect(**db_config)
    cursor = connection.cursor(dictionary=True)
    cursor.execute("""
        SELECT r.orid,
            r.email,
            c.firstName,
            c.lastName,
            r.resname,
            r.price,
            r.tip,
            r.deliveryTime,
            r.placementTime,
            r.orderDate,
            GROUP_CONCAT(io.iname SEPARATOR ', ') AS items
        FROM rorder r
        JOIN customer c ON r.email = c.email
        LEFT JOIN itemsOrdered io 
            ON r.orid = io.orid 
            AND r.email = io.email 
            AND r.id = io.id 
            AND r.resname = io.resname
        WHERE r.orderDate = %s
        GROUP BY r.orid, r.email, r.id, r.resname;
        """, (date,))
    rows = cursor.fetchall()
    cursor.close()
    connection.close()
    if not rows:
        return jsonify({"message": "No order found"})
    

    for row in rows:
        for key, value in row.items():
            if isinstance(value, timedelta):
                # convert to string like 'HH:MM:SS'
                row[key] = str(value)
            elif isinstance(value, datetime):
                row[key] = value.strftime('%Y-%m-%d')

    return jsonify(rows)

#Get shift schedule
@app.route('/get_shifts')
def shifts():
    connection = mysql.connector.connect(**db_config)
    cursor = connection.cursor(dictionary=True)
    cursor.execute("""
        SELECT 
            DATE_FORMAT(s.sday, '%Y-%m-%d') AS sday,
            TIME_FORMAT(s.startTime, '%H:%i:%s') AS startTime,
            TIME_FORMAT(s.endTime, '%H:%i:%s') AS endTime,
            e.id,
            CONCAT(e.firstName, ' ', e.lastName) AS fullName,
            e.resname,
            CASE 
                WHEN e.id IN (SELECT id FROM chef) THEN 'Chef'
                WHEN e.id IN (SELECT id FROM deliverer) THEN 'Deliverer'
                WHEN e.id IN (SELECT id FROM rserver) THEN 'Server'
                WHEN e.id IN (SELECT id FROM manager) THEN 'Manager'
                ELSE 'Unassigned'
            END AS role
        FROM shift s
        JOIN employee e ON s.id = e.id
        ORDER BY s.sday, s.startTime;
        """)
    rows = cursor.fetchall()
    cursor.close()
    connection.close()
    return jsonify(rows)

#Get restaurant names
@app.route('/get_resnames')
def restaurant_names():
    connection = mysql.connector.connect(**db_config)
    cursor = connection.cursor(dictionary=True)
    cursor.execute("Select resname FROM restaurant;")
    rows = cursor.fetchall()
    cursor.close()
    connection.close()
    return jsonify(rows)



if __name__ == '__main__':
    app.run(debug=True)