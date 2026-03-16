USE master
GO

CREATE DATABASE PE_DBI202
GO

USE PE_DBI202
GO

CREATE TABLE Clients (
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(50) NOT NULL,
	LastName NVARCHAR(50) NOT NULL
)
GO

CREATE TABLE AccountTypes (
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50) NOT NULL
)
GO

INSERT INTO Clients (FirstName, LastName) VALUES
('Adam', 'Smith'),
('Peter', 'Parker'),
('David', 'Sampson'),
('Mary', 'Bush'),
('George', 'Wan')

INSERT INTO AccountTypes (Name) VALUES
('Checking'),
('Fixed saving'),
('Flexible saving')

