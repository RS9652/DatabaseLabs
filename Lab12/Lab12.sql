-- Customers table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

-- Orders table
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    order_date DATE,
    total_amount DECIMAL(10,2)
);

-- Products table
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10,2)
);

-- Order_items table (junction table for many-to-many)
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id),
    product_id INTEGER REFERENCES products(product_id),
    quantity INTEGER,
    unit_price DECIMAL(10,2)
);

-- Employees table (for self-join example)
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    manager_id INTEGER REFERENCES employees(employee_id),
    salary DECIMAL(10,2)
);

-- Users table (for one-to-one relationship)
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE
);

-- User_profiles table (one-to-one with users)
CREATE TABLE user_profiles (
    profile_id SERIAL PRIMARY KEY,
    user_id INTEGER UNIQUE REFERENCES users(user_id),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone VARCHAR(20)
);

-- Authors table (for one-to-many relationship)
CREATE TABLE authors (
    author_id SERIAL PRIMARY KEY,
    author_name VARCHAR(100)
);

-- Books table (one-to-many with authors)
CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,
    author_id INTEGER REFERENCES authors(author_id),
    title VARCHAR(200),
    publication_year INTEGER
);

-- Students table (for many-to-many relationship)
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    student_name VARCHAR(100)
);

-- Courses table (for many-to-many relationship)
CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100),
    credits INTEGER
);

-- Enrollments table (junction table for many-to-many)
CREATE TABLE enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES students(student_id),
    course_id INTEGER REFERENCES courses(course_id),
    enrollment_date DATE,
    grade DECIMAL(4,2)
);

-- Insert customers
INSERT INTO customers (name, email) VALUES
('John Doe', 'john@email.com'),
('Jane Smith', 'jane@email.com'),
('Bob Johnson', 'bob@email.com'),
('Alice Brown', 'alice@email.com'),
('Charlie Wilson', NULL);

-- Insert orders
INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2024-01-15', 150.00),
(1, '2024-02-10', 200.00),
(2, '2024-01-20', 75.50),
(3, '2024-03-05', 300.00),
(1, '2024-03-15', 120.00),
(2, '2024-03-20', 85.00);
-- Note: Customer 4 has no orders, Customer 5 doesn't exist

-- Insert products
INSERT INTO products (product_name, price) VALUES
('Laptop', 999.99),
('Mouse', 29.99),
('Keyboard', 79.99),
('Monitor', 249.99),
('Headphones', 129.99);

-- Insert order_items
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 999.99),
(1, 2, 2, 29.99),
(2, 3, 1, 79.99),
(2, 4, 2, 249.99),
(3, 2, 1, 29.99),
(3, 5, 1, 129.99),
(4, 1, 1, 999.99),
(5, 3, 1, 79.99),
(6, 4, 1, 249.99);

-- Insert employees (for self-join)
INSERT INTO employees (name, manager_id, salary) VALUES
('CEO', NULL, 200000),
('VP Sales', 1, 150000),
('Sales Manager', 2, 100000),
('Sales Rep A', 3, 70000),
('Sales Rep B', 3, 65000),
('VP Engineering', 1, 160000),
('Engineering Manager', 6, 120000),
('Software Engineer', 7, 90000);

-- Insert users and profiles (one-to-one)
INSERT INTO users (username) VALUES
('johnd'),
('janes'),
('bobj');

INSERT INTO user_profiles (user_id, first_name, last_name, phone) VALUES
(1, 'John', 'Doe', '555-0101'),
(2, 'Jane', 'Smith', '555-0102');
-- Note: User 3 has no profile

-- Insert authors and books (one-to-many)
INSERT INTO authors (author_name) VALUES
('George Orwell'),
('J.K. Rowling'),
('J.R.R. Tolkien');

