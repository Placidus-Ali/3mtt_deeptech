CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    OrderDate DATE,
    Product VARCHAR(50),
    Quantity INT,
    Price DECIMAL(10, 2),
    State VARCHAR(50)
)

INSERT INTO Orders (OrderID, CustomerName, OrderDate, Product, Quantity, Price, State) VALUES
(1, 'Gabriel Aliyu', '2023-01-15', 'Laptop', 2, 350000, 'Sokoto'),
(2, 'Brown Abu', '2023-02-10', 'Phone', 5, 250000, 'Cross River'),
(3, 'Janet Ugo', '2023-03-20', 'Tablet', 3, 700000, 'Imo'),
(4, 'Abi Jude', '2023-01-20', 'Phone', 1, 150000, 'Kogi'),
(5, 'Garba Shehu', '2023-04-05', 'Laptop', 1, 500000, 'Borno');


CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY,
    OrderID INT,
    PaymentDate DATE,
    PaymentAmount DECIMAL(12, 2),
    PaymentMethod VARCHAR(50),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
)

INSERT INTO Payments (PaymentID, OrderID, PaymentDate, PaymentAmount, PaymentMethod) VALUES
(101, 1, '2023-01-16', 700000, 'Card'),
(102, 2, '2023-02-11', 1250000, 'Cash'),
(103, 3, '2023-03-21', 2100000, 'Bank Transfer'),
(104, 4, '2023-01-21', 150000, 'Card'),
(105, 5, '2023-04-06', 500000, 'Cash')

-- Q1: Create a CTE to calculate the total amount spent by each customer
-- across all their orders, including the customer's name, and sort the
-- results by the total amount in descending order.

WITH CustomerTotal AS (
    SELECT CustomerName, SUM(Quantity * Price) AS TotalAmountSpent
    FROM Orders
    GROUP BY CustomerName
)
SELECT * 
FROM CustomerTotal
ORDER BY TotalAmountSpent DESC

-- Q2: Use GROUPING SETS, ROLLUP, or CUBE to analyze the total revenue grouped by State 
-- and Product, and include subtotals for each state and product combination.
	
SELECT State, Product, SUM(Quantity * Price) AS TotalRevenue
FROM Orders
GROUP BY GROUPING SETS ((State, Product), (State), (Product),())

-- Q3: Extract the year and month from the OrderDate column in the Orders Table and 
-- display them as OrderYear and OrderMonth.

SELECT OrderID, CustomerName, OrderDate,
    EXTRACT(YEAR FROM OrderDate) AS OrderYear,
    EXTRACT(MONTH FROM OrderDate) AS OrderMonth
FROM Orders

