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
	balance INT,

	id_client INT,
	id_AccountType INT,
	FOREIGN KEY (id_client) REFERENCES Client(id),
	FOREIGN KEY (id_AccountType) REFERENCES AccountType(id)
);