INSERT INTO books (author_id, title, publication_year) VALUES
(1, '1984', 1949),
(1, 'Animal Farm', 1945),
(2, 'Harry Potter and the Philosopher''s Stone', 1997),
(2, 'Harry Potter and the Chamber of Secrets', 1998),
(3, 'The Hobbit', 1937),
(3, 'The Fellowship of the Ring', 1954);

-- Insert students, courses, and enrollments (many-to-many)
INSERT INTO students (student_name) VALUES
('Alice Johnson'),
('Bob Smith'),
('Charlie Davis'),
('Diana Miller');

INSERT INTO courses (course_name, credits) VALUES
('Mathematics', 3),
('Physics', 4),
('Chemistry', 4),
('Biology', 3);

INSERT INTO enrollments (student_id, course_id, enrollment_date, grade) VALUES
(1, 1, '2024-01-15', 85.5),
(1, 2, '2024-01-15', 90.0),
(2, 1, '2024-01-15', 78.0),
(2, 3, '2024-01-15', 88.5),
(3, 2, '2024-01-15', 92.0),
(3, 4, '2024-01-15', 87.0),
(4, 1, '2024-01-15', 95.0),
(4, 3, '2024-01-15', 91.5);


-- Create indexes on foreign key columns
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
CREATE INDEX idx_enrollments_student_id ON enrollments(student_id);
CREATE INDEX idx_enrollments_course_id ON enrollments(course_id);
CREATE INDEX idx_books_author_id ON books(author_id);

-- Basic INNER JOIN: Customers with their orders
SELECT c.name, c.email, o.order_date, o.total_amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;


/*    name     |     email      | order_date | total_amount
-------------+----------------+------------+--------------
 John Doe    | john@email.com | 2024-03-15 |       120.00
 John Doe    | john@email.com | 2024-02-10 |       200.00
 John Doe    | john@email.com | 2024-01-15 |       150.00
 Jane Smith  | jane@email.com | 2024-03-20 |        85.00
 Jane Smith  | jane@email.com | 2024-01-20 |        75.50
 Bob Johnson | bob@email.com  | 2024-03-05 |       300.00
(6 rows)*/
-- Authors with their books (one-to-many)
SELECT a.author_name, b.title, b.publication_year
FROM authors a
INNER JOIN books b ON a.author_id = b.author_id
ORDER BY a.author_name, b.publication_year;

/*  author_name   |                  title                   | publication_year
----------------+------------------------------------------+------------------
 George Orwell  | Animal Farm                              |             1945
 George Orwell  | 1984                                     |             1949
 J.K. Rowling   | Harry Potter and the Philosopher's Stone |             1997
 J.K. Rowling   | Harry Potter and the Chamber of Secrets  |             1998
 J.R.R. Tolkien | The Hobbit                               |             1937
 J.R.R. Tolkien | The Fellowship of the Ring               |             1954
(6 rows)*/


-- All customers with their orders (if any)
SELECT c.name, c.email, o.order_date, o.total_amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
ORDER BY c.name, o.order_date;

/*      name      |      email      | order_date | total_amount
----------------+-----------------+------------+--------------
 Alice Brown    | alice@email.com |            |
 Bob Johnson    | bob@email.com   | 2024-03-05 |       300.00
 Charlie Wilson |                 |            |
 Jane Smith     | jane@email.com  | 2024-01-20 |        75.50
 Jane Smith     | jane@email.com  | 2024-03-20 |        85.00
 John Doe       | john@email.com  | 2024-01-15 |       150.00
 John Doe       | john@email.com  | 2024-02-10 |       200.00
 John Doe       | john@email.com  | 2024-03-15 |       120.00
(8 rows)*/

-- Users with their profiles (if any) - one-to-one
SELECT u.username, up.first_name, up.last_name, up.phone
FROM users u
LEFT JOIN user_profiles up ON u.user_id = up.user_id;

/* username | first_name | last_name |  phone
----------+------------+-----------+----------
 johnd    | John       | Doe       | 555-0101
 janes    | Jane       | Smith     | 555-0102
 bobj     |            |           |
(3 rows)*/



