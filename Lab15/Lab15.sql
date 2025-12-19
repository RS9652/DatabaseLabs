-- Create tables for import/export examples
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    department VARCHAR(50),
    salary DECIMAL(10, 2),
    email VARCHAR(100),
    hire_date DATE,
    manager_id INTEGER REFERENCES employees(employee_id)
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    address TEXT,
    city VARCHAR(50),
    country VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    order_date DATE NOT NULL,
    total_amount DECIMAL(10, 2),
    status VARCHAR(20) DEFAULT 'pending',
    shipping_address TEXT
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id),
    product_id INTEGER REFERENCES products(product_id),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) NOT NULL,
    total_price DECIMAL(10, 2) GENERATED ALWAYS AS (quantity * unit_price) STORED
);

CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(50) UNIQUE NOT NULL,
    manager_id INTEGER REFERENCES employees(employee_id),
    budget DECIMAL(12, 2)
);

CREATE TABLE customer_feedback (
    feedback_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    comments TEXT,
    feedback_date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE sales_data (
    sale_id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(product_id),
    sale_date DATE NOT NULL,
    quantity INTEGER NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    region VARCHAR(50)
);

-- Tables for data migration examples
CREATE TABLE source_customers (
    customer_id INTEGER PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    signup_date DATE
);

CREATE TABLE target_customers (
    customer_id INTEGER PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    signup_date DATE,
    migrated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for large dataset testing
CREATE TABLE large_table (
    id SERIAL PRIMARY KEY,
    data_column TEXT,
    created_date DATE DEFAULT CURRENT_DATE,
    value_column DECIMAL(10, 2)
);

-- Log table for tracking operations
CREATE TABLE import_export_log (
    log_id SERIAL PRIMARY KEY,
    operation_type VARCHAR(20),
    table_name VARCHAR(50),
    rows_affected INTEGER,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20),
    error_message TEXT
);

-- Insert sample employees
INSERT INTO employees (first_name, last_name, department, salary, email, hire_date) VALUES
('John', 'Doe', 'IT', 75000.00, 'john.doe@company.com', '2022-03-15'),
('Jane', 'Smith', 'Sales', 65000.00, 'jane.smith@company.com', '2021-06-10'),
('Bob', 'Johnson', 'IT', 85000.00, 'bob.johnson@company.com', '2020-09-22'),
('Alice', 'Brown', 'HR', 55000.00, 'alice.brown@company.com', '2023-01-05'),
('Charlie', 'Wilson', 'Sales', 60000.00, 'charlie.wilson@company.com', '2022-11-30');

-- Insert sample products
INSERT INTO products (product_name, category, price, stock_quantity) VALUES
('Laptop Pro', 'Electronics', 1299.99, 50),
('Wireless Mouse', 'Electronics', 29.99, 200),
('Office Chair', 'Furniture', 299.99, 75),
('Desk Lamp', 'Home', 45.50, 150),
('Notebook Set', 'Stationery', 24.99, 300);

-- Insert sample customers
INSERT INTO customers (first_name, last_name, email, phone, city, country) VALUES
('Sarah', 'Miller', 'sarah.miller@email.com', '555-0101', 'New York', 'USA'),
('David', 'Wilson', 'david.wilson@email.com', '555-0102', 'London', 'UK'),
('Emma', 'Davis', 'emma.davis@email.com', '555-0103', 'Toronto', 'Canada'),
('Michael', 'Taylor', 'michael.taylor@email.com', '555-0104', 'Sydney', 'Australia'),
('Olivia', 'Martinez', 'olivia.martinez@email.com', '555-0105', 'Madrid', 'Spain');

-- Insert sample orders
INSERT INTO orders (customer_id, order_date, total_amount, status) VALUES
(1, '2024-01-15', 1299.99, 'delivered'),
(2, '2024-01-16', 45.50, 'shipped'),
(3, '2024-01-17', 299.99, 'pending'),
(4, '2024-01-18', 24.99, 'delivered'),
(5, '2024-01-19', 29.99, 'shipped');

-- Insert sample order items
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 1299.99),
(2, 4, 1, 45.50),
(3, 3, 1, 299.99),
(4, 5, 1, 24.99),
(5, 2, 1, 29.99);

-- Insert sample departments
INSERT INTO departments (department_name, budget) VALUES
('IT', 1000000.00),
('Sales', 750000.00),
('HR', 500000.00),
('Marketing', 600000.00);

-- Insert sample feedback
INSERT INTO customer_feedback (customer_id, rating, comments) VALUES
(1, 5, 'Excellent service and product quality'),
(2, 4, 'Good experience, but delivery was late'),
(3, 3, 'Average experience'),
(4, 5, 'Perfect! Will buy again'),
(5, 2, 'Product arrived damaged');

-- Insert sample sales data
INSERT INTO sales_data (product_id, sale_date, quantity, amount, region) VALUES
(1, '2024-01-15', 5, 6499.95, 'North America'),
(2, '2024-01-16', 20, 599.80, 'Europe'),
(3, '2024-01-17', 8, 2399.92, 'Asia'),
(4, '2024-01-18', 15, 682.50, 'North America'),
(5, '2024-01-19', 25, 624.75, 'Europe');

-- Insert source customers for migration examples
INSERT INTO source_customers (customer_id, name, email, signup_date) VALUES
(1, 'John Doe', 'john.doe@old.com', '2023-01-15'),
(2, 'Jane Smith', 'jane.smith@old.com', '2023-02-20'),
(3, 'Bob Johnson', 'bob.johnson@old.com', '2023-03-10');

-- 1. Basic COPY TO (Export)
COPY employees TO 'C:\Users\S\PycharmProjects\DatabaseLabs\tmp\employees.csv' WITH CSV HEADER;

COPY products FROM '/tmp/products_import.csv' WITH CSV HEADER;

-- 1. Basic database backup to SQL file
--pg_dump -h localhost -U postgres -d company_db > company_backup.sql


--# 1. Restore from custom format backup
--pg_restore -h localhost -U postgres -d company_db company_backup.dump