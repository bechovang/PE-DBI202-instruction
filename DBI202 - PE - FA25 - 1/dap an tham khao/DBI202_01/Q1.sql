CREATE TABLE [Product]
(
	ProductID int primary key,
	Productname nvarchar(150),
	Price decimal(12,2)
);

CREATE TABLE [Category]
(
	CategoryID int primary key,
	[Name] nvarchar(100),
	[Description] nvarchar(200),
	ProductID int references [Product](ProductID)
);

CREATE TABLE [Supplier]
(
	SupplierID varchar(30) primary key,
	SupplierName nvarchar(100),
	[Level] int
);

CREATE TABLE [hasSupplier]
(
	ProductID int references [Product](ProductID),
	SupplierID varchar(30) references Supplier(SupplierID),
	primary key(ProductID, SupplierID)
);