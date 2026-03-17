
-- DBI202 - PE - FA25 - 1
--q1


CREATE TABLE Product (
    ProductID INT PRIMARY KEY,  
    Productname NVARCHAR(150),
	Price DECIMAL(12,2)
)


CREATE TABLE Category (
    CategoryID INT PRIMARY KEY,
    Name NVARCHAR(100),
    Description NVARCHAR(200),
	ProductID INT,
	FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
)


CREATE TABLE Supplier (
    SupplierID VARCHAR(30) PRIMARY KEY,
    SupplierName NVARCHAR(100),
	Level INT,
)

CREATE TABLE hasSupplier (
    ProductID INT,
    SupplierID VARCHAR(30),
    PRIMARY KEY (ProductID, SupplierID),  -- khóa chính kép

    FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID)
)

