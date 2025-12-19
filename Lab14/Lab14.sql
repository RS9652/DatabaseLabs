-- Accounts table (for transaction examples)
CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY,
    account_number VARCHAR(20) UNIQUE NOT NULL,
    account_holder VARCHAR(100) NOT NULL,
    balance DECIMAL(12, 2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Orders table
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'pending'
);

-- Order_items table
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id),
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) NOT NULL,
    total_price DECIMAL(10, 2) GENERATED ALWAYS AS (quantity * unit_price) STORED
);

-- Inventory table
CREATE TABLE inventory (
    product_id INTEGER PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    stock INTEGER NOT NULL DEFAULT 0,
    reorder_level INTEGER DEFAULT 10,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Customers table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Products table
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    category VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Audit_log table
CREATE TABLE audit_log (
    log_id SERIAL PRIMARY KEY,
    action VARCHAR(50) NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id INTEGER,
    details TEXT,
    table_name VARCHAR(50)
);

-- Users table
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- User_preferences table
CREATE TABLE user_preferences (
    preference_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(user_id),
    theme VARCHAR(20) DEFAULT 'light',
    language VARCHAR(10) DEFAULT 'en',
    notifications_enabled BOOLEAN DEFAULT true
);

-- Logs table (for savepoint examples)
CREATE TABLE logs (
    log_id SERIAL PRIMARY KEY,
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    severity VARCHAR(10) DEFAULT 'info'
);


-- Insert sample accounts
INSERT INTO accounts (account_number, account_holder, balance) VALUES
('ACC001', 'John Doe', 10000.00),
('ACC002', 'Jane Smith', 5000.00),
('ACC003', 'Bob Johnson', 2500.00),
('ACC004', 'Alice Brown', 15000.00);

-- Insert sample customers
INSERT INTO customers (name, email, phone) VALUES
('John Doe', 'john@email.com', '555-0101'),
('Jane Smith', 'jane@email.com', '555-0102'),
('Bob Johnson', 'bob@email.com', '555-0103');

-- Insert sample products
INSERT INTO products (name, price, category) VALUES
('Laptop', 999.99, 'Electronics'),
('Mouse', 25.99, 'Electronics'),
('Keyboard', 79.99, 'Electronics'),
('Monitor', 299.99, 'Electronics'),
('Desk', 199.99, 'Furniture');

-- Insert sample inventory
INSERT INTO inventory (product_id, product_name, stock, reorder_level) VALUES
(1, 'Laptop', 50, 10),
(2, 'Mouse', 200, 50),
(3, 'Keyboard', 100, 25),
(4, 'Monitor', 75, 15),
(5, 'Desk', 30, 5);

-- Insert sample users
INSERT INTO users (username, email) VALUES
('johnd', 'john.doe@example.com'),
('janes', 'jane.smith@example.com');

-- Insert sample user preferences
INSERT INTO user_preferences (user_id, theme, language) VALUES
(1, 'dark', 'en'),
(2, 'light', 'fr');

-- 1. BEGIN, COMMIT example
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;
COMMIT;

-- 2. BEGIN, ROLLBACK example
BEGIN;
UPDATE accounts SET balance = balance - 500 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 500 WHERE account_id = 2;
-- Something went wrong
ROLLBACK;

-- 3. START TRANSACTION (alternative syntax)
START TRANSACTION;
DELETE FROM logs WHERE created_at < '2024-01-01';
COMMIT;

-- 4. Bank transfer example with validation
BEGIN;

-- Check if account has sufficient balance
SELECT balance FROM accounts WHERE account_id = 1;

-- Perform transfer
UPDATE accounts SET balance = balance - 500 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 500 WHERE account_id = 2;

-- Verify transfers
SELECT account_id, balance FROM accounts WHERE account_id IN (1, 2);

COMMIT;


-- ATOMICITY Example
BEGIN;

INSERT INTO orders (customer_id, total) VALUES (1, 250.00);
-- Get the last order_id
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES (currval('orders_order_id_seq'), 1, 2, 999.99);

UPDATE inventory SET stock = stock - 2 WHERE product_id = 1;

-- Simulate an error (try to violate constraint)
-- This will fail and cause rollback
-- INSERT INTO order_items (order_id, product_id, quantity, unit_price)
-- VALUES (currval('orders_order_id_seq'), 999, -1, 100.00);

COMMIT;

-- Check if transaction was atomic
SELECT * FROM orders WHERE customer_id = 1;
SELECT * FROM inventory WHERE product_id = 1;

-- CONSISTENCY Example
BEGIN;

-- This maintains consistency by respecting foreign keys and constraints
INSERT INTO customers (name, email) VALUES ('New Customer', 'new@email.com');

INSERT INTO orders (customer_id, total)
VALUES (currval('customers_customer_id_seq'), 100.00);

-- This would fail and rollback the entire transaction if constraint violated
-- INSERT INTO orders (customer_id, total) VALUES (999, 100.00);

COMMIT;

-- Check consistency
SELECT c.name, o.order_id, o.total
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE c.email = 'new@email.com';