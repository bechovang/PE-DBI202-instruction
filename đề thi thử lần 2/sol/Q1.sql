-- Table: Roles (tạo trước vì Users tham chiếu đến Roles)
CREATE TABLE Roles (
    RoleID int NOT NULL,
    name nvarchar(100),
    PRIMARY KEY (RoleID)
);

-- Table: Users
CREATE TABLE Users (
    Username varchar(30) NOT NULL,
    Password nvarchar(20),
    Email nvarchar(200),
    RoleID int,
    PRIMARY KEY (Username),
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
);

-- Table: Permissions
CREATE TABLE Permissions (
    permissionID int NOT NULL,
    name nvarchar(50),
    PRIMARY KEY (permissionID)
);

-- Bảng trung gian cho quan hệ N-M: Roles hasPermission Permissions
CREATE TABLE hasPermission (
    RoleID int NOT NULL,
    permissionID int NOT NULL,
    PRIMARY KEY (RoleID, permissionID),
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID),
    FOREIGN KEY (permissionID) REFERENCES Permissions(permissionID)
);