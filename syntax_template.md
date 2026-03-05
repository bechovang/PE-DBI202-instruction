# DBI202 - SQL SYNTAX TEMPLATE - TỔNG HỢP
## Tài liệu tham khảo nhanh cho tất cả các đề thi

---

## 📋 MỤC LỤC

1. [CREATE DATABASE & TABLES](#1-create-database--tables)
2. [SELECT Statements](#2-select-statements)
3. [JOIN Operations](#3-join-operations)
4. [AGGREGATE Functions](#4-aggregate-functions)
5. [GROUP BY & HAVING](#5-group-by--having)
6. [LIKE Patterns](#6-like-patterns)
7. [Date Functions](#7-date-functions)
8. [Subqueries](#8-subqueries)
9. [CTE (Common Table Expression)](#9-cte-common-table-expression)
10. [Stored Procedures](#10-stored-procedures)
11. [Functions](#11-functions)
12. [Triggers](#12-triggers)
13. [Views](#13-views)
14. [Transactions & Error Handling](#14-transactions--error-handling)
15. [Data Manipulation](#15-data-manipulation)
16. [Keyword Mapping](#16-keyword-mapping)
17. [ERD to Table Conversion](#17-erd-to-table-conversion)
18. [Common Patterns](#18-common-patterns)

---

## 1. CREATE DATABASE & TABLES

### 1.1 Tạo Database

```sql
CREATE DATABASE [DatabaseName];
GO

USE [DatabaseName];
GO
```

### 1.2 Tạo Bảng Cơ Bản

```sql
CREATE TABLE TableName (
    Column1 DataType PRIMARY KEY,
    Column2 DataType,
    Column3 DataType
);
```

### 1.3 Tạo Bảng với Foreign Key

```sql
-- Cách 1: Tạo cùng lúc
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Cách 2: Tạo sau
ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_Customers
FOREIGN KEY (customer_id) REFERENCES Customers(customer_id);
```

### 1.4 Composite Primary Key

```sql
CREATE TABLE OrderDetails (
    order_id INT,
    item_id INT,
    quantity INT,
    PRIMARY KEY (order_id, item_id)
);
```

### 1.5 Self-Referencing Foreign Key

```sql
CREATE TABLE Staffs (
    staff_id INT PRIMARY KEY,
    staff_name NVARCHAR(100),
    manager_id INT,
    FOREIGN KEY (manager_id) REFERENCES Staffs(staff_id)
);
```

### 1.6 DEFAULT Value

```sql
CREATE TABLE Account (
    AccountId INT PRIMARY KEY,
    Balance DECIMAL(15, 2) DEFAULT 0,
    CreatedDate DATE DEFAULT GETDATE()
);
```

### 1.7 IDENTITY (Auto-increment)

```sql
CREATE TABLE NotificationEmails (
    Id INT PRIMARY KEY IDENTITY(1,1),
    -- Bắt đầu từ 1, tăng mỗi lần 1
    Recipient INT,
    Subject NVARCHAR(255)
);
```

### 1.8 DECIMAL/NUMERIC

```sql
-- DECIMAL(tổng_số_chữ_số, số_thập_phân)
Balance DECIMAL(15, 2)  -- 1234567890123.45
Price NUMERIC(10, 2)    -- 12345678.99
Salary DECIMAL(18, 2)    -- Dùng cho tiền lương
```

### 1.9 Multi-valued Attribute → Table riêng

```sql
-- Quy tắc: Tên bảng = Tên bảng gốc + Tên thuộc tính
-- Ví dụ: Employee có Phone (multi-valued) → EmployeePhone

CREATE TABLE EmployeePhone (
    EmployeeID INT,
    Phone NVARCHAR(20),
    PRIMARY KEY (EmployeeID, Phone),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);
```

### 1.10 Thứ tự tạo bảng

```
┌─────────────────────────────────────────────┐
│  1. Bảng MẠNH (không có FK)                │
│     → Customer, Product, Employee, Table    │
│                                             │
│  2. Bảng YẾU (có FK, không composite PK)    │
│     → Orders, Reservations                  │
│                                             │
│  3. Bảng trung gian (Composite PK)          │
│     → OrderDetails, ReservationTables       │
└─────────────────────────────────────────────┘
```

---

## 2. SELECT STATEMENTS

### 2.1 SELECT Cơ Bản

```sql
SELECT column1, column2, column3
FROM TableName
WHERE condition;
```

### 2.2 SELECT với Alias

```sql
SELECT
    CustomerId AS ID,
    CustomerName AS [Tên Khách],
    City AS [Thành Phố]
FROM Customers;
```

### 2.3 SELECT với DISTINCT

```sql
SELECT DISTINCT column1, column2
FROM TableName;

-- Khi 1 món được đặt nhiều lần → DISTINCT loại bỏ trùng
SELECT DISTINCT mi.ItemName, c.FullName
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN MenuItems mi ON od.ItemID = mi.ItemID;
```

### 2.4 SELECT TOP N

```sql
SELECT TOP 1 column1, column2
FROM TableName
ORDER BY column1 DESC;

-- Với PERCENT
SELECT TOP 10 PERCENT *
FROM TableName;
```

### 2.5 SELECT với CASE WHEN

```sql
SELECT
    CustomerName,
    CASE
        WHEN TotalAmount > 1000 THEN 'VIP'
        WHEN TotalAmount > 500 THEN 'Regular'
        ELSE 'Normal'
    END AS CustomerLevel
FROM Customers;
```

### 2.6 Unicode Strings (Quan trọng!)

```sql
-- ❌ SAI - Có thể lỗi font tiếng Việt
WHERE FullName = 'Nguyễn Hoài Phương'

-- ✅ ĐÚNG - Dùng N' prefix
WHERE FullName = N'Nguyễn Hoài Phương'

-- Trong INSERT
INSERT INTO Customers (FullName, Phone)
VALUES (N'Nguyễn Văn An', '0123456789');
```

---

## 3. JOIN OPERATIONS

### 3.1 INNER JOIN

```sql
SELECT t1.col1, t2.col2
FROM Table1 t1
INNER JOIN Table2 t2 ON t1.id = t2.id
WHERE condition;
```

### 3.2 LEFT JOIN (Giữ NULL)

```sql
SELECT t1.col1, t2.col2
FROM Table1 t1
LEFT JOIN Table2 t2 ON t1.id = t2.id
WHERE condition;

-- Đặt điều kiện trong ON (QUAN TRỌNG!)
LEFT JOIN Table2 t2 ON t1.id = t2.id AND t2.status = 'Active'
```

### 3.3 LEFT JOIN: WHERE vs ON (Cực kỳ quan trọng!)

```sql
-- ❌ SAI: Điều kiện lọc bảng phải trong WHERE
-- → Sẽ biến LEFT JOIN thành INNER JOIN!
SELECT c.FullName, COUNT(o.OrderID) AS OrderCount
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE YEAR(o.PaymentTime) = 2025  -- SAI! Loại mất khách không có đơn
GROUP BY c.FullName;

-- ✅ ĐÚNG: Điều kiện lọc bảng phải đặt trong ON
-- → Giữ nguyên LEFT JOIN
SELECT c.FullName, COUNT(o.OrderID) AS OrderCount
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
    AND YEAR(o.PaymentTime) = 2025  -- ĐÚNG!
GROUP BY c.FullName;
```

**Tóm tắt:**

| Vị trí | Hiệu quả | Khi nào dùng |
|--------|----------|--------------|
| `ON` | Lọc TRƯỚC khi join, giữ LEFT JOIN | Điều kiện liên quan đến bảng phải |
| `WHERE` | Lọc SAU khi join, có thể mất rows | Điều kiện lọc chung |

### 3.4 Multi-JOIN

```sql
SELECT c.FullName, o.OrderId, mi.ItemName
FROM Customers c
JOIN Orders o ON c.CustomerId = o.CustomerId
JOIN OrderDetails od ON o.OrderId = od.OrderId
JOIN MenuItems mi ON od.ItemId = mi.ItemId
WHERE c.City = 'New York';
```

### 3.5 Self-JOIN

```sql
SELECT e1.StaffName AS Employee, e2.StaffName AS Manager
FROM Staffs e1
JOIN Staffs e2 ON e1.ManagerId = e2.StaffId;
```

### 3.6 Phân biệt INNER JOIN vs LEFT JOIN

| INNER JOIN | LEFT JOIN |
|------------|-----------|
| Chỉ rows khớp ở cả 2 bảng | TẤT CẢ rows bảng trái + rows khớp |
| Món có khách đặt mới hiện | TẤT CẢ món đều hiện (kể cả không ai đặt) |

**Dùng LEFT JOIN khi đề nói:** "include ... even if not..."

---

## 4. AGGREGATE FUNCTIONS

### 4.1 Các hàm thường dùng

```sql
-- COUNT
COUNT(*)           -- Đếm tất cả rows
COUNT(column)       -- Đếm rows khác NULL
COUNT(DISTINCT col) -- Đếm giá trị khác nhau

-- SUM
SUM(column)         -- Tổng giá trị
SUM(quantity * price) -- Tổng nhân

-- AVG
AVG(column)         -- Trung bình cộng

-- MIN/MAX
MIN(column)         -- Giá trị nhỏ nhất
MAX(column)         -- Giá trị lớn nhất
```

### 4.2 ROUND

```sql
ROUND(Amount, 2)    -- Làm tròn 2 số thập phân
ROUND(SUM(Amount), 0) -- Làm tròn số nguyên
ROUND(AVG(value), 2) -- Làm tròn trung bình
```

### 4.3 ISNULL/COALESCE

```sql
-- ISNULL (SQL Server)
ISNULL(column, 0)

-- COALESCE (chuẩn SQL)
COALESCE(column, 0)

-- Ví dụ với LEFT JOIN
ISNULL(COUNT(o.OrderID), 0) AS NumberOfOrders
ISNULL(SUM(o.TotalAmount), 0) AS TotalAmount

-- Trong calculation
ISNULL(SUM(od.Quantity * od.Price), 0) AS Revenue
```

### 4.4 Percentage Change Calculation

```sql
-- Formula: ((new_value - old_value) / old_value) * 100

-- Ví dụ: Tính % tăng trưởng chi tiêu 2024 vs 2023
WITH Sales2023 AS (
    SELECT CustomerID, AVG(TotalAmount) AS Avg2023
    FROM Orders WHERE YEAR(PaymentTime) = 2023
    GROUP BY CustomerID
),
Sales2024 AS (
    SELECT CustomerID, AVG(TotalAmount) AS Avg2024
    FROM Orders WHERE YEAR(PaymentTime) = 2024
    GROUP BY CustomerID
)
SELECT
    s23.CustomerID,
    ROUND(s23.Avg2023, 2) AS Avg2023,
    ROUND(s24.Avg2024, 2) AS Avg2024,
    CAST(ROUND(((s24.Avg2024 - s23.Avg2023) / s23.Avg2023 * 100), 2)
         AS NVARCHAR(20)) + ' %' AS PercentageChange
FROM Sales2023 s23
INNER JOIN Sales2024 s24 ON s23.CustomerID = s24.CustomerID;
```

---

## 5. GROUP BY & HAVING

### 5.1 GROUP BY cơ bản

```sql
SELECT
    Category,
    COUNT(*) AS ProductCount,
    AVG(Price) AS AvgPrice
FROM Products
GROUP BY Category;
```

### 5.2 GROUP BY nhiều cột

```sql
SELECT
    s.store_id,
    s.store_name,
    SUM(st.quantity) AS total_qty
FROM stores s
JOIN stocks st ON s.store_id = st.store_id
GROUP BY s.store_id, s.store_name
ORDER BY total_qty DESC;
```

### 5.3 HAVING - Lọc sau GROUP BY

```sql
SELECT
    CustomerId,
    CustomerName,
    COUNT(*) AS NumberOfOrders
FROM Orders
GROUP BY CustomerId, CustomerName
HAVING COUNT(*) >= 3;
```

### 5.4 Phân biệt WHERE vs HAVING

| WHERE | HAVING |
|-------|--------|
| Lọc TRƯỚC khi nhóm | Lọc SAU khi nhóm |
| Dùng với row data | Dùng với aggregated data |
| Không dùng hàm aggregate | Có thể dùng COUNT, SUM, MAX... |

```sql
-- ❌ SAI
WHERE COUNT(*) >= 3

-- ✅ ĐÚNG
HAVING COUNT(*) >= 3
```

---

## 6. LIKE PATTERNS

### 6.1 Các pattern cơ bản

```sql
-- Bắt đầu bằng
LIKE 'Nguyễn%'        -- Bắt đầu bằng "Nguyễn"

-- Kết thúc bằng
LIKE '%name'           -- Kết thúc bằng "name"

-- Chứa
LIKE '%key%'           -- Chứa "key"

-- Chính xác n ký tự
LIKE '_ook'            -- "book", "cook", "look" (1 ký tự bất kỳ + ook)
```

### 6.2 Character Class (Pattern Matching)

```sql
-- Khu A, Khu B, hoặc Khu C (chỉ 1 ký tự trong [])
LIKE 'Khu [ABC]%'      -- Match: "Khu A...", "Khu B...", "Khu C..."

-- Range
LIKE '[0-9]%'          -- Bắt đầu bằng số
LIKE '[A-Z]%'          -- Bắt đầu bằng chữ hoa
LIKE '[a-z]%'          -- Bắt đầu bằng chữ thường

-- NOT trong []
LIKE 'Khu [^ABC]%'     -- Khu KHÔNG phải A, B, C
```

### 6.3 Multiple LIKE với OR

```sql
-- Cách 1: Nhiều OR (dễ đọc)
WHERE Location LIKE N'%Khu A%'
   OR Location LIKE N'%Khu B%'
   OR Location LIKE N'%Khu C%'

-- Cách 2: Dùng IN (không hỗ trợ %)
-- ❌ KHÔNG ĐƯỢC: WHERE Location IN ('%Khu A%', '%Khu B%')

-- Cách 3: Character class
WHERE Location LIKE N'%Khu [ABC]%'
```

### 6.4 Ví dụ thực tế

```sql
-- Tìm bàn ở Khu A, B, hoặc C
SELECT TableID, Location, Capacity
FROM Tables
WHERE Location LIKE N'%Khu A%'
   OR Location LIKE N'%Khu B%'
   OR Location LIKE N'%Khu C%';

-- Tìm khách tên bắt đầu bằng "Nguyễn" hoặc "Bùi"
SELECT CustomerID, FullName
FROM Customers
WHERE FullName LIKE N'Nguyễn%' OR FullName LIKE N'Bùi%';
```

---

## 7. DATE FUNCTIONS

### 7.1 Extract Date Parts

```sql
YEAR(date_column)     -- 2025
MONTH(date_column)    -- 1-12
DAY(date_column)      -- 1-31
```

### 7.2 Filter Date

```sql
-- Cách 1: BETWEEN (khuyến nghị)
WHERE date_column BETWEEN '2025-01-01' AND '2025-12-31'

-- Cách 2: YEAR + MONTH
WHERE YEAR(date_column) = 2025
WHERE MONTH(date_column) = 8
WHERE YEAR(date_column) = 2025 AND MONTH(date_column) = 8

-- Cách 3: >= và <=
WHERE date_column >= '2025-01-01' AND date_column <= '2025-12-31'

-- Quarter
WHERE DATEPART(QUARTER, date_column) = 1  -- Q1: Jan, Feb, Mar
```

### 7.3 Format Date as String

```sql
-- Format: M/YYYY (ví dụ: 1/2025, 12/2025)
CAST(MONTH(date) AS NVARCHAR(10)) + '/' + CAST(YEAR(date) AS NVARCHAR(10))

-- Hoặc dùng CONVERT
CONVERT(NVARCHAR(10), MONTH(date)) + '/' + CONVERT(NVARCHAR(10), YEAR(date))
```

### 7.4 Date Filter với LEFT JOIN

```sql
-- Đặt điều kiện date trong ON khi LEFT JOIN
FROM Months m
LEFT JOIN Orders o ON MONTH(o.PaymentTime) = m.MonthNum
    AND YEAR(o.PaymentTime) = @year  -- Để trong ON
    AND o.Status = 'Completed'
```

---

## 8. SUBQUERIES

### 8.1 Subquery trong WHERE (MIN/MAX)

```sql
-- Tìm sản phẩm có giá thấp nhất
SELECT product_id, product_name, list_price
FROM products
WHERE list_price = (SELECT MIN(list_price) FROM products);

-- Tìm sản phẩm có giá cao nhất
SELECT product_id, product_name, list_price
FROM products
WHERE list_price = (SELECT MAX(list_price) FROM products);
```

### 8.2 Subquery trong WHERE (IN/NOT IN)

```sql
-- Xóa stocks với category = 'Mountain'
DELETE FROM stocks
WHERE product_id IN (
    SELECT product_id
    FROM products
    WHERE category_name = 'Mountain'
);
```

### 8.3 Below/Above Average Pattern

```sql
-- Tìm khách có chi tiêu dưới trung bình
WITH CustomerSpending AS (
    SELECT c.CustomerID, c.FullName,
           ISNULL(SUM(o.TotalAmount), 0) AS TotalAmount
    FROM Customers c
    LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
        AND o.Status = 'Completed'
        AND YEAR(o.PaymentTime) = 2025
    GROUP BY c.CustomerID, c.FullName
)
SELECT * FROM CustomerSpending
WHERE TotalAmount < (SELECT AVG(TotalAmount) FROM CustomerSpending);
```

### 8.4 Correlated Subquery (Max trong mỗi nhóm)

```sql
-- Tìm sản phẩm có giá cao nhất trong mỗi category
SELECT p.category_name,
       p.product_id,
       p.product_name,
       p.list_price
FROM products p
WHERE p.list_price = (
    SELECT MAX(p2.list_price)
    FROM products p2
    WHERE p2.category_name = p.category_name
)
ORDER BY p.category_name, p.product_id;
```

### 8.5 Subquery trong SELECT

```sql
SELECT
    p.product_name,
    p.list_price,
    (SELECT AVG(list_price) FROM products) AS AvgPrice,
    p.list_price - (SELECT AVG(list_price) FROM products) AS Difference
FROM products p;
```

---

## 9. CTE (COMMON TABLE EXPRESSION)

### 9.1 CTE cơ bản

```sql
WITH CTEName AS (
    SELECT column1, column2
    FROM TableName
    WHERE condition
)
SELECT * FROM CTEName;
```

### 9.2 Multiple CTEs

```sql
WITH Avg2024 AS (
    SELECT c.CustomerID, AVG(o.TotalAmount) AS Avg2024
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    WHERE YEAR(o.PaymentTime) = 2024
    GROUP BY c.CustomerID
),
Avg2025 AS (
    SELECT c.CustomerID, AVG(o.TotalAmount) AS Avg2025
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    WHERE YEAR(o.PaymentTime) = 2025
    GROUP BY c.CustomerID
)
SELECT a.CustomerID, c.FullName, a.Avg2024, b.Avg2025
FROM Avg2024 a
JOIN Avg2025 b ON a.CustomerID = b.CustomerID
JOIN Customers c ON a.CustomerID = c.CustomerID;
```

### 9.3 CTE tạo số 1-12 (cho báo cáo tháng)

```sql
WITH Months AS (
    SELECT 1 AS Month UNION ALL SELECT 2 UNION ALL SELECT 3
    UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6
    UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
    UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL SELECT 12
)
SELECT m.Month, COUNT(o.OrderID) AS NumberOfOrders
FROM Months m
LEFT JOIN Orders o ON MONTH(o.OrderDate) = m.Month
GROUP BY m.Month;
```

### 9.4 CTE cho All Items bao gồm cả NULL

```sql
WITH AllItemSales AS (
    SELECT m.ItemID, m.ItemName, m.Category,
           ISNULL(SUM(od.Quantity * od.Price), 0) AS TotalAmount
    FROM MenuItems m
    LEFT JOIN OrderDetails od ON m.ItemID = od.ItemID
    LEFT JOIN Orders o ON od.OrderID = o.OrderID
        AND o.Status = 'Completed'
    GROUP BY m.ItemID, m.ItemName, m.Category
)
SELECT * FROM AllItemSales
WHERE TotalAmount < (SELECT AVG(TotalAmount) FROM AllItemSales);
```

---

## 10. STORED PROCEDURES

### 10.1 Procedure cơ bản (Input + Output)

```sql
CREATE PROCEDURE proc_name
    @input_param INT,
    @output_param DECIMAL(10,2) OUTPUT
AS
BEGIN
    SELECT @output_param = SUM(column)
    FROM TableName
    WHERE column = @input_param;
END;
```

### 10.2 Procedure với Validation

```sql
CREATE PROCEDURE sp_WithdrawMoney
    @AccountId INT,
    @Amount DECIMAL(15, 2)
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Validate 1: Số tiền phải dương
        IF @Amount <= 0
        BEGIN
            RAISERROR('Amount must be positive.', 16, 1);
            RETURN;
        END

        -- Validate 2: Account phải tồn tại
        IF NOT EXISTS (SELECT 1 FROM Account WHERE AccountId = @AccountId)
        BEGIN
            RAISERROR('Account ID does not exist.', 16, 1);
            RETURN;
        END

        -- Validate 3: Balance phải đủ
        DECLARE @CurrentBalance DECIMAL(15, 2);
        SELECT @CurrentBalance = Balance FROM Account WHERE AccountId = @AccountId;

        IF @CurrentBalance < @Amount
        BEGIN
            RAISERROR('Insufficient balance.', 16, 1);
            RETURN;
        END

        -- Thực hiện rút tiền
        UPDATE Account
        SET Balance = Balance - @Amount
        WHERE AccountId = @AccountId;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
```

### 10.3 Procedure COUNT DISTINCT

```sql
CREATE PROCEDURE proc_serviceTicket_part
    @serviceTicketID INT,
    @numberOfParts INT OUTPUT
AS
BEGIN
    SELECT @numberOfParts = COUNT(DISTINCT partID)
    FROM PartsUsed
    WHERE serviceTicketID = @serviceTicketID;
END;
```

### 10.4 Procedure Monthly Report (Pattern 12 tháng)

```sql
CREATE PROCEDURE MonthlySalesSummary
    @year INT
AS
BEGIN
    WITH Months AS (
        SELECT 1 AS MonthNum UNION ALL SELECT 2 UNION ALL SELECT 3
        UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6
        UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
        UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL SELECT 12
    )
    SELECT
        CAST(m.MonthNum AS NVARCHAR(10)) + '/' + CAST(@year AS NVARCHAR(10)) AS [Month],
        ISNULL(COUNT(DISTINCT o.OrderID), 0) AS NumberOfOrders,
        ISNULL(SUM(od.Quantity * od.Price), 0) AS TotalRevenue
    FROM Months m
    LEFT JOIN Orders o ON MONTH(o.PaymentTime) = m.MonthNum
        AND YEAR(o.PaymentTime) = @year
        AND o.Status = 'Completed'
    LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID
    GROUP BY m.MonthNum
    ORDER BY m.MonthNum;
END;
```

### 10.5 Cách test Procedure (KHÔNG nộp)

```sql
-- Khai báo biến
DECLARE @x DECIMAL(10,2);

-- Gọi procedure
EXEC proc_name 123, @x OUTPUT;

-- Xem kết quả
SELECT @x AS Result;

-- Gọi procedure không có output
EXEC MonthlySalesSummary 2023;
```

---

## 11. FUNCTIONS

### 11.1 Table-Valued Function

```sql
CREATE FUNCTION f_tk(@mechanicID DECIMAL(18,0))
RETURNS TABLE
AS
RETURN
(
    SELECT M.mechanicID,
           M.mechanicName,
           SUM(SM.hours) AS sumHours
    FROM Mechanic M
    JOIN ServiceMechanic SM ON M.mechanicID = SM.mechanicID
    WHERE M.mechanicID = @mechanicID
    GROUP BY M.mechanicID, M.mechanicName
);
```

### 11.2 Scalar-Valued Function

```sql
CREATE FUNCTION fn_CalculateTax(@Amount DECIMAL(10,2))
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Tax DECIMAL(10,2);
    SET @Tax = @Amount * 0.1;  -- 10% thuế
    RETURN @Tax;
END;
```

### 11.3 Cách gọi Function

```sql
-- Table-valued: Gọi như một bảng
SELECT * FROM f_tk(12345);

-- Hoặc JOIN với bảng khác
SELECT * FROM f_tk(12345) f
JOIN Mechanic m ON f.mechanicID = m.mechanicID;

-- Scalar: Gọi trong SELECT
SELECT
    OrderId,
    TotalAmount,
    dbo.fn_CalculateTax(TotalAmount) AS Tax
FROM Orders;
```

---

## 12. TRIGGERS

### 12.1 AFTER INSERT Trigger

```sql
CREATE TRIGGER tr_insert_table
ON TableName
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM inserted;
END;
```

### 12.2 AFTER UPDATE Trigger

```sql
CREATE TRIGGER tr_Account_Update
ON Account
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @OldBalance DECIMAL(15,2), @NewBalance DECIMAL(15,2);

    SELECT @NewBalance = i.Balance, @OldBalance = d.Balance
    FROM inserted i
    INNER JOIN deleted d ON i.AccountId = d.AccountId;

    -- Log or notify
    INSERT INTO NotificationEmails (Recipient, Subject, Content)
    VALUES (
        (SELECT AccountId FROM inserted),
        'Balance Updated',
        'Changed from ' + CAST(@OldBalance AS NVARCHAR) + ' to ' + CAST(@NewBalance AS NVARCHAR)
    );
END;
```

### 12.3 AFTER DELETE Trigger

```sql
CREATE TRIGGER tr_delete_table
ON TableName
AFTER DELETE
AS
BEGIN
    -- Log deleted rows
    INSERT INTO AuditLog (TableID, Action, ActionDate)
    SELECT TableID, 'DELETE', GETDATE() FROM deleted;
END;
```

### 12.4 Trigger cho INSERT/UPDATE/DELETE (Update Aggregate)

```sql
CREATE TRIGGER trg_UpdateTotalAmount
ON OrderDetails
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE o
    SET o.TotalAmount = ISNULL((
        SELECT SUM(od.Quantity * od.Price)
        FROM OrderDetails od
        WHERE od.OrderID = o.OrderID
    ), 0)
    FROM Orders o
    WHERE o.OrderID IN (
        SELECT OrderID FROM inserted
        UNION
        SELECT OrderID FROM deleted
    );
END;
```

### 12.5 Bảng ảo trong Trigger

| Trigger | Bảng ảo | Nội dung |
|---------|----------|----------|
| INSERT | `inserted` | Rows mới được insert |
| UPDATE | `inserted` + `deleted` | NEW + OLD data |
| DELETE | `deleted` | Rows bị xóa |

```
INSERT → inserted CÓ, deleted KHÔNG
UPDATE → inserted CÓ, deleted CÓ
DELETE → inserted KHÔNG, deleted CÓ
```

### 12.6 Formula Trigger cập nhật aggregate

```sql
CREATE TRIGGER [tên]
ON [bảng_con]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    UPDATE [bảng_cha]
    SET [tổng] = ISNULL((
        SELECT SUM([cột_tính])
        FROM [bảng_con]
        WHERE [khóa_ngoại] = [bảng_cha].[khóa_chính]
    ), 0)
    WHERE [khóa_chính] IN (
        SELECT [khóa_ngoại] FROM inserted
        UNION
        SELECT [khóa_ngoại] FROM deleted
    );
END;
```

---

## 13. VIEWS

### 13.1 Tạo View cơ bản

```sql
CREATE VIEW vw_RichClients AS
SELECT c.FirstName, c.LastName
FROM Client c
JOIN Account a ON c.Id = a.ClientId
GROUP BY c.FirstName, c.LastName
HAVING SUM(a.Balance) > 300;
```

### 13.2 View với JOIN

```sql
CREATE VIEW vw_OrderDetails AS
SELECT
    o.OrderId,
    c.CustomerName,
    e.EmployeeName,
    o.OrderDate,
    o.TotalAmount
FROM Orders o
JOIN Customers c ON o.CustomerId = c.CustomerId
JOIN Employees e ON o.EmployeeId = e.EmployeeId
WHERE o.Status = 'Completed';
```

### 13.3 Gọi View

```sql
-- Gọi như một bảng
SELECT * FROM vw_RichClients;

-- Thêm điều kiện
SELECT * FROM vw_RichClients
WHERE LastName = 'Smith';
```

---

## 14. TRANSACTIONS & ERROR HANDLING

### 14.1 TRY-CATCH Structure

```sql
BEGIN TRY
    -- Code có thể gây lỗi
END TRY
BEGIN CATCH
    -- Xử lý lỗi
    THROW;
END CATCH
```

### 14.2 Transaction với ROLLBACK

```sql
CREATE PROCEDURE proc_name
    @param1 INT
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Code chính
        -- INSERT/UPDATE/DELETE

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
```

### 14.3 RAISERROR vs THROW

| | RAISERROR | THROW |
|--|-----------|-------|
| Phiên bản | Cũ (SQL 2005+) | Mới (SQL 2012+) |
| Syntax | RAISERROR(msg, level, state) | THROW |
| Khuyến nghị | Dùng THROW | THROW |

```sql
-- RAISERROR
RAISERROR('Error message here.', 16, 1);

-- THROW
THROW 50000, 'Error message here.', 1;
```

---

## 15. DATA MANIPULATION

### 15.1 INSERT

```sql
-- Chèn 1 dòng
INSERT INTO TableName (col1, col2, col3)
VALUES (val1, val2, val3);

-- Chèn nhiều dòng
INSERT INTO TableName (col1, col2, col3)
VALUES
    (val1, val2, val3),
    (val4, val5, val6),
    (val7, val8, val9);

-- Chèn với subquery
INSERT INTO ReservationTables (ReservationID, TableID)
SELECT 210, MIN(TableID)
FROM Tables
WHERE Capacity >= 5;

-- Chèn với subquery trong VALUES
INSERT INTO ReservationTables (ReservationID, TableID)
VALUES (210, (SELECT MIN(TableID) FROM Tables WHERE Capacity >= 5));
```

### 15.2 UPDATE

```sql
-- Cơ bản
UPDATE TableName
SET column1 = val1, column2 = val2
WHERE condition;

-- Với expression
UPDATE Account
SET Balance = Balance - @Amount
WHERE AccountId = @AccountId;

-- Update từ subquery
UPDATE Products
SET Price = Price * 1.1
WHERE CategoryId IN (SELECT CategoryId FROM Categories WHERE Name = 'Electronics');
```

### 15.3 DELETE

```sql
-- Có điều kiện
DELETE FROM TableName
WHERE condition;

-- Với subquery
DELETE FROM stocks
WHERE product_id IN (
    SELECT product_id
    FROM products
    WHERE category_name = 'Mountain'
);

-- ⚠️ CẢNH BÁO
DELETE FROM TableName;  -- KHÔNG có WHERE = xóa toàn bộ!
```

---

## 16. KEYWORD MAPPING

### 16.1 Từ khóa → SQL

| Từ khóa trong đề | SQL |
|------------------|-----|
| "retrieve", "display", "show", "list" | SELECT |
| "which is/where" | WHERE |
| "greater than or equal to" | >=, HAVING |
| "most", "maximum", "highest" | TOP 1 ... ORDER DESC hoặc MAX() |
| "least", "minimum", "lowest" | MIN() hoặc subquery |
| "count", "number of" | COUNT() |
| "total", "sum" | SUM() |
| "average" | AVG() |
| "containing the word", "include" | LIKE '%word%' |
| "starts with" | LIKE 'word%' |
| "between ... and ..." | BETWEEN ... AND |
| "in the year" | YEAR(date) = ... |
| "in the month" | MONTH(date) = ... |
| "first quarter" | MONTH() IN (1,2,3) |
| "create a stored procedure" | CREATE PROCEDURE |
| "trigger" | CREATE TRIGGER |
| "function" | CREATE FUNCTION |
| "view" | CREATE VIEW |
| "delete" | DELETE FROM |
| "belongs to" | JOIN + WHERE |
| "include even if no/NULL" | LEFT JOIN |
| "distinct", "duplicate records not repeated" | DISTINCT |
| "output parameter" | @param OUTPUT |
| "raise an error" | RAISERROR, THROW |
| "rollback" | ROLLBACK, BEGIN TRANSACTION |
| "percentage change/growth" | ((new-old)/old)*100 |
| "highest/lowest within each group" | Correlated subquery với MAX/MIN |
| "below the average" | AVG() + subquery/HAVING |
| "in both years" | INNER JOIN 2 CTEs |

### 16.2 Phân tích nhanh một câu hỏi

```
┌─────────────────────────────────────────────────────┐
│  1. Đọc Output → Cần lấy cột nào?                   │
│  2. Đọc Input → Từ bảng/bảng nào?                    │
│  3. Đọc Filter → Điều kiện WHERE/HAVING?              │
│  4. Đọc Aggregate → COUNT/SUM/AVG/MIN/MAX?           │
│  5. Đọc Group → GROUP BY cột nào?                     │
│  6. Đọc Sort → ORDER BY như thế nào?                  │
│  7. Đọc Special → Procedure/Trigger/Function/View?    │
└─────────────────────────────────────────────────────┘
```

### 16.3 Table Mapping (Restaurant Schema)

| Đề bài nói | Bảng cần dùng |
|------------|---------------|
| "customer" | Customers |
| "employee" | Employees |
| "menu item" | MenuItems |
| "order" | Orders |
| "order detail" | OrderDetails |
| "reservation" | Reservations |
| "table" | Tables |
| "reservation table" | ReservationTables |
| "order table" | OrderTables |

---

## 17. ERD TO TABLE CONVERSION

### 17.1 Quy tắc chuyển ERD sang TABLE

```
1. Entity → Table
2. Attribute → Column
3. Primary Key (PK) → PRIMARY KEY
4. Foreign Key (FK) → FOREIGN KEY REFERENCES
5. Multi-valued attribute → Table riêng (tên bảng + tên thuộc tính)
6. Composite attribute → Tách thành các column riêng
7. Relationship M:N → Bridging table (Composite PK)
```

### 17.2 Multi-valued Attribute

```sql
-- ERD: Employee có Phone (double oval = multi-valued)
-- → Tạo bảng riêng: EmployeePhone

CREATE TABLE EmployeePhone (
    EmployeeID INT,
    Phone NVARCHAR(20),
    PRIMARY KEY (EmployeeID, Phone),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);
```

### 17.3 Composite Attribute

```sql
-- ERD: Restaurant có address = {street, city}
-- → Tách thành 2 column

CREATE TABLE Restaurants (
    restaurantID INT PRIMARY KEY,
    name NVARCHAR(100),
    street NVARCHAR(50),    -- Tách từ address
    city NVARCHAR(50)       -- Tách từ address
);
```

### 17.4 Relationship M:N

```sql
-- ERD: Employees (N) works (M:N) Shifts
-- → Tạo bridging table: EmployeeShifts

CREATE TABLE EmployeeShifts (
    EmployeeID INT,
    ShiftID INT,
    PRIMARY KEY (EmployeeID, ShiftID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ShiftID) REFERENCES Shifts(ShiftID)
);
```

---

## 18. COMMON PATTERNS

### 18.1 LEFT JOIN + Aggregate + ISNULL

```sql
SELECT
    c.CustomerID,
    c.FullName,
    ISNULL(COUNT(o.OrderID), 0) AS NumberOfOrders,
    ISNULL(SUM(o.TotalAmount), 0) AS TotalAmount
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
    AND o.Status = 'Completed'
    AND YEAR(o.PaymentTime) = 2025  -- Trong ON!
GROUP BY c.CustomerID, c.FullName;
```

### 18.2 Below/Above Average (All Items)

```sql
WITH AllSales AS (
    SELECT mi.ItemID, mi.ItemName,
           ISNULL(SUM(od.Quantity * od.Price), 0) AS TotalAmount
    FROM MenuItems mi
    LEFT JOIN OrderDetails od ON mi.ItemID = od.ItemID
    LEFT JOIN Orders o ON od.OrderID = o.OrderID
        AND YEAR(o.PaymentTime) = 2023
    GROUP BY mi.ItemID, mi.ItemName
)
SELECT * FROM AllSales
WHERE TotalAmount < (SELECT AVG(TotalAmount) FROM AllSales)
ORDER BY TotalAmount ASC;
```

### 18.3 Multi-Year Comparison + Percentage

```sql
WITH Sales2023 AS (
    SELECT CustomerID, AVG(TotalAmount) AS Avg2023
    FROM Orders WHERE YEAR(PaymentTime) = 2023 AND Status = 'Completed'
    GROUP BY CustomerID
),
Sales2024 AS (
    SELECT CustomerID, AVG(TotalAmount) AS Avg2024
    FROM Orders WHERE YEAR(PaymentTime) = 2024 AND Status = 'Completed'
    GROUP BY CustomerID
)
SELECT
    s23.CustomerID,
    ROUND(s23.Avg2023, 2) AS Avg2023,
    ROUND(s24.Avg2024, 2) AS Avg2024,
    CAST(ROUND(((s24.Avg2024 - s23.Avg2023) / s23.Avg2023 * 100), 2)
         AS NVARCHAR(20)) + ' %' AS PercentageChange
FROM Sales2023 s23
INNER JOIN Sales2024 s24 ON s23.CustomerID = s24.CustomerID;
```

### 18.4 Monthly Report (12 Months Pattern)

```sql
CREATE PROCEDURE MonthlyReport @year INT
AS
BEGIN
    WITH Months AS (
        SELECT 1 AS Month UNION ALL SELECT 2 UNION ALL SELECT 3
        UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6
        UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
        UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL SELECT 12
    )
    SELECT
        CAST(m.Month AS NVARCHAR) + '/' + CAST(@year AS NVARCHAR) AS [Month],
        ISNULL(COUNT(DISTINCT o.OrderID), 0) AS NumberOfOrders,
        ISNULL(SUM(od.Quantity * od.Price), 0) AS TotalRevenue
    FROM Months m
    LEFT JOIN Orders o ON MONTH(o.PaymentTime) = m.Month
        AND YEAR(o.PaymentTime) = @year
        AND o.Status = 'Completed'
    LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID
    GROUP BY m.Month
    ORDER BY m.Month;
END;
```

### 18.5 Trigger Update TotalAmount

```sql
CREATE TRIGGER trg_UpdateTotalAmount
ON OrderDetails
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE o
    SET o.TotalAmount = ISNULL((
        SELECT SUM(od.Quantity * od.Price)
        FROM OrderDetails od
        WHERE od.OrderID = o.OrderID
    ), 0)
    FROM Orders o
    WHERE o.OrderID IN (
        SELECT OrderID FROM inserted
        UNION
        SELECT OrderID FROM deleted
    );
END;
```

### 18.6 INSERT với Subquery

```sql
-- Insert reservation
INSERT INTO Reservations (ReservationID, CustomerID, ReservationTime, GuestCount, Status)
VALUES (210, 7, '2025-11-20 19:15', 5, 'Pending');

-- Insert với subquery (tìm bàn nhỏ nhất)
INSERT INTO ReservationTables (ReservationID, TableID)
SELECT 210, MIN(TableID)
FROM Tables
WHERE Capacity >= 5;
```

---

## 🎯 QUICK REFERENCE - TEMPLATE GỌC Ý

### SELECT cơ bản
```sql
SELECT col1, col2 FROM table WHERE condition ORDER BY col;
```

### JOIN + GROUP BY + HAVING
```sql
SELECT t1.col, COUNT(*) AS cnt
FROM table1 t1
JOIN table2 t2 ON t1.id = t2.id
WHERE condition
GROUP BY t1.col
HAVING COUNT(*) > 3;
```

### LEFT JOIN với NULL
```sql
SELECT t1.col, ISNULL(t2.col, 0) AS col2
FROM table1 t1
LEFT JOIN table2 t2 ON t1.id = t2.id AND t2.status = 'Active'
WHERE condition;
```

### Subquery MIN/MAX
```sql
SELECT * FROM table
WHERE col = (SELECT MIN(col) FROM table);
```

### Below Average
```sql
WITH Temp AS (SELECT col, SUM(val) AS total FROM table GROUP BY col)
SELECT * FROM Temp WHERE total < (SELECT AVG(total) FROM Temp);
```

### Procedure Output
```sql
CREATE PROCEDURE proc_name
    @input INT,
    @output DECIMAL(10,2) OUTPUT
AS
BEGIN
    SELECT @output = SUM(col) FROM table WHERE id = @input;
END;
```

### Trigger UPDATE
```sql
CREATE TRIGGER tr_name
ON table
AFTER UPDATE
AS
BEGIN
    -- Use inserted (NEW) and deleted (OLD)
END;
```

---

**Tài liệu này tổng hợp từ tất cả các coding guide của DBI202**

**Chúc bạn học tốt và thi thành công! 🎉**
