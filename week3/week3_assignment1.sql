CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    State VARCHAR(50),
    Income INT
)

INSERT INTO Customers (Customer_ID, Name, State, Income) 
	VALUES(3021, 'Kolawale Saidu', 'Lagos', 85000),
	(3028, 'Ade Abu', 'Edo', 120000),
	(3067, 'Imabong Udo', 'Akwa Ibom', 65000),
	(3078, 'Diana Ross', 'Cross River', 95000),
	(3097, 'Adullahi Usman', 'Yobe', 70000),
	(3043, 'Jefferson Chris', 'Taraba', 51000),
	(3056, 'Chidinma Ikena', 'Abia', 67000)

CREATE TABLE Transactions (
    Transaction_ID VARCHAR(10) PRIMARY KEY,
    Customer_ID INT,
    Amount INT,
    Transaction_Type VARCHAR(10),
    Date DATE,
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
)

INSERT INTO Transactions (Transaction_ID, Customer_ID, Amount, Transaction_Type, Date) 
	VALUES('T001', 3021, 8000, 'Credit', '2024-12-01'),
	('T002', 3028, 1000, 'Debit', '2024-12-02'),
	('T003', 3078, 4000, 'Credit', '2024-12-03'),
	('T004', 3067, 1500, 'Credit', '2024-12-03'),
	('T005', 3021, 15000, 'Debit', '2024-12-04'),
	('T006', 3097, 30000, 'Debit', '2024-12-05'),
	('T007', 3028, 90000, 'Credit', '2024-12-05'),
	('T008', 3056, 7600, 'Debit', '2024-12-06'),
	('T009', 3043, 5800, 'Credit', '2024-12-06')

-- Q1: Write a query to list all customers and their transaction details. Ensure customers without 
-- transactions and transactions without matching customers are included

SELECT 
    c.Customer_ID,
    c.Name,
    c.State,
    c.Income,
    t.Transaction_ID,
    t.Amount,
    t.Transaction_Type,
    t.Date
FROM Customers c
FULL OUTER JOIN Transactions t
ON c.Customer_ID = t.Customer_ID
ORDER BY c.Customer_ID

	-- FULL OUTER JOIN is used when you want to combine all records from two tables, and:
	-- Keep matching rows from both tables,
	-- Include non-matching rows from both tables (filling in NULLs where there's no match)

-- Q2: Identify the customer(s) who have the highest total transaction amount using a subquery.

SELECT Customer_ID, Total_Amount
FROM (SELECT Customer_ID, SUM(Amount) AS Total_Amount
    FROM Transactions
    GROUP BY Customer_ID ) AS CustomerTotals
WHERE Total_Amount = (SELECT MAX(TotalSum)
        FROM (SELECT SUM(Amount) AS TotalSum
            FROM Transactions
            GROUP BY Customer_ID ) AS Totals)
	

-- This is what happens
-- First, Subquery to calculate total amount per customer
-- Second, find the maximum total amount
-- Third, filter customers whose total equals the maximum

-- Q3: Write a query to combine the list of customers from Lagos and Edo using UNION, excluding duplicates.

SELECT * 
FROM Customers 
WHERE State = 'Lagos'

UNION

SELECT * 
FROM Customers 
WHERE State = 'Edo'

-- UNION combines the result sets of two or SELECT statements into a single result set, and removes duplicate rows