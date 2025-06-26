CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    location VARCHAR(100),
    age INT,
    gender VARCHAR(20)
)


INSERT INTO Customers (customer_id, name, location, age, gender) 
	VALUES(1, 'John Doe', 'Lagos', 30, 'Male'),
	(2, 'Jane Smith', 'Abuja', 28, 'Female'),
    (3, 'Peter Adams', 'Port Harcourt', 40, 'Male'),
    (4, 'Sarah Johnson', 'Kano', 35, 'Female')

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(100),
    price DECIMAL(10,2) 
)
	
INSERT INTO Products (product_id, product_name, category, price) 
	VALUES(101, 'Laptop', 'Electronics', 350000.00),
    (102, 'Phone', 'Electronics', 150000.00),
    (103, 'Printer', 'Office', 85000.00)

CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    sale_date DATE,
    quantity INT,
    total_amount DECIMAL(10, 2), -- Increased precision for total_amount
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
)

INSERT INTO Sales (sale_id, customer_id, product_id, sale_date, quantity, total_amount) 
	VALUES(5001, 1, 101, '2024-10-01', 1, 350000.00),
    (5002, 2, 102, '2024-02-15', 2, 300000.00),
    (5003, 3, 103, '2024-03-20', 1, 85000.00),
    (5004, 4, 101, '2024-03-25', 1, 350000.00)

SELECT * FROM CUSTOMERS
SELECT * FROM PRODUCTS
SELECT * FROM SALES

-- Q2: Write an SQL View that retrieves customers who have spent more than 300,000 Naira in total purchases.
	
CREATE VIEW HighSpendingCustomers AS
SELECT c.customer_id, c.name, c.location, c.age, c.gender,
    SUM(s.total_amount) AS total_spent
FROM Customers c
JOIN Sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.name, c.location, c.age, c.gender
HAVING SUM(s.total_amount) > 300000

-- To view the query
SELECT * FROM HighSpendingCustomers

-- Q3: Create a Materialized View that summarizes total sales per month.

CREATE MATERIALIZED VIEW MonthlySalesSummary AS
SELECT DATE_TRUNC('month', s.sale_date) AS sale_month,
    SUM(s.total_amount) AS monthly_sales
FROM Sales s
GROUP BY DATE_TRUNC('month', s.sale_date)
ORDER BY sale_month

-- To view the materialized view
SELECT * FROM MonthlySalesSummary


-- Q4: Write a stored procedure called update_product_price that increases the price of Phones by 10%.

CREATE PROCEDURE update_product_price()
LANGUAGE plpgsql
AS $$
BEGIN 
    UPDATE Products
    SET price = price * 1.10
    WHERE product_name = 'Phone';
END;
$$;

-- To call the procedure
CALL update_product_price();

-- Verify the update
SELECT * FROM Products WHERE product_name = 'Phone';