-- Create employees table
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    department VARCHAR(50),
    salary DECIMAL(10, 2),
    hire_date DATE,
    email VARCHAR(100),
    age INTEGER,
    experience_years INTEGER,
    bonus DECIMAL(10, 2)
);

-- Create sales_data table
CREATE TABLE sales_data (
    sale_id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES employees(id),
    department VARCHAR(50),
    sales_amount DECIMAL(10, 2),
    sale_date DATE
);

-- Create products table
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10, 2)
);

-- Create employee_skills table
CREATE TABLE employee_skills (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES employees(id),
    skill_name VARCHAR(100)
);

-- Create product_reviews table
CREATE TABLE product_reviews (
    review_id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(product_id),
    rating DECIMAL(2, 1) CHECK (rating >= 1 AND rating <= 5),
    review_text TEXT
);

-- Insert sample employees
INSERT INTO employees (first_name, last_name, department, salary, hire_date, email, age, experience_years, bonus) VALUES
('John', 'Doe', 'Sales', 50000, '2022-03-15', 'john.doe@company.com', 32, 5, 5000),
('Jane', 'Smith', 'Engineering', 85000, '2021-06-10', 'jane.smith@company.com', 28, 3, 8000),
('Bob', 'Johnson', 'Sales', 60000, '2023-01-20', 'bob.johnson@company.com', 45, 15, 6000),
('Alice', 'Brown', 'Engineering', 95000, '2020-11-05', 'alice.brown@company.com', 35, 8, 9500),
('Charlie', 'Wilson', 'Marketing', 45000, '2023-05-12', 'charlie.wilson@company.com', 29, 2, 2000),
('David', 'Lee', 'Engineering', 110000, '2019-08-22', 'david.lee@company.com', 42, 12, 12000),
('Emma', 'Davis', 'Sales', 55000, '2022-09-30', 'emma.davis@company.com', 26, 1, 3000),
('Frank', 'Miller', 'Marketing', 48000, '2022-07-18', 'frank.miller@company.com', 31, 4, 4000),
('Grace', 'Taylor', 'Engineering', 92000, '2021-12-01', 'grace.taylor@company.com', 38, 9, 9000),
('Henry', 'Clark', 'Sales', 52000, '2023-03-10', NULL, 24, 0, NULL);

-- Insert sample sales data
INSERT INTO sales_data (employee_id, department, sales_amount, sale_date) VALUES
(1, 'Sales', 15000, '2024-01-15'),
(1, 'Sales', 22000, '2024-01-20'),
(2, 'Engineering', 5000, '2024-01-16'),
(3, 'Sales', 18000, '2024-01-17'),
(4, 'Engineering', 7500, '2024-01-18'),
(5, 'Marketing', 3200, '2024-01-19'),
(6, 'Engineering', 9000, '2024-01-21'),
(7, 'Sales', 12000, '2024-01-22'),
(8, 'Marketing', 4500, '2024-01-23'),
(1, 'Sales', 19000, '2024-02-01'),
(3, 'Sales', 21000, '2024-02-02'),
(4, 'Engineering', 8200, '2024-02-03');

-- Insert sample products
INSERT INTO products (product_name, category, price) VALUES
('Laptop Pro', 'Electronics', 1200.00),
('Office Chair', 'Furniture', 299.99),
('Desk Lamp', 'Home', 45.50),
('Wireless Mouse', 'Electronics', 29.99),
('Notebook', 'Stationery', 12.99),
('Coffee Maker', 'Home', 89.99),
('Desk', 'Furniture', 450.00),
('Pen Set', 'Stationery', 24.99);

-- Insert sample employee skills
INSERT INTO employee_skills (employee_id, skill_name) VALUES
(1, 'Negotiation'),
(1, 'Communication'),
(2, 'Python'),
(2, 'JavaScript'),
(2, 'SQL'),
(3, 'Sales Strategy'),
(4, 'Java'),
(4, 'System Design'),
(5, 'Social Media'),
(5, 'Content Creation'),
(6, 'Python'),
(6, 'Machine Learning'),
(6, 'Database Design'),
(7, 'Customer Service'),
(8, 'Market Research'),
(9, 'Python'),
(9, 'DevOps');

-- Insert sample product reviews
INSERT INTO product_reviews (product_id, rating, review_text) VALUES
(1, 4.5, 'Great laptop, fast performance'),
(1, 5.0, 'Excellent product, worth the price'),
(1, 4.0, 'Good but battery life could be better'),
(2, 4.8, 'Very comfortable chair'),
(2, 4.2, 'Good value for money'),
(3, 3.5, 'Average quality'),
(4, 4.7, 'Works perfectly'),
(4, 4.9, 'Best mouse I have used'),
(5, 4.0, 'Good quality paper'),
(6, 4.3, 'Makes great coffee'),
(6, 4.5, 'Easy to use and clean'),
(7, 4.6, 'Sturdy desk, easy assembly'),
(8, 4.1, 'Nice pen set');

SELECT COUNT(*) AS total_employees FROM employees;
/*total_employees
-----------------
              10
(1 row)*/

-- Count employees with non-NULL email addresses
SELECT COUNT(email) AS employees_with_email FROM employees;
/* employees_with_email
----------------------
                    9
(1 row)*/

-- Count unique departments
SELECT COUNT(DISTINCT department) AS unique_departments FROM employees;

/*unique_departments
--------------------
                  3
(1 row)*/

-- Count employees by department
SELECT department, COUNT(*) AS employee_count FROM employees GROUP BY department;

/*
department  | employee_count
-------------+----------------
 Marketing   |              2
 Engineering |              4
 Sales       |              4
(3 rows)*/
-- Count with WHERE clause
SELECT COUNT(*) AS high_salary_employees FROM employees WHERE salary > 70000;

/*high_salary_employees
-----------------------
                     4
(1 row)*/
-- Calculate average salary
SELECT AVG(salary) AS average_salary FROM employees;
/* average_salary
--------------------
 69200.000000000000
(1 row)*/

    -- Find highest and lowest salaries
SELECT
    MAX(salary) AS highest_salary,
    MIN(salary) AS lowest_salary
FROM employees;


-- List all employees in each department as a comma-separated string
SELECT department,
       STRING_AGG(first_name || ' ' || last_name, ', ') AS employee_names
FROM employees
GROUP BY department;

-- Create an array of all salaries in each department
SELECT department, ARRAY_AGG(salary ORDER BY salary) AS salary_array
FROM employees
GROUP BY department;


-- Basic GROUP BY: Sales summary by product category
SELECT
    category,
    COUNT(*) AS number_of_products,
    SUM(price) AS total_value,
    ROUND(AVG(price), 2) AS average_price,
    MIN(price) AS cheapest,
    MAX(price) AS most_expensive
FROM products
GROUP BY category
ORDER BY total_value DESC;

/* category   | number_of_products | total_value | average_price | cheapest | most_expensive
-------------+--------------------+-------------+---------------+----------+----------------
 Electronics |                  2 |     1229.99 |        615.00 |    29.99 |        1200.00
 Furniture   |                  2 |      749.99 |        375.00 |   299.99 |         450.00
 Home        |                  2 |      135.49 |         67.75 |    45.50 |          89.99
 Stationery  |                  2 |       37.98 |         18.99 |    12.99 |          24.99
(4 rows)*/


SELECT
    department,
    COUNT(*) AS employee_count
FROM employees
GROUP BY department
HAVING COUNT(*) > 2;