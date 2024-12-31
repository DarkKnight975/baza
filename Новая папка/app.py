from flask import Flask, render_template, request, jsonify
import mysql.connector
from mysql.connector import Error

app = Flask(__name__)

# Database configuration
DB_CONFIG = {
    'host': '127.0.0.1',
    'user': 'root',
    'password': 'fomastas',
    'database': 'furniture_shop_db',
}

def execute_query(query, params=None, fetch=True):
    """
    Connects to the database, executes a query, and either fetches results
    or commits changes based on the query type.
    """
    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        cursor = conn.cursor(dictionary=True)
        cursor.execute(query, params)
        if fetch:  # SELECT queries
            return cursor.fetchall()
        else:  # INSERT/UPDATE/DELETE queries
            conn.commit()
            return True
    except Error as err:
        print(f"Database error: {err}")
        return [] if fetch else False
    finally:
        if conn.is_connected():
            cursor.close()
            conn.close()

@app.route('/')
def home():
    """
    Home route displaying furniture items.
    """
    query = """
        SELECT 
            furniture_items.name AS item_name, 
            furniture_items.price, 
            categories.name AS category, 
            furniture_items.image_url
        FROM furniture_items 
        JOIN categories ON furniture_items.category_id = categories.category_id;
    """
    menu_items = execute_query(query)
    return render_template('menu.html', menu_items=menu_items)

@app.route('/reviews', methods=['GET'])
def get_reviews():
    """
    Route for fetching and displaying reviews.
    """
    query = """
        SELECT 
            reviews.rating, 
            reviews.comment, 
            reviews.customer_name, 
            furniture_items.name AS item_name
        FROM reviews 
        JOIN furniture_items ON reviews.item_id = furniture_items.item_id;
    """
    reviews_data = execute_query(query)
    return render_template('reviews.html', reviews_data=reviews_data)

@app.route('/categories', methods=['GET'])
def get_categories():
    """
    Route for fetching categories. Supports JSON or HTML response.
    """
    query = "SELECT category_id, name FROM categories;"
    categories_data = execute_query(query)

    # Check for JSON request
    if request.headers.get('Accept') == 'application/json':
        return jsonify(categories_data)  # Return JSON if requested

    return render_template('categories.html', categories=categories_data)

@app.route('/contacts', methods=['GET', 'POST'])
def handle_contacts():
    """
    Contact form handler. Saves form data to the database and supports
    both GET (form view) and POST (form submission) requests.
    """
    if request.method == 'POST':
        name = request.form.get('name')
        email = request.form.get('email')
        phone = request.form.get('phone')
        message = request.form.get('message')

        query = """
            INSERT INTO contacts (name, email, phone, message) 
            VALUES (%s, %s, %s, %s);
        """
        success = execute_query(query, (name, email, phone, message), fetch=False)
        
        # JSON response for AJAX or API clients
        if success:
            return jsonify({"status": "success", "message": "Message sent successfully!"}), 201
        return jsonify({"status": "error", "message": "Failed to send the message."}), 500

    return render_template('contacts.html')

if __name__ == '__main__':
    app.run(debug=True)
