
import psycopg2
import sqlite3
from tkinter import *
import tkinter.ttk as ttk
import tkinter.messagebox as mb
import tkinter.simpledialog as sd

# 1. Establish a connection to the PostgreSQL database
try:
    connector = psycopg2.connect(
        host="localhost",           # e.g., "localhost" or an IP address
        database="postgres",
        user="postgres",
        password="HokageYamm2004#",
        port="5432"                 # Default PostgreSQL port
    )
    print("Connection established")

    # Create a cursor object to execute SQL queries
    cursor = connector.cursor()

    # Example: Execute a query
    cursor.execute("SELECT version();")
    db_version = cursor.fetchone()
    print(f"Connected to PostgreSQL database version: {db_version[0]}")

    # Commit any changes (for INSERT, UPDATE, DELETE)
    # connection.commit()

except psycopg2.Error as e:
    print(f"Error connecting to PostgreSQL: {e}")

finally:
    # Close the cursor and connection
    if cursor:
        cursor.close()
    if connector:
        connector.close()
    print("Database connection closed.")


# 2. Defining all the backend functions:
def issuer_card():
    cid = sd.askstring('Issuer Card ID', 'What is the Issuer\'s Card ID?\t\t\t')

    if not cid:
        mb.showerror('Issuer ID cannot be zero!', 'Can\'t keep Issuer ID empty, it must have a value')
    else:
        return cid


def display_records():
    global connector, cursor
    global tree

    tree.delete(*tree.get_children())

    curr = connector.execute('SELECT * FROM Library')
    data = curr.fetchall()

    for records in data:
        tree.insert('', END, values=records)


def clear_fields():
    global bk_status, bk_id, bk_name, author_name, card_id, bk_id_entry

    bk_status.set('Available')
    for i in ['bk_id', 'bk_name', 'author_name', 'card_id']:
        exec(f"{i}.set('')")
        bk_id_entry.config(state='normal')
    try:
        tree.selection_remove(tree.selection()[0])
    except:
        pass


def clear_and_display():
    clear_fields()
    display_records()


def view_record():
    global bk_name, bk_id, bk_status, author_name, card_id
    global tree

    if not tree.focus():
        mb.showerror('Select a row!',
                     'To view a record, you must select it in the table. Please do so before continuing.')
        return

    current_item_selected = tree.focus()
    values_in_selected_item = tree.item(current_item_selected)
    selection = values_in_selected_item['values']

    bk_name.set(selection[0]);
    bk_id.set(selection[1]);
    bk_status.set(selection[3])
    author_name.set(selection[2])