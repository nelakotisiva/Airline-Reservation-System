# Airline-Reservation-System
Airline Reservation System using SQL (MySQL Workbench)
________________________________________
2. Objective
To design and implement a relational database system that efficiently manages flights, customers, seat availability, and booking operations with automation through triggers and reporting via views.
________________________________________
3. Tools Used
•	DBMS: MySQL
•	Development Tool: MySQL Workbench
•	Language: SQL
________________________________________
4. Database Design
Entities and Tables
•	Flights: FlightID, Airline, Source, Destination, DepartureTime, ArrivalTime
•	Customers: CustomerID, Name, Email, Phone
•	Seats: SeatID, FlightID, SeatNumber, Class, IsBooked
•	Bookings: BookingID, FlightID, CustomerID, SeatID, BookingDate, Status
Normalization
•	1NF: No repeating groups
•	2NF: All non-key attributes depend on the whole primary key
•	3NF: No transitive dependencies
________________________________________
5. Constraints
•	Primary and foreign keys for referential integrity
•	Unique email constraint for customers
•	Default values for IsBooked, Status, and BookingDate
________________________________________
6. Sample Data
•	Flights: 2 sample flights added
•	Customers: 2 sample customers
•	Seats: 6 seats across the two flights
•	Bookings: 1 confirmed booking with trigger automation
________________________________________
7. Triggers
Booking Insert Trigger
Updates seat as booked when a booking is added.
Booking Cancel Trigger
Marks seat as unbooked when a booking is cancelled.
________________________________________
8. Booking Summary View
sql
CopyEdit
CREATE VIEW BookingSummary AS
SELECT b.BookingID, c.Name, f.Airline, f.Source, f.Destination,
       s.SeatNumber, s.Class, b.BookingDate, b.Status
FROM Bookings b
JOIN Customers c ON b.CustomerID = c.CustomerID
JOIN Flights f ON b.FlightID = f.FlightID
JOIN Seats s ON b.SeatID = s.SeatID;
________________________________________
9. Sample Queries
sql
CopyEdit
-- Search Flights
SELECT * FROM Flights WHERE Source = 'Delhi' AND Destination = 'Mumbai';

-- Check Available Seats
SELECT SeatNumber FROM Seats WHERE FlightID = 1 AND IsBooked = FALSE;

-- View Booking Summary
SELECT * FROM BookingSummary;
________________________________________
10. Conclusion
This SQL-based airline reservation system manages flight data, seat bookings, and customer details with normalized structure and automated updates via triggers. It supports future extension into a full application with a frontend for users and admins.
