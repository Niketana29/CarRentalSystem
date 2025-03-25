CREATE DATABASE CarRentalSystem;
USE CarRentalSystem;

CREATE TABLE Vehicle(
	vehicleID INT AUTO_INCREMENT PRIMARY KEY,
	make varchar(50) not null,
	model varchar(50) not null,
	year int not null,
	dailyRate DECIMAL(10,2) NOT NULL,
    status ENUM('available', 'notAvailable') NOT NULL,
    passengerCapacity INT NOT NULL,
    engineCapacity INT NOT NULL);
    
SELECT * FROM Vehicle;

Create Table Customer(
	customerID int auto_increment primary key,
    firstName varchar(50) not null,
    lastName varchar(50) not null,
        email VARCHAR(100) UNIQUE NOT NULL,
    phoneNumber VARCHAR(15) UNIQUE NOT NULL);
    
SELECT * FROM Customer;

CREATE TABLE Lease(
	leaseID INT AUTO_INCREMENT PRIMARY KEY,
    vehicleID INT,
    customerID INT,
    startDate DATE not null,
    endDate DATE not null,
    type ENUM('DailyLease', 'MonthlyLease') NOT NULL,
    foreign key(vehicleID) REFERENCES Vehicle(vehicleID),
    foreign key(customerID) references Customer(customerID));

SELECT * from Lease;

CREATE TABLE Payment(
	paymentID INT auto_increment PRIMARY KEY,
    leaseID INT,
    paymentDate DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    foreign key(leaseID) references Lease(leaseID));
    
SELECT * FROM Payment;

ALTER TABLE Vehicle
MODIFY COLUMN engineCapacity INT;

INSERT INTO Vehicle(make,model,year,dailyRate,status,passengerCapacity,engineCapacity) VALUES 
	("Toyota", "Camry", 2022, 50.00, "available", 4, 1450),
    ("Honda", "Civic", 2023, 45.00, "available", 7, 1500),
    ("Ford", "Focus", 2022, 48.00, "notAvailable", 4, 1400),
    ("Nissan", "Altima", 2023, 52.00, "available", 7, 1200),
    ("Chevrolet", "Malibu", 2022, 47.00, "available", 4, 1800),
    ("Hyundai", "Sonata", 2023, 49.00, "notAvailable", 7, 1400),
    ("BMW", "3Series", 2023, 60.00, "available", 7, 2499),
    ("Mercedes", "C-Class", 2022, 58.00, "available", 8, 2599),
    ("Audi", "A4", 2022, 55.00, "notAvailable", 4, 2500),
    ("Lexus", "ES", 2023, 54.00, "available", 4, 2500);
    
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE Vehicle;
SET FOREIGN_KEY_CHECKS = 1;

SELECT * FROM Vehicle;

INSERT INTO Customer(firstName, lastName, email, phoneNumber) VALUES
	("John", "Doe", "johndoe@example.com", "555-555-5555"),
    ("Jane", "Smith", "janesmith@example.com", "555-123-4567"),
    ("Robert", "Johnson", "robert@example.com"," 555-789-1234"),
    ("Sarah", "Brown", "sarah@example.com", "555-456-7890"),
    ("David", "Lee", "david@example.com", "555-987-6543"),
    ("Laura", "Hall", "laura@example.com", "555-234-5678"),
    ("Michael", "Davis", "michael@example.com", "555-876-5432"),
    ("Emma", "Wilson", "emma@example.com", "555-432-1098"),
    ("William", "Taylor", "william@example.com", "555-321-6547"),
    ("Olivia", "Adams", "olivia@example.com", "555-765-4321");
    
SELECT * FROM Customer;

INSERT INTO Lease (vehicleID, customerID, startDate, endDate, type) VALUES
(1, 1, '2023-01-01', '2023-01-05', 'DailyLease'),
(2, 2, '2023-02-15', '2023-02-28', 'MonthlyLease'),
(3, 3, '2023-03-10', '2023-03-15', 'DailyLease'),
(4, 4, '2023-04-20', '2023-04-30', 'MonthlyLease'),
(5, 5, '2023-05-05', '2023-05-10', 'DailyLease'),
(4, 3, '2023-06-15', '2023-06-30', 'MonthlyLease'),
(7, 7, '2023-07-01', '2023-07-10', 'DailyLease'),
(8, 8, '2023-08-12', '2023-08-15', 'MonthlyLease'),
(3, 3, '2023-09-07', '2023-09-10', 'DailyLease'),
(10, 10, '2023-10-10', '2023-10-31', 'MonthlyLease');

SELECT * FROM Lease;

