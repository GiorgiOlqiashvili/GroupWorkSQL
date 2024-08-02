-- Create Customers Table
CREATE TABLE Customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    dob DATE NOT NULL, 
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) NOT NULL
);

-- One-to-One Relationship: Create CustomerDetails Table
CREATE TABLE CustomerDetails (
    customer_id INT PRIMARY KEY,
    address VARCHAR(100) NOT NULL,
    nationality VARCHAR(50) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- One-to-Many Relationship: Create Accounts Table
CREATE TABLE Accounts (
    account_id SERIAL PRIMARY KEY,
    account_number VARCHAR(20) UNIQUE NOT NULL,
    customer_id INT NOT NULL,
    balance NUMERIC(12, 2) NOT NULL,
    account_type VARCHAR(20) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- One-to-Many Relationship: Create Transactions Table
CREATE TABLE Transactions (
    transaction_id SERIAL PRIMARY KEY,
    account_id INT NOT NULL,
    transaction_date TIMESTAMP NOT NULL,
    amount NUMERIC(12, 2) NOT NULL,
    transaction_type VARCHAR(20) NOT NULL,
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);

-- Many-to-Many Relationship: Create Loans and CustomerLoans Tables
CREATE TABLE Loans (
    loan_id SERIAL PRIMARY KEY,
    loan_type VARCHAR(50) NOT NULL,
    amount NUMERIC(12, 2) NOT NULL,
    interest_rate NUMERIC(4, 2) NOT NULL
);

CREATE TABLE CustomerLoans (
    customer_id INT NOT NULL,
    loan_id INT NOT NULL,
    PRIMARY KEY (customer_id, loan_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (loan_id) REFERENCES Loans(loan_id)
);

-- Indexing Tables
CREATE INDEX idx_customer_last_name ON Customers(last_name);
CREATE INDEX idx_transaction_date ON Transactions(transaction_date);

-- Insert Values into Customers Table
INSERT INTO Customers (first_name, last_name, dob, email, phone) VALUES
('Irakli', 'Tsurtsumia', '2002-01-15', 'iraklitsurtsumia@gmail.com', '551050790'),
('Giorgi', 'Olqiashvili', '2004-02-20', 'giorgiolqiashvili@gmail.com', '557050730'),
('Nika', 'Gabeskeria', '2004-03-25', 'nikagabeskiria@gmail.com', '598645278');

-- Insert Values into CustomerDetails Table
INSERT INTO CustomerDetails (customer_id, address, nationality) VALUES
(1, 'Marjanishvili ST', 'American'),
(2, 'Rustaveli ST', 'Italian'),
(3, 'Saburtalo ST', 'Georgian');

-- Insert Values into Accounts Table
INSERT INTO Accounts (account_number, customer_id, balance, account_type) VALUES
('AC123456789', 1, 1000.50, 'Savings'),
('AC987654321', 2, 2500.75, 'Checking'),
('AC456789123', 3, 1500.25, 'Savings');

-- Insert Values into Transactions Table
INSERT INTO Transactions (account_id, transaction_date, amount, transaction_type) VALUES
(1, '2023-01-10 14:30:00', 200.00, 'Deposit'),
(2, '2023-02-15 09:45:00', 500.00, 'Withdrawal'),
(3, '2023-03-20 11:00:00', 300.00, 'Deposit');

-- Insert Values into Loans Table
INSERT INTO Loans (loan_type, amount, interest_rate) VALUES
('Home Loan', 200000.00, 3.5),
('Car Loan', 30000.00, 4.0),
('Personal Loan', 10000.00, 5.0);

-- Insert Values into CustomerLoans Table
INSERT INTO CustomerLoans (customer_id, loan_id) VALUES
(1, 1),
(2, 2),
(3, 3);

-- Joins and Queries

-- 1. Join Customers with Accounts
SELECT c.first_name, c.last_name, a.account_number, a.balance
FROM Customers AS c
JOIN Accounts AS a ON c.customer_id = a.customer_id;

-- 2. Join Customers with CustomerDetails (One-to-One)
SELECT c.first_name, c.last_name, d.address, d.nationality
FROM Customers AS c
JOIN CustomerDetails AS d ON c.customer_id = d.customer_id;

-- 3. Join Customers with Loans through CustomerLoans (Many-to-Many)
SELECT c.first_name, c.last_name, l.loan_type, l.amount
FROM Customers AS c
JOIN CustomerLoans AS cl ON c.customer_id = cl.customer_id
JOIN Loans AS l ON cl.loan_id = l.loan_id;

-- Additional Queries
-- 4. List all accounts of a specific customer
SELECT account_number, balance, account_type
FROM Accounts
WHERE customer_id = 1;

-- 5. List all transactions for a specific account
SELECT transaction_date, amount, transaction_type
FROM Transactions
WHERE account_id = 1;

-- 6. Count the number of accounts for each customer
SELECT customer_id, COUNT(account_id) AS account_count
FROM Accounts
GROUP BY customer_id;

-- 7. Find the total amount of transactions for a specific account
SELECT account_id, SUM(amount) AS total_transactions
FROM Transactions
WHERE account_id = 1
GROUP BY account_id;

-- 8. List all transactions for a specific date range
SELECT account_id, transaction_date, amount, transaction_type
FROM Transactions
WHERE transaction_date BETWEEN '2023-01-01' AND '2023-12-31';

-- 9. Find the customer with the highest account balance
SELECT c.first_name, c.last_name, a.balance
FROM Customers AS c
JOIN Accounts AS a ON c.customer_id = a.customer_id
ORDER BY a.balance DESC
LIMIT 1;

-- 10. List all loans taken by customers
SELECT c.first_name, c.last_name, l.loan_type, l.amount, l.interest_rate
FROM Customers AS c
JOIN CustomerLoans AS cl ON c.customer_id = cl.customer_id
JOIN Loans AS l ON cl.loan_id = l.loan_id;

-- 11. Find the total loan amount for each customer
SELECT c.customer_id, c.first_name, c.last_name, SUM(l.amount) AS total_loan_amount
FROM Customers AS c
JOIN CustomerLoans AS cl ON c.customer_id = cl.customer_id
JOIN Loans AS l ON cl.loan_id = l.loan_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- 12. List all transactions above a certain amount
SELECT account_id, transaction_date, amount, transaction_type
FROM Transactions
WHERE amount > 1000;

-- 13. Find the average balance of all accounts
SELECT AVG(balance) AS average_balance
FROM Accounts;









-- left Join -- 
-- SELECT c.first_name, c.last_name, a.account_number, a.balance
-- FROM Customers AS c
-- LEFT JOIN Accounts AS a ON c.customer_id = a.customer_id;


-- Right Join --
-- SELECT c.first_name, c.last_name, a.account_number, a.balance
-- FROM Customers AS c
-- RIGHT JOIN Accounts AS a ON c.customer_id = a.customer_id;


-- Full Outer Join --
-- SELECT c.first_name, c.last_name, a.account_number, a.balance
-- FROM Customers AS c
-- FULL OUTER JOIN Accounts AS a ON c.customer_id = a.customer_id;

