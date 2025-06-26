CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    loyalty_points INT,
    registration_date DATE,
    age INT
)

INSERT INTO Customers VALUES
(101, 'Shehu Salihu', 150, '2019-05-15', 35),
(201, 'Job Timothy', 200, '2020-06-20', 42),
(305, 'Agnes Pam', 300, '2018-08-10', 29),
(405, 'Esther James', 120, '2022-01-05', 50),
(509, 'Larry Adams', 250, '2021-10-12', 32)


CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    amount_spent DECIMAL(10, 2),
    transaction_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
)

INSERT INTO Transactions VALUES
(1, 101, 100, '2023-05-10'),
(2, 201, 200, '2023-05-11'),
(3, 305, 300, '2023-05-12'),
(4, 405, 400, '2023-05-13'),
(5, 509, 150, '2023-05-14'),
(6, 305, 500, '2023-05-15')

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2),
    category VARCHAR(50)
)

INSERT INTO Products VALUES
(102, 'Laptop', 200000, 'Electronics'),
(201, 'Smartphone', 500000, 'Electronics'),
(203, 'Blender', 120000, 'Home Appliance'),
(104, 'Sofa', 450000, 'Furniture'),
(107, 'Desk Lamp', 350000, 'Furniture')

-- Q1: Using CASE Statements and Conditional Aggregation Write a query to display:
-- The total amount spent by customers below 40 years old. Use a CASE statement to group 
-- the data into these categories.
	
SELECT CASE 
        WHEN c.age < 30 THEN 'Under 30'
        WHEN c.age >= 30 AND c.age < 40 THEN '30-39'
    END AS age_group,
    SUM(t.amount_spent) AS total_amount_spent
FROM Customers c
JOIN Transactions t ON c.customer_id = t.customer_id
WHERE c.age < 40
GROUP BY age_group
	
	-- This SQL query calculates the total amount spent by customers under 40 years old, 
	-- categorizing them into two age groups: 'Under 30' and '30-39'. It joins the Customers
	-- and Transactions tables on customer_id, filters for customers less than 40, then sums the 
	-- amount_spent for each defined age group.

-- Q2: Create an index on the transaction_date column in the Transactions table

CREATE INDEX idx_transaction_date
ON Transactions (transaction_date)

--SELECT customer_id, amount_spent
--FROM Transactions
-- WHERE transaction_date BETWEEN '2023-05-10' AND '2023-05-11'

-- Q3: Write a query to display the total sales (amount_spent) and the number of transactions for each customer.
-- Use the GROUP BY clause.
-- Use the EXPLAIN command to analyze the query execution plan and identify bottlenecks.

SELECT customer_id, COUNT(*) AS transaction_count, SUM(amount_spent) AS total_sales
FROM Transactions
GROUP BY customer_id

EXPLAIN
SELECT customer_id, COUNT(*) AS transaction_count, SUM(amount_spent) AS total_sales
FROM Transactions
GROUP BY customer_id
