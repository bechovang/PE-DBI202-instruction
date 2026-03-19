--q1


CREATE TABLE Restaurants (
    restaurantID INT PRIMARY KEY ,  
	name NVARCHAR(100),
	street NVARCHAR(50),
	city NVARCHAR(50)
)


CREATE TABLE Employees (
    empID INT PRIMARY KEY ,  
	fullName NVARCHAR(50),
	gender CHAR(1),
	restaurantID INT,
	FOREIGN KEY (restaurantID) REFERENCES Restaurants(restaurantID)
)

CREATE TABLE phoneEmployees (
    phone NVARCHAR(20) ,	
	empID INT,
    PRIMARY KEY (phone, empID),  -- khóa chính kép

    FOREIGN KEY (empID) REFERENCES Employees(empID)
)



CREATE TABLE Shifts (
    shiftID INT PRIMARY KEY ,  
	shiftDate DATE,
	startTime TIME,
	endTime TIME
)


CREATE TABLE works (
    shiftID INT ,  
	empID INT ,
	PRIMARY KEY (EmpId, ShiftId),  -- khóa chính kép

    FOREIGN KEY (EmpId) REFERENCES Employees(empID),
    FOREIGN KEY (ShiftId) REFERENCES Shifts(shiftID)
)


