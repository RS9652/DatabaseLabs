-- Employees table (for subqueries, CTEs, window functions)
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    department VARCHAR(50),
    salary DECIMAL(10, 2),
    manager_id INTEGER REFERENCES employees(employee_id),
    hire_date DATE,
    tenure INTEGER
);

-- Orders table (for complex queries)
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES employees(employee_id),
    region_id INTEGER,
    order_date DATE,
    amount DECIMAL(10, 2),
    status VARCHAR(20)
);

-- Sales table (for pivot operations)
CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    year INTEGER,
    sales_amount DECIMAL(10, 2)
);

-- Warehouse inventory tables (for set operations)
CREATE TABLE warehouse_1 (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    quantity INTEGER
);

CREATE TABLE warehouse_2 (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    quantity INTEGER
);

-- Pivoted sales table (for unpivot operations)
CREATE TABLE pivoted_sales (
    product_name VARCHAR(100),
    year_2022 DECIMAL(10, 2),
    year_2023 DECIMAL(10, 2),
    year_2024 DECIMAL(10, 2)
);

-- Insert employees
INSERT INTO employees (first_name, last_name, department, salary, manager_id, hire_date, tenure) VALUES
('John', 'Doe', 'Sales', 60000, NULL, '2020-01-15', 4),
('Jane', 'Smith', 'Sales', 75000, 1, '2021-03-10', 3),
('Bob', 'Johnson', 'Engineering', 85000, NULL, '2019-06-20', 5),
('Alice', 'Brown', 'Engineering', 95000, 3, '2022-01-05', 2),
('Charlie', 'Wilson', 'Sales', 55000, 1, '2023-02-15', 1),
('David', 'Lee', 'Engineering', 110000, 3, '2018-08-30', 6),
('Emma', 'Davis', 'HR', 45000, NULL, '2021-07-12', 3),
('Frank', 'Miller', 'Sales', 65000, 1, '2020-11-20', 4),
('Grace', 'Taylor', 'HR', 50000, 7, '2022-09-05', 2),
('Henry', 'Clark', 'Engineering', 80000, 3, '2023-04-10', 1);

-- Update manager_id for top-level managers
UPDATE employees SET manager_id = NULL WHERE employee_id IN (1, 3, 7);

-- Insert orders
INSERT INTO orders (employee_id, region_id, order_date, amount, status) VALUES
(1, 1, '2024-01-15', 1500.00, 'High Priority'),
(2, 1, '2024-01-16', 750.50, 'Medium Priority'),
(1, 2, '2024-01-17', 2200.00, 'High Priority'),
(3, 2, '2024-01-18', 1800.00, 'Low Priority'),
(2, 1, '2024-01-19', 950.00, 'Medium Priority'),
(1, 3, '2024-01-20', 3200.00, 'High Priority'),
(5, 3, '2024-01-21', 450.00, 'Low Priority'),
(3, 2, '2024-01-22', 1250.00, 'Medium Priority'),
(8, 1, '2024-01-23', 800.00, 'Low Priority'),
(2, 2, '2024-01-24', 1600.00, 'High Priority');

-- Insert sales data (for pivoting)
INSERT INTO sales (product_name, year, sales_amount) VALUES
('Laptop', 2022, 50000.00),
('Laptop', 2023, 65000.00),
('Laptop', 2024, 72000.00),
('Mouse', 2022, 15000.00),
('Mouse', 2023, 18000.00),
('Mouse', 2024, 22000.00),
('Keyboard', 2022, 12000.00),
('Keyboard', 2023, 15000.00),
('Keyboard', 2024, 19000.00),
('Monitor', 2022, 35000.00),
('Monitor', 2023, 42000.00),
('Monitor', 2024, 48000.00);

-- Insert warehouse data (for set operations)
INSERT INTO warehouse_1 (product_name, quantity) VALUES
('Laptop', 15),
('Mouse', 100),
('Keyboard', 50),
('Monitor', 25),
('Printer', 10),
('Scanner', 5);

INSERT INTO warehouse_2 (product_name, quantity) VALUES
('Laptop', 10),
('Mouse', 80),
('Keyboard', 60),
('Monitor', 20),
('Tablet', 30),
('Smartphone', 40);

-- Insert pivoted sales data (for unpivot operations)
INSERT INTO pivoted_sales (product_name, year_2022, year_2023, year_2024) VALUES
('Laptop', 50000.00, 65000.00, 72000.00),
('Mouse', 15000.00, 18000.00, 22000.00),
('Keyboard', 12000.00, 15000.00, 19000.00),
('Monitor', 35000.00, 42000.00, 48000.00);

-- 1. Scalar Subquery: Find employees earning above average salary
SELECT first_name, last_name, salary, department
FROM employees
WHERE salary > (
    SELECT AVG(salary) FROM employees
);


-- 1. Recursive CTE for organizational hierarchy
WITH RECURSIVE org_chart AS (
    -- Anchor: Top-level managers (no manager)
    SELECT
        employee_id,
        first_name,
        last_name,
        manager_id,
        1 AS level,
        first_name || ' ' || last_name AS path
    FROM employees
    WHERE manager_id IS NULL
