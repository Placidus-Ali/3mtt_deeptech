-- Q1: Convert this dataset into 1NF: Remove duplicate values and ensure atomicity.

CREATE TABLE SQL03_01_01 (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    department VARCHAR(50),
    salary INT,
    department_location VARCHAR(20),
	manager_id INT
)

SELECT * 
FROM SQL03_01_01

CREATE TABLE New_SQL03_01_01 AS
SELECT DISTINCT *
FROM SQL03_01_01

SELECT * 
FROM New_SQL03_01_01

-- Resulting table structure and data are already in 1NF.
-- No duplicate rows and each column contains atomic (single) values.

-- Q2: Transform into 2NF: Eliminate partial dependencies by creating separate tables.

CREATE TABLE departments_2nf (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(50) UNIQUE,
    department_location VARCHAR(100)
)
	
CREATE TABLE employees_2nf(
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    department_id INT NOT NULL,
    salary INT,
    manager_id INT,
	FOREIGN KEY (department_id) REFERENCES departments_2nf(department_id)
)

INSERT INTO employees_2nf (emp_id, emp_name, department_id, salary, manager_id) 
	VALUES(101, 'Umar Adamu', 1, 50000, 201),
	(102, 'Jane Abu', 2, 60000, 202),
	(103, 'Caroline Agu', 3, 55000, 203),
	(104, 'Shehu Umar', 4, 48000, 204),
	(105, 'Mohammed Bello', 5, 53000, 205),
	(106, 'Frank Ewu', 2, 62000, 202)

INSERT INTO departments_2NF (department_id, department_name, department_location) 
	VALUES(1, 'HR', 'Lokoja'),
	(2, 'IT', 'Cross River'),
	(3, 'Finance', 'Sokoto'),
	(4, 'Logistics', 'Zamfara'),
	(5, 'Procurement', 'Jigawa')
	
SELECT * FROM EMPLOYEES_2NF
SELECT * FROM DEPARTMENTS_2NF

-- The above script transforms the dataset into Second Normal Form (2NF) by removing partial dependencies. 
-- It separates employee and department data into two related tables: employees_2nf stores employee 
-- details with a department_id foreign key, while departments_2nf holds unique department names and 
-- locations, ensuring data is better organized and normalized

--Q3: Achieve 3NF: Remove transitive dependencies and ensure all non-key attributes depend only on the primary key.

CREATE TABLE employees_3nf (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    department_id INT,
    salary INT,
    manager_id INT,
    FOREIGN KEY (department_id) REFERENCES departments_2nf(department_id)
)

INSERT INTO employees_3nf (emp_id, emp_name, department_id, salary, manager_id)
	SELECT DISTINCT emp_id, 
	emp_name, 
	department_id, 
	salary, 
	manager_id
	FROM EMPLOYEES_2NF
	
CREATE TABLE departments_3nf (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50) UNIQUE
)

INSERT INTO departments_3nf (department_id, department_name)
SELECT DISTINCT department_id,
department_name
FROM DEPARTMENTS_2NF

CREATE TABLE locations (
    location_id INT PRIMARY KEY,
    location_name VARCHAR(100) UNIQUE
)

INSERT INTO locations (location_id, location_name) 
	VALUES(1, 'Lokoja'),
	(2, 'Cross River'),
	(3, 'Sokoto'),
	(4, 'Zamfara'),
	(5, 'Jigawa'),
	(6, 'Delta')
	
CREATE TABLE department_locations (
    department_id INT,
    location_id INT,
    PRIMARY KEY (department_id, location_id), -- Composite primary key
    FOREIGN KEY (department_id) REFERENCES departments_3nf(department_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
)
INSERT INTO department_locations (department_id, location_id) 
	VALUES(1, 1), 
	(2, 2), 
	(3, 3), 
	(4, 4), 
	(5, 5), 
	(2, 6)


-- This script converts the database into Third Normal Form (3NF) by removing transitive dependencies. 
-- It separates location details into a new locations table and links them to departments through a 
-- junction table department_locations. Departments and employees are also separated, ensuring each 
-- non-key attribute depends only on the primary key
	
-- Q4: Transform the data by updating employee salaries with a 10% increase for employees in the IT department.	
	
UPDATE employees_3nf
SET salary = salary * 1.10
WHERE department_id = (SELECT department_id FROM departments_3nf WHERE department_name = 'IT')
	