INSERT INTO Payment(leaseID, paymentDate, amount) VALUES
	(1, '2023-01-03', '200.00'),
    (2, '2023-02-20', '1000.00'),
    (3, '2023-03-12', '75.00'),
    (4, '2023-04-25', '900.00'),
    (5, '2023-05-07', '60.00'),
    (6, '2023-06-18', '1200.00'),
    (7, '2023-07-03', '40.00'),
    (8, '2023-08-14', '1100.00'),
    (9, '2023-09-09', '80.00'),
    (10, '2023-10-25', '1500.00');

SELECT * FROM Payment;

UPDATE Vehicle
SET dailyRate = 68
WHERE make = 'Mercedes';

SET SQL_SAFE_UPDATES = 0;

UPDATE Vehicle
SET dailyRate = 68
WHERE make = 'Mercedes';

SET SQL_SAFE_UPDATES = 1;

SET FOREIGN_KEY_CHECKS = 0;

DELETE FROM Payment 
WHERE leaseID IN (SELECT leaseID FROM Lease WHERE customerID = 3);

DELETE FROM Lease 
WHERE customerID = 3;

DELETE FROM Customer 
WHERE customerID = 3;

SET FOREIGN_KEY_CHECKS = 1;

SELECT * FROM Payment;
SELECT * FROM Vehicle;
SELECT * FROM Lease;
SELECT * FROM Customer;

ALTER TABLE Payment RENAME COLUMN  paymentDate TO transactionDate;

SELECT * FROM Customer
WHERE email = "sarah@example.com";

SELECT * FROM Lease 
WHERE customerID = 2 ;

SELECT * FROM payment
JOIN Lease ON Payment.leaseID = Lease.leaseID
JOIN Customer ON Lease.customerID = Customer.customerID
WHERE Customer.phoneNumber = "555-456-7890";

SELECT AVG(dailyRate)
FROM Vehicle 
WHERE status = 'available';

SELECT * FROM Vehicle
WHERE dailyRate = (SELECT MAX(dailyRate) FROM Vehicle);

SELECT * FROM Vehicle
JOIN Lease ON Vehicle.vehicleID = Lease.vehicleID
WHERE Lease.customerID = 4;

SELECT * FROM Lease 
ORDER BY startDate DESC LIMIT 1;

SELECT * FROM Payment WHERE YEAR(transactionDate) = 2023;

SELECT * FROM Customer
WHERE customerID NOT IN (SELECT customerID FROM Lease WHERE leaseID IN (SELECT leaseID FROM Payment));

SELECT Vehicle.vehicleID, Vehicle.make, Vehicle.model , SUM(Payment.amount) as total FROM Vehicle 
JOIN Lease ON Vehicle.VehicleID = Lease.VehicleID
JOIN Payment ON Lease.leaseID = Payment.leaseID
group by vehicleID, make, model;

SELECT Customer.customerID, Customer.firstName, Customer.lastName, SUM(Payment.amount) as total FROM Customer
JOIN Lease ON Customer.customerID = Lease.CustomerID
JOIN Payment ON Lease.leaseID = Payment.leaseID
GROUP BY customerID;

SELECT Lease.leaseID,Lease.vehicleID,Lease.customerID,Lease.startDate,Lease.endDate,Lease.type,Customer.firstName,Customer.lastName,Customer.phoneNumber,Vehicle.make,Vehicle.model FROM Lease 
JOIN Vehicle ON Lease.vehicleID = Vehicle.vehicleID
JOIN Customer ON Lease.customerID = Customer.customerID;

SELECT * FROM Vehicle;
SELECT * FROM Customer;
SELECT * FROM Lease;
SELECT * FROM Payment;

SELECT Customer.customerID, Customer.firstName, Customer.lastName, Customer.email, Customer.phoneNumber,Vehicle.vehicleID, Vehicle.make, Vehicle.model,Lease.leaseID,Lease.startDate,Lease.endDate
FROM Lease
JOIN Vehicle ON Lease.vehicleID = Vehicle.vehicleID
JOIN Customer ON Lease.customerID = Customer.customerID
WHERE Lease.endDate >= (SELECT MAX(endDate) FROM Lease);

SELECT Customer.customerID, Customer.firstName, Customer.lastName, SUM(Payment.amount) as total FROM Customer
JOIN Lease ON Customer.customerID = Lease.customerID
JOIN Payment ON Lease.leaseID = Payment.leaseID
GROUP BY customerID 
ORDER BY total DESC LIMIT 1;

SELECT Vehicle.vehicleID, Vehicle.make, Vehicle.model, Customer.customerID, Customer.firstName, Customer.lastName, Lease.leaseID, Lease.startDate, Lease.endDate
FROM Vehicle
JOIN Lease ON Vehicle.vehicleID = Lease.vehicleID
JOIN Customer ON Lease.CustomerID = Customer.CustomerID
order by vehicleID;