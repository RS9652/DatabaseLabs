<img width="1921" height="584" alt="Oracle_Badge" src="https://github.com/user-attachments/assets/76b9180d-eddb-4bf9-b87a-efed3b54c3ad" />
<img width="452" height="372" alt="Stepik_Certificate" src="https://github.com/user-attachments/assets/2c98057c-f0da-4863-9a81-98c805fd45fc" />

📦 Warehouse Management System (Python + PostgreSQL)

A desktop-based Warehouse Management System built with Python (Tkinter) and PostgreSQL.
This application provides a simple graphical interface to manage warehouse inventory, allowing users to add, view, update, and delete items stored in a PostgreSQL database.

🚀 Features

📋 View all inventory items in a table (TreeView)

➕ Add new items to the warehouse

🗑️ Delete a selected item

🧹 Clear the entire inventory

🔄 Update item status (e.g., In Stock → Issued)

🧾 Store inventory data persistently using PostgreSQL

🖥️ User-friendly GUI built with Tkinter

🛠️ Technologies Used

Python 3

Tkinter – GUI framework

PostgreSQL – Relational database

psycopg2 – PostgreSQL database adapter for Python

🗃️ Database Structure

The application connects to a PostgreSQL database named warehouse and operates on an item table with fields similar to:

CREATE TABLE item (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    quantity INT,
    owner VARCHAR(100),
    item_status VARCHAR(50)
);

⚙️ How It Works

The application establishes a connection to a local PostgreSQL database using psycopg2.

Inventory records are retrieved and displayed in a TreeView widget.

Users can:

Insert new items using input fields

Remove selected items

Update item status

Clear all inventory data

All changes are committed directly to the database.

▶️ Running the Project
Prerequisites

Python 3 installed

PostgreSQL installed and running

psycopg2 library installed:

pip install psycopg2

Steps

Create the warehouse database and item table in PostgreSQL.

Update database credentials in the code if needed:

psycopg2.connect(
    host="localhost",
    database="warehouse",
    user="postgres",
    password="your_password",
    port="5432"
)


Run the application:

python main.py

🖼️ User Interface Overview

Left Panel: Add new inventory items

Top Right Panel: Delete items, clear inventory, update status

Bottom Right Panel: Inventory table with scrollbars

📌 Future Improvements

Input validation and error handling

Search and filter functionality

User authentication

Export inventory to CSV/PDF

Responsive window resizing

📄 License

This project is for educational purposes and can be freely modified and extended.