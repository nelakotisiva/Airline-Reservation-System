-- Airline Reservation System SQL Project

-- 1. Flights Table
CREATE TABLE Flights (
    FlightID INT PRIMARY KEY AUTO_INCREMENT,
    Airline VARCHAR(50),
    Source VARCHAR(50),
    Destination VARCHAR(50),
    DepartureTime DATETIME,
    ArrivalTime DATETIME
);

-- 2. Customers Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(15)
);

-- 3. Seats Table
CREATE TABLE Seats (
    SeatID INT PRIMARY KEY AUTO_INCREMENT,
    FlightID INT,
    SeatNumber VARCHAR(10),
    Class ENUM('Economy', 'Business', 'First'),
    IsBooked BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (FlightID) REFERENCES Flights(FlightID)
);

-- 4. Bookings Table
CREATE TABLE Bookings (
    BookingID INT PRIMARY KEY AUTO_INCREMENT,
    FlightID INT,
    CustomerID INT,
    SeatID INT,
    BookingDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    Status ENUM('Booked', 'Cancelled') DEFAULT 'Booked',
    FOREIGN KEY (FlightID) REFERENCES Flights(FlightID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (SeatID) REFERENCES Seats(SeatID)
);

-- 5. Sample Data Insertion
INSERT INTO Flights (Airline, Source, Destination, DepartureTime, ArrivalTime) VALUES 
('IndiGo', 'Delhi', 'Mumbai', '2025-08-01 10:00:00', '2025-08-01 12:30:00'),
('Air India', 'Hyderabad', 'Chennai', '2025-08-02 15:00:00', '2025-08-02 16:30:00');

INSERT INTO Customers (Name, Email, Phone) VALUES 
('Ravi Kumar', 'ravi@example.com', '9876543210'),
('Anjali Singh', 'anjali@example.com', '9123456780');

INSERT INTO Seats (FlightID, SeatNumber, Class) VALUES
(1, '1A', 'Business'),
(1, '1B', 'Business'),
(1, '10A', 'Economy'),
(1, '10B', 'Economy'),
(2, '2A', 'Business'),
(2, '2B', 'Business');

INSERT INTO Bookings (FlightID, CustomerID, SeatID) VALUES
(1, 1, 1);
UPDATE Seats SET IsBooked = TRUE WHERE SeatID = 1;

-- 6. Triggers
DELIMITER $$
CREATE TRIGGER after_booking_insert
AFTER INSERT ON Bookings
FOR EACH ROW
BEGIN
    UPDATE Seats
    SET IsBooked = TRUE
    WHERE SeatID = NEW.SeatID;
END;
$$

CREATE TRIGGER after_booking_cancel
AFTER UPDATE ON Bookings
FOR EACH ROW
BEGIN
    IF NEW.Status = 'Cancelled' THEN
        UPDATE Seats
        SET IsBooked = FALSE
        WHERE SeatID = NEW.SeatID;
    END IF;
END;
$$
DELIMITER ;

-- 7. View for Booking Summary
CREATE VIEW BookingSummary AS
SELECT 
    b.BookingID,
    c.Name AS CustomerName,
    f.Airline,
    f.Source,
    f.Destination,
    s.SeatNumber,
    s.Class,
    b.BookingDate,
    b.Status
FROM Bookings b
JOIN Customers c ON b.CustomerID = c.CustomerID
JOIN Flights f ON b.FlightID = f.FlightID
JOIN Seats s ON b.SeatID = s.SeatID;

-- 8. Useful Queries
-- Find available seats on a flight
SELECT SeatNumber, Class 
FROM Seats 
WHERE FlightID = 1 AND IsBooked = FALSE;

-- Search flights by source and destination
SELECT * FROM Flights 
WHERE Source = 'Delhi' AND Destination = 'Mumbai';

-- View booking summary
SELECT * FROM BookingSummary;
