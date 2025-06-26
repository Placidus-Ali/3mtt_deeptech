---Q1: Write a SQL script to create the tables with constraints.

CREATE TABLE Customers (
    CustomerID SERIAL PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(15) CHECK (Phone ~ '^[0-9]{10,15}$')
)

CREATE TABLE Products (
    ProductID SERIAL PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) CHECK (Price > 0),
    StockQuantity INT CHECK (StockQuantity >= 0)
)

CREATE TABLE Orders (
    OrderID SERIAL PRIMARY KEY,
    CustomerID INT REFERENCES Customers(CustomerID),
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(10,2) CHECK (TotalAmount > 0)
) 

CREATE TABLE OrderDetails (
    OrderDetailID SERIAL PRIMARY KEY,  
    OrderID INT REFERENCES Orders(OrderID) ON DELETE CASCADE,
    ProductID INT REFERENCES Products(ProductID),
    Quantity INT CHECK (Quantity > 0),
    Subtotal DECIMAL(10,2) CHECK (Subtotal > 0)
)
	
SELECT * FROM CUSTOMERS
SELECT * FROM PRODUCTS
SELECT * FROM ORDERS
SELECT * FROM ORDERDETAILS

-- Q2: Write a SQL transaction to handle an order purchase. 
-- If the product is out of stock, the transaction should rollback.

CREATE OR REPLACE FUNCTION process_order(
    p_customer_id INT,
    p_product_id INT,
    p_quantity INT
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
    v_product_name VARCHAR(100);
    v_product_price DECIMAL(10, 2);
    v_stock_quantity INT;
    v_total_amount DECIMAL(10, 2);
    v_order_id INT;
BEGIN
    -- Get product details
    SELECT productname, price, stockquantity
    INTO v_product_name, v_product_price, v_stock_quantity
    FROM Products
    WHERE productid = p_product_id;

    -- Check if stock is sufficient
    IF v_stock_quantity < p_quantity THEN
        RAISE EXCEPTION 'Product % is out of stock or insufficient. Available: %', v_product_name, v_stock_quantity;
    END IF;

    -- Calculate total amount
    v_total_amount := v_product_price * p_quantity;

    -- Insert order and get new OrderID
    INSERT INTO Orders (customerid, orderdate, totalamount)
    VALUES (p_customer_id, CURRENT_DATE, v_total_amount)
    RETURNING orderid INTO v_order_id;

    -- Insert order details
    INSERT INTO OrderDetails (orderid, productid, quantity, subtotal)
    VALUES (v_order_id, p_product_id, p_quantity, v_total_amount);

    -- Update product stock
    UPDATE Products
    SET stockquantity = stockquantity - p_quantity
    WHERE productid = p_product_id;

EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Error during order processing: %', SQLERRM;
    RAISE; 
END;
$$;

-- Example usage of the function:
-- Purchase 2 of product 101 for customer 1
SELECT process_order(1, 101, 2);

-- Verify the result
SELECT * FROM Orders ORDER BY OrderID DESC LIMIT 1;
SELECT * FROM Products WHERE ProductID = 101;


-- Q3: Partition the Orders table based on OrderDate using RANGE partitioning 
-- (e.g., orders before 2023 go to one partition, and 2023+ orders go to another).



CREATE TABLE Orders_new (
    OrderID INT,
    CustomerID INT REFERENCES Customers(CustomerID),
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(10,2) CHECK (TotalAmount > 0)
) PARTITION BY RANGE (OrderDate)


-- Orders before 2023
CREATE TABLE Orders_new_before_2023
PARTITION OF Orders_new
FOR VALUES FROM ('1900-01-01') TO ('2023-01-01')

-- Orders from 2023 onwards
CREATE TABLE Orders_new_2023_and_above
PARTITION OF Orders_new
FOR VALUES FROM ('2023-01-01') TO ('2100-01-01')

