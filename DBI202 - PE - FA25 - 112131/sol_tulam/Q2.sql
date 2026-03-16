--q2

--CREATE DATABASE Q2_temp
--GO
--USE Q2_temp
--GO


--DROP TABLE IF EXISTS Account;
--DROP TABLE IF EXISTS AccountType;
--DROP TABLE IF EXISTS Client;

CREATE TABLE Client (
    id INT PRIMARY KEY,
    [FirstName] NVARCHAR(100),
	[LastName] NVARCHAR(100)
);

CREATE TABLE AccountType (
    id INT PRIMARY KEY,
    [Name] NVARCHAR(100)
);


CREATE TABLE Account (
    id INT PRIMARY KEY,
	balance DECIMAL(15,2) DEFAULT 0,

	id_client INT,
	id_AccountType INT,
	FOREIGN KEY (id_client) REFERENCES Client(id),
	FOREIGN KEY (id_AccountType) REFERENCES AccountType(id)
);

 
INSERT INTO Account (id, balance) VALUES (1, 100.12);
INSERT INTO Account (id, balance) VALUES (2, 100.12);
INSERT INTO Account (id, balance) VALUES (3, 100.12);
INSERT INTO Account (id, balance) VALUES (4, 100.12);
INSERT INTO Account (id, balance) VALUES (5, 100.12);