import requests
import pandas as pd
import snowflake.connector
from snowflake.connector.pandas_tools import write_pandas
import os
from dotenv import load_dotenv

load_dotenv()

# Snowflake connection (ek hi baar banate hain, sab tables ke liye reuse karenge)
conn = snowflake.connector.connect(
    account='nnnzfeb-fc66149',
    user='sufiyan003',
    password=os.getenv('SNOWFLAKE_PASSWORD'),
    role='ACCOUNTADMIN',
    warehouse='COMPUTE_WH',
    database='portfolio_db',
    schema='PUBLIC'
)
cursor = conn.cursor()

# --- PRODUCTS ---
products = requests.get("https://fakestoreapi.com/products").json()
df_products = pd.DataFrame(products)[['id', 'title', 'price', 'category']]
df_products.columns = ['PRODUCT_ID', 'PRODUCT_NAME', 'PRICE', 'CATEGORY']

cursor.execute("""
    CREATE OR REPLACE TABLE raw_products (
        PRODUCT_ID INT, PRODUCT_NAME STRING, PRICE FLOAT, CATEGORY STRING
    )
""")
write_pandas(conn, df_products, 'RAW_PRODUCTS')
print(f"Loaded {len(df_products)} products")

# --- USERS ---
users = requests.get("https://fakestoreapi.com/users").json()
df_users = pd.DataFrame(users)
df_users['first_name'] = df_users['name'].apply(lambda x: x['firstname'])
df_users['last_name'] = df_users['name'].apply(lambda x: x['lastname'])
df_users = df_users[['id', 'email', 'username', 'first_name', 'last_name']]
df_users.columns = ['USER_ID', 'EMAIL', 'USERNAME', 'FIRST_NAME', 'LAST_NAME']

cursor.execute("""
    CREATE OR REPLACE TABLE raw_users (
        USER_ID INT, EMAIL STRING, USERNAME STRING, FIRST_NAME STRING, LAST_NAME STRING
    )
""")
write_pandas(conn, df_users, 'RAW_USERS')
print(f"Loaded {len(df_users)} users")

# --- CARTS (order-like data) ---
carts = requests.get("https://fakestoreapi.com/carts").json()

cart_items = []
for cart in carts:
    for product in cart['products']:
        cart_items.append({
            'CART_ID': cart['id'],
            'USER_ID': cart['userId'],
            'CART_DATE': cart['date'][:10],
            'PRODUCT_ID': product['productId'],
            'QUANTITY': product['quantity']
        })

df_carts = pd.DataFrame(cart_items)

cursor.execute("""
    CREATE OR REPLACE TABLE raw_cart_items (
        CART_ID INT, USER_ID INT, CART_DATE DATE, PRODUCT_ID INT, QUANTITY INT
    )
""")
write_pandas(conn, df_carts, 'RAW_CART_ITEMS')
print(f"Loaded {len(df_carts)} cart items")

conn.close()
print("All data loaded successfully!")