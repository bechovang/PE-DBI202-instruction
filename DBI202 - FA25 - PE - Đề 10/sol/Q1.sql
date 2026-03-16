-- Q1


--CREATE DATABASE Q1_temp
--GO

--USE Q1_temp
--GO

--IF OBJECT_ID('Restaurants', 'U') IS NOT NULL
--    DROP TABLE Restaurants
--IF OBJECT_ID('Employees', 'U') IS NOT NULL
--    DROP TABLE Employees
--IF OBJECT_ID('Shifts', 'U') IS NOT NULL
--    DROP TABLE Shifts
--IF OBJECT_ID('works', 'U') IS NOT NULL
--    DROP TABLE works
--GO

CREATE TABLE Restaurants (
    restaurantID INT PRIMARY KEY,  
    [name] NVARCHAR(100),
	street NVARCHAR(100),
	city NVARCHAR(100)
)


CREATE TABLE Employees (
    empID INT PRIMARY KEY,
	fullName NVARCHAR(60),
	gender CHAR(1),
	restaurantID INT,
    FOREIGN KEY (restaurantID) REFERENCES Restaurants(restaurantID)
)

CREATE TABLE Shifts (
    shiftID INT PRIMARY KEY,  
	shiftDate DATE,
	startTime TIME,
	endTime TIME
)

CREATE TABLE works (
	EmpId INT,
    ShiftId INT,
    PRIMARY KEY (EmpId, ShiftId),  -- khóa chính kép

    FOREIGN KEY (EmpId) REFERENCES Employees(empID),
    FOREIGN KEY (ShiftId) REFERENCES Shifts(shiftID) 
)

CREATE TABLE Employeesphone (
    empID INT,
    phone NVARCHAR(100),
    PRIMARY KEY (empID, phone),
    FOREIGN KEY (empID) REFERENCES Employees(empID)
)