-- All customers and all orders
SELECT c.name, c.email, o.order_date, o.total_amount
FROM customers c
FULL OUTER JOIN orders o ON c.customer_id = o.customer_id
ORDER BY COALESCE(c.name, 'No Customer'), o.order_date;

/*      name      |      email      | order_date | total_amount
----------------+-----------------+------------+--------------
 Alice Brown    | alice@email.com |            |
 Bob Johnson    | bob@email.com   | 2024-03-05 |       300.00
 Charlie Wilson |                 |            |
 Jane Smith     | jane@email.com  | 2024-01-20 |        75.50
 Jane Smith     | jane@email.com  | 2024-03-20 |        85.00
 John Doe       | john@email.com  | 2024-01-15 |       150.00
 John Doe       | john@email.com  | 2024-02-10 |       200.00
 John Doe       | john@email.com  | 2024-03-15 |       120.00
(8 rows)*/

-- To see customers without orders AND orders without customers
SELECT
    CASE WHEN c.name IS NULL THEN 'No Customer' ELSE c.name END AS customer_name,
    CASE WHEN o.order_id IS NULL THEN 'No Order' ELSE o.order_id::TEXT END AS order_info
FROM customers c
FULL OUTER JOIN orders o ON c.customer_id = o.customer_id;

/* customer_name  | order_info
----------------+------------
 John Doe       | 5
 John Doe       | 2
 John Doe       | 1
 Jane Smith     | 6
 Jane Smith     | 3
 Bob Johnson    | 4
 Alice Brown    | No Order
 Charlie Wilson | No Order*/



-- Customers, their orders, and order items
SELECT
    c.name AS customer_name,
    o.order_date,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    (oi.quantity * oi.unit_price) AS item_total
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
ORDER BY c.name, o.order_date;


/* customer_name | order_date | product_name | quantity | unit_price | item_total
---------------+------------+--------------+----------+------------+------------
 Bob Johnson   | 2024-03-05 | Laptop       |        1 |     999.99 |     999.99
 Jane Smith    | 2024-01-20 | Mouse        |        1 |      29.99 |      29.99
 Jane Smith    | 2024-01-20 | Headphones   |        1 |     129.99 |     129.99
 Jane Smith    | 2024-03-20 | Monitor      |        1 |     249.99 |     249.99
 John Doe      | 2024-01-15 | Mouse        |        2 |      29.99 |      59.98
 John Doe      | 2024-01-15 | Laptop       |        1 |     999.99 |     999.99
 John Doe      | 2024-02-10 | Keyboard     |        1 |      79.99 |      79.99
 John Doe      | 2024-02-10 | Monitor      |        2 |     249.99 |     499.98
 John Doe      | 2024-03-15 | Keyboard     |        1 |      79.99 |      79.99
(9 rows)
*/


-- Complete many-to-many: Students with their enrolled courses
SELECT
    s.student_name,
    c.course_name,
    e.enrollment_date,
    e.grade
FROM students s
INNER JOIN enrollments e ON s.student_id = e.student_id
INNER JOIN courses c ON e.course_id = c.course_id
WHERE e.grade IS NOT NULL
ORDER BY s.student_name, c.course_name;

/* student_name  | course_name | enrollment_date | grade
---------------+-------------+-----------------+-------
 Alice Johnson | Mathematics | 2024-01-15      | 85.50
 Alice Johnson | Physics     | 2024-01-15      | 90.00
 Bob Smith     | Chemistry   | 2024-01-15      | 88.50
 Bob Smith     | Mathematics | 2024-01-15      | 78.00
 Charlie Davis | Biology     | 2024-01-15      | 87.00
 Charlie Davis | Physics     | 2024-01-15      | 92.00
 Diana Miller  | Chemistry   | 2024-01-15      | 91.50
 Diana Miller  | Mathematics | 2024-01-15      | 95.00*/