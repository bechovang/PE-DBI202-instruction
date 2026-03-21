-- q1

--Entities:

--Users
--Username varchar(30)
--Password nvarchar(20)
--Email nvarchar(200)
--Roles
--RoleID int
--name nvarchar(100)
--Permissions
--permissionID int
--name nvarchar(50)

--Relationships:

--Users — hasRole — Roles: many users to one role (N:1)
--Roles — hasPermission — Permissions: many-to-many (N:M)

CREATE TABLE Roles (
    RoleID INT PRIMARY KEY,
    name nvarchar(100)
)

CREATE TABLE Users (
    Username varchar(30) PRIMARY KEY,
    Password nvarchar(20), 
	Email nvarchar(200),
	RoleID INT,
	FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
)

CREATE TABLE Permissions (
    permissionID INT PRIMARY KEY,
    name nvarchar(50)
)


CREATE TABLE hasPermission (
    permissionID INT,
	RoleID INT,
	PRIMARY KEY (permissionID, RoleID),  -- khóa chính kép
    FOREIGN KEY (permissionID) REFERENCES Permissions(permissionID),
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
)









