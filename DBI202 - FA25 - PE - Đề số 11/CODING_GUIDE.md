# DBI202 - CODING GUIDE CHO NEWBIE
## Paper 11 - Restaurant Management - Tư duy & Hướng dẫn chi tiết từng bước

---

## 🎯 PHẦN 1: TƯ DUY KHI ĐỌC ĐỀ BÀI

### Step 1: Đọc đề bài - Đừng vội code! ⚠️

Khi nhận đề thi, hãy làm theo thứ tự sau:

```
┌─────────────────────────────────────────────────────────┐
│  1. Lướt qua toàn bộ đề (10 câu hỏi)                    │
│     → Hiểu xem bài thi hỏi CÁI GÌ                       │
│                                                          │
│  2. Xem ERD Diagram                                      │
│     → Xác định các bảng: Tables, Customers, Employees,   │
│         MenuItems, Reservations, Orders, ...             │
│                                                          │
│  3. Đọc kỹ phần SUBMISSION RULES                        │
│     → Folder: RollNo_Name_DBI202_11                     │
│     → Files: Q1.sql, Q2.sql, ..., Q10.sql               │
│     → KHÔNG dùng: CREATE DATABASE, USE, GO, EXEC        │
│                                                          │
│  4. Bắt đầu làm từng câu một                             │
└─────────────────────────────────────────────────────────┘
```

### Step 2: Phân tích đề - Từ vựng quan trọng

| Từ khóa | Nghĩa | SQL thường dùng |
|---------|------|-----------------|
| "who are chefs or managers" | Role là Chef hoặc Manager | WHERE Role IN ('Chef', 'Manager') |
| "were hired in 2021" | Tuyển năm 2021 | YEAR(HireDate) = 2021 |
| "include..." | Chứa chuỗi | LIKE '%...%' |
| "assigned to tables" | Bàn được giao | JOIN ReservationTables |
| "ensure to include tables even if..." | Bao gồm cả khi null | LEFT JOIN |
| "starts with" | Bắt đầu bằng | LIKE 'Nguyễn%' |
| "no completed orders" | Không có đơn hàng hoàn thành | LEFT JOIN + ISNULL |
| "below average" | Dưới trung bình | < AVG() |
| "percentage growth" | Tỷ lệ tăng trưởng | ((new-old)/old)*100 |
| "all 12 months" | Tất cả 12 tháng | LEFT JOIN với numbers table |
| "trigger" | Trigger | CREATE TRIGGER |
| "inserting... after inserting" | Insert sau khi insert | INSERT INTO...VALUES |

### Step 3: Quy trình giải 1 câu hỏi

```
┌─────────────────────────────────────────────────────────────┐
│  CÂU HỎI → PHÂN TÍCH → ĐỊNH DANH BẢNG → VIẾT SQL → CHECK  │
└─────────────────────────────────────────────────────────────┘
     ↓          ↓            ↓             ↓          ↓
   Đọc       Cần         Bảng nào?     Cú pháp      Có
   yêu cầu   output       Join?         nào?         đúng?
```

---

## 🎯 PHẦN 2: ERD DIAGRAM - HIỂU VÀ PHÂN TÍCH

### 2.1 Cách đọc ERD

```
Chìa khóa vàng (🔑)   = Primary Key
Đường nối vô cực      = Foreign Key
Hình chữ nhật         = Bảng (Table)
Số 1, ∞ hoặc N       = Cardinality (1-N, N-M)
```

### 2.2 ERD của đề thi này

```
┌──────────────┐
│   Customers  │
├──────────────┤
│ CustomerID(PK)│
│ FullName     │
│ Phone        │
│ Email        │
│ CreatedDate  │
└──────┬───────┘
       │ 1
       │
       │ places
       │
       │ N
┌──────▼───────┐         ┌──────────────┐
│ Reservations │         │    Tables    │
├──────────────┤         ├──────────────┤
│ ReservationID│────────►│ TableID (PK) │
│ CustomerID   │         │ TableNumber  │
│ ReservationTime│       │ Capacity     │
│ GuestCount   │         │ Location     │
│ Status       │         └──────┬───────┘
│ Notes        │                │
└──────┬───────┘                │
       │                        │
       │                        │
       │ N                      │ N
       │                        │
┌──────▼──────────┐    ┌────────▼─────────┐
│ReservationTables│    │   OrderTables    │
├─────────────────┤    ├──────────────────┤
│ReservationID(PK)│    │ OrderID (PK)     │
│TableID (PK)     │    │ TableID (PK)     │
└─────────────────┘    └─────────┬────────┘
                                 │
                                 │
┌──────────────┐                 │
│   Orders     │◄────────────────┘
├──────────────┤
│ OrderID (PK) │
│ CustomerID   │
│ EmployeeID   │
│ ReservationID│
│ OrderTime    │
│ Status       │
│ PaymentTime  │
│ PaymentMethod│
│ TotalAmount  │
└──────┬───────┘
       │ 1
       │
       │ has
       │
       │ N
┌──────▼──────────┐
│  OrderDetails   │
├─────────────────┤
│ OrderID (PK)    │
│ ItemID (PK)     │
│ Quantity        │
│ Price           │
└─────────────────┘

┌──────────────┐         ┌──────────────┐
│  Employees   │         │  MenuItems   │
├──────────────┤         ├──────────────┤
│ EmployeeID(PK)│        │ ItemID (PK)  │
│ FullName     │         │ ItemName     │
│ Role         │         │ Category     │
│ HireDate     │         │ Price        │
│ Salary       │         │ IsAvailable  │
└──────────────┘         └──────────────┘
```

### 2.3 Các bảng trong database

| Bảng | Primary Key | Foreign Keys |
|------|-------------|--------------|
| Tables | TableID | - |
| Customers | CustomerID | - |
| Employees | EmployeeID | - |
| MenuItems | ItemID | - |
| Reservations | ReservationID | CustomerID |
| Orders | OrderID | CustomerID, EmployeeID, ReservationID |
| ReservationTables | ReservationID + TableID | ReservationID, TableID |
| OrderTables | OrderID + TableID | OrderID, TableID |
| OrderDetails | OrderID + ItemID | OrderID, ItemID |

---

## 🎯 PHẦN 3: TỪNG CÂU HỎI - PHÂN TÍCH & GIẢI

---

## 📌 QUESTION 1: CREATE DATABASE + TABLES [1 điểm]

### 📖 Đọc đề
> "Create one database and then write SQL statements to create, in this database, all tables derived from the ERD..."

### 🧠 Tư duy

```
Yêu cầu: Tạo database + các bảng từ ERD
Input:   ERD Diagram
Output:  CREATE DATABASE + CREATE TABLE statements
Lưu ý:   Giữ nguyên tên bảng, thuộc tính, data type
```

### 🔍 Phân tích

| Bước | Xác định |
|------|----------|
| 1. Số lượng bảng | 9 bảng |
| 2. Thứ tự tạo | Bảng mạnh trước → Bảng có FK → Bảng trung gian |
| 3. Composite PK | ReservationTables, OrderTables, OrderDetails |
| 4. Multi-value attribute | HotelsContact (nếu có trong ERD) |

### ✅ Code

```sql
-- Tạo database
CREATE DATABASE RestaurantDB;
GO

USE RestaurantDB;
GO

-- Bước 1: Tạo bảng MẠNH (không có FK)

CREATE TABLE Tables (
    TableID INT PRIMARY KEY,
    TableNumber INT,
    Capacity INT,
    Location NVARCHAR(100)
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FullName NVARCHAR(100),
    Phone VARCHAR(15),
    Email VARCHAR(50),
    CreatedDate DATE
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FullName NVARCHAR(100),
    Role NVARCHAR(50),
    HireDate DATE,
    Salary DECIMAL(18, 2)
);

CREATE TABLE MenuItems (
    ItemID INT PRIMARY KEY,
    ItemName NVARCHAR(100),
    Category NVARCHAR(50),
    Price DECIMAL(12, 2),
    IsAvailable BIT
);

-- Bước 2: Tạo bảng có FK

CREATE TABLE Reservations (
    ReservationID INT PRIMARY KEY,
    CustomerID INT,
    ReservationTime DATETIME,
    GuestCount INT,
    Status NVARCHAR(20),
    Notes NVARCHAR(200),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    EmployeeID INT,
    ReservationID INT,
    OrderTime DATETIME,
    Status NVARCHAR(20),
    PaymentTime DATETIME,
    PaymentMethod NVARCHAR(50),
    TotalAmount DECIMAL(18, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ReservationID) REFERENCES Reservations(ReservationID)
);

-- Bước 3: Tạo bảng trung gian (Composite PK)

CREATE TABLE ReservationTables (
    ReservationID INT,
    TableID INT,
    PRIMARY KEY (ReservationID, TableID),
    FOREIGN KEY (ReservationID) REFERENCES Reservations(ReservationID),
    FOREIGN KEY (TableID) REFERENCES Tables(TableID)
);

CREATE TABLE OrderTables (
    OrderID INT,
    TableID INT,
    PRIMARY KEY (OrderID, TableID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (TableID) REFERENCES Tables(TableID)
);

CREATE TABLE OrderDetails (
    OrderID INT,
    ItemID INT,
    Quantity INT,
    Price DECIMAL(12, 2),
    PRIMARY KEY (OrderID, ItemID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ItemID) REFERENCES MenuItems(ItemID)
);
```

---

## 📌 QUESTION 2: SELECT WHERE + IN + YEAR [1 điểm]

### 📖 Đọc đề
> "Display all employees who are chefs or managers and were hired in 2021."

### 🧠 Tư duy

```
Yêu cầu: Lấy nhân viên là Chef hoặc Manager, tuyển năm 2021
Input:   Bảng Employees
Output:  EmployeeID, FullName, Role, HireDate, Salary
ĐK lọc:  Role IN ('Chef', 'Manager') AND YEAR(HireDate) = 2021
```

### 🔍 Phân tích

| Keyword | SQL |
|---------|-----|
| "chefs or managers" | Role IN ('Chef', 'Manager') hoặc OR |
| "were hired in 2021" | YEAR(HireDate) = 2021 |

### ✅ Code

```sql
SELECT EmployeeID,
       FullName,
       Role,
       HireDate,
       Salary
FROM Employees
WHERE Role IN ('Chef', 'Manager')
  AND YEAR(HireDate) = 2021;
```

### 💡 3 cách viết điều kiện OR

```sql
-- Cách 1: IN (khuyến nghị - ngắn gọn)
WHERE Role IN ('Chef', 'Manager')

-- Cách 2: OR
WHERE Role = 'Chef' OR Role = 'Manager'

-- Cách 3: Dùng || (SQL Server không hỗ trợ)
-- WHERE Role = 'Chef' || Role = 'Manager' -- ❌ SAI
```

---

## 📌 QUESTION 3: MULTI-JOIN + LIKE + YEAR [1 điểm]

### 📖 Đọc đề
> "Display customers who made reservations in 2025 and were assigned to tables whose locations include 'Khu A'."

### 🧠 Tư duy

```
Yêu cầu: Khách đặt bàn năm 2025, bàn ở "Khu A"
Input:   Customers, Reservations, ReservationTables, Tables
Output:  CustomerID, FullName, ReservationTime, TableID, Location
ĐK lọc:  YEAR(ReservationTime) = 2025 AND Location LIKE '%Khu A%'
```

### 🔍 Phân tích

| Bước | Xác định |
|------|----------|
| 1. Bảng cần | Customers, Reservations, ReservationTables, Tables |
| 2. Join chain | Customers → Reservations → ReservationTables → Tables |
| 3. Filter | YEAR(ReservationTime) = 2025, Location LIKE '%Khu A%' |

### ✅ Code

```sql
SELECT c.CustomerID,
       c.FullName,
       r.ReservationTime,
       rt.TableID,
       t.Location
FROM Customers c
JOIN Reservations r ON c.CustomerID = r.CustomerID
JOIN ReservationTables rt ON r.ReservationID = rt.ReservationID
JOIN Tables t ON rt.TableID = t.TableID
WHERE YEAR(r.ReservationTime) = 2025
  AND t.Location LIKE '%Khu A%';
```

### 💡 Chuỗi JOIN

```
Customer → Reservation → ReservationTable → Table
   ↓            ↓                ↓              ↓
 Khách      Đặt bàn         Bàn được gán     Thông tin bàn
```

---

## 📌 QUESTION 4: LEFT JOIN + ISNULL + ORDER BY DESC + ASC [1 điểm]

### 📖 Đọc đề
> "List tables in Khu A/B/C along with customers who reserved them in September 2025. Include tables even if no customer reserved them."

### 🧠 Tư duy

```
Yêu cầu: Bàn Khu A/B/C + Khách đặt tháng 9/2025
         Bao gồm cả bàn KHÔNG có khách đặt
Input:   Tables, ReservationTables, Reservations, Customers
Output:  TableID, Capacity, Location, CustomerID, FullName
Sort:    Capacity DESC, Location ASC
```

### 🔍 Phân tích

| Keyword | SQL |
|---------|-----|
| "include tables even if no customer" | LEFT JOIN (bắt đầu từ Tables) |
| "Khu A, Khu B or Khu C" | Location LIKE '%Khu A%' OR ... |
| "September 2025" | MONTH() = 9 AND YEAR() = 2025 |

### ✅ Code

```sql
SELECT t.TableID,
       t.Capacity,
       t.Location,
       c.CustomerID,
       c.FullName
FROM Tables t
LEFT JOIN ReservationTables rt ON t.TableID = rt.TableID
LEFT JOIN Reservations r ON rt.ReservationID = r.ReservationID
LEFT JOIN Customers c ON r.CustomerID = c.CustomerID
WHERE (t.Location LIKE '%Khu A%' OR t.Location LIKE '%Khu B%' OR t.Location LIKE '%Khu C%')
  AND (MONTH(r.ReservationTime) = 9 AND YEAR(r.ReservationTime) = 2025 OR r.ReservationTime IS NULL)
ORDER BY t.Capacity DESC, t.Location ASC;
```

### 💡 Tại sao LEFT JOIN?

```
INNER JOIN: Chỉ lấy bàn CÓ khách đặt
LEFT JOIN:   Lấy TẤT CẢ bàn + bàn có khách (NULL nếu không có)

┌────────────────────────────────────────┐
│  Bàn 1 - Không có khách → CustomerID = NULL │
│  Bàn 2 - Có khách A   → CustomerID = A      │
│  Bàn 3 - Có khách B   → CustomerID = B      │
└────────────────────────────────────────┘
```

---

## 📌 QUESTION 5: LEFT JOIN + ISNULL + STARTS WITH [1 điểm]

### 📖 Đọc đề
> "List customers whose full name starts with 'Nguyễn' or 'Bùi', showing number of completed orders in 2025 and total amount. If no completed orders, display 0."

### 🧠 Tư duy

```
Yêu cầu: Khách tên Nguyễn/Bùi + Số đơn hàng + Tổng tiền 2025
         Hiện cả khách KHÔNG có đơn hàng (NumberOfOrders = 0)
Input:   Customers, Orders
Output:  CustomerID, FullName, NumberOfOrders, TotalAmount
```

### 🔍 Phân tích

| Bước | Xác định |
|------|----------|
| 1. Bảng cần | Customers, Orders |
| 2. Join | LEFT JOIN (để lấy cả khách không có đơn) |
| 3. Filter name | FullName LIKE 'Nguyễn%' OR LIKE 'Bùi%' |
| 4. Filter completed | Status = 'Completed' AND YEAR() = 2025 |
| 5. Aggregate | COUNT(OrderID), SUM(TotalAmount) |
| 6. Handle NULL | ISNULL(..., 0) |

### ✅ Code

```sql
SELECT c.CustomerID,
       c.FullName,
       ISNULL(COUNT(o.OrderID), 0) AS NumberOfOrders,
       ISNULL(SUM(o.TotalAmount), 0) AS TotalAmount
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
   AND o.Status = 'Completed'
   AND YEAR(o.PaymentTime) = 2025
WHERE c.FullName LIKE 'Nguyễn%' OR c.FullName LIKE 'Bùi%'
GROUP BY c.CustomerID, c.FullName
ORDER BY c.CustomerID;
```

### 💡 Quan trọng: Điều kiện trong ON vs WHERE

```sql
-- Đặt điều kiện trong ON khi dùng LEFT JOIN
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
   AND o.Status = 'Completed'  -- ← Ở đây!
   AND YEAR(o.PaymentTime) = 2025

-- Tại sao?
-- Nếu đặt WHERE: sẽ LỌC BỎ rows NULL (không có đơn)
-- Nếu đặt ON: sẽ GIỮ LẠI rows NULL và gán giá trị cho phù hợp
```

### 💡 ISNULL vs COALESCE

```sql
-- ISNULL (SQL Server)
ISNULL(value, 0)

-- COALESCE (chuẩn SQL, nhiều DB)
COALESCE(value, 0)

-- Với bài thi: Dùng ISNULL là đủ
```

---

## 📌 QUESTION 6: SUBQUERY + AVG + CROSS JOIN [1 điểm]

### 📖 Đọc đề
> "List menu items whose total sales in 2023 is below the average total sales of all items in 2023, including those with no sales."

### 🧠 Tư duy

```
Yêu cầu: Món ăn có doanh thu 2023 < TB doanh thu TẤT CẢ món
         Bao gồm món KHÔNG bán được (TotalAmount = 0)
Input:   MenuItems, Orders, OrderDetails
Output:  ItemID, ItemName, Category, TotalAmount
```

### 🔍 Phân tích

| Bước | Xác định |
|------|----------|
| 1. Tính doanh thu mỗi món | LEFT JOIN Orders + OrderDetails |
| 2. Tính average ALL items | Cần tính TRÊN TẤT CẢ món (kể cả = 0) |
| 3. Filter | TotalAmount < Average |
| 4. Sort | TotalAmount ASC, ItemID ASC |

### ✅ Code

```sql
WITH AllItemSales AS (
    SELECT m.ItemID,
           m.ItemName,
           m.Category,
           ISNULL(SUM(od.Quantity * od.Price), 0) AS TotalAmount
    FROM MenuItems m
    LEFT JOIN OrderDetails od ON m.ItemID = od.ItemID
    LEFT JOIN Orders o ON od.OrderID = o.OrderID
        AND o.Status = 'Completed'
        AND YEAR(o.PaymentTime) = 2023
    GROUP BY m.ItemID, m.ItemName, m.Category
)
SELECT ItemID,
       ItemName,
       Category,
       TotalAmount
FROM AllItemSales
WHERE TotalAmount < (SELECT AVG(TotalAmount) FROM AllItemSales)
ORDER BY TotalAmount ASC, ItemID ASC;
```

### 💡 Tại sao dùng CTE?

```
CTE (Common Table Expression) = Temporary View

1. Tính doanh thu TẤT CẢ món (kể cả = 0)
2. Lưu kết quả vào AllItemSales
3. Tính AVG từ AllItemSales (đúng bao gồm = 0)
4. Filter món < AVG
```

### 💡 Công thức tính doanh thu

```sql
-- Doanh thu = Sum(Số lượng × Giá)
SUM(od.Quantity * od.Price)

-- KHÔNG DÙNG m.Price (giá hiện tại)
-- Phải dùng od.Price (giá tại thời điểm đặt)
```

---

## 📌 QUESTION 7: PERCENTAGE CHANGE + SELF-JOIN [1 điểm]

### 📖 Đọc đề
> "For customers with completed orders in both 2024 and 2025, calculate average order value for each year and percentage change."

### 🧠 Tư duy

```
Yêu cầu: Khách có đơn 2024 VÀ 2025
         Tính AVG TotalAmount mỗi năm
         Tính % tăng trưởng = (Avg2025 - Avg2024) / Avg2024 * 100
Input:   Customers, Orders
Output:  CustomerID, FullName, Avg2024, Avg2025, Percentagechange
```

### 🔍 Phân tích

| Bước | Xác định |
|------|----------|
| 1. Lọc đơn hoàn thành | Status = 'Completed' |
| 2. Tính AVG 2024 | GROUP BY CustomerID, YEAR() = 2024 |
| 3. Tính AVG 2025 | GROUP BY CustomerID, YEAR() = 2025 |
| 4. Join 2 kết quả | INNER JOIN (chỉ lấy khách CÓ cả 2 năm) |
| 5. Tính % | ((Avg2025 - Avg2024) / Avg2024) * 100 |
| 6. Format | CAST AS VARCHAR + '%' |

### ✅ Code

```sql
WITH Avg2024 AS (
    SELECT c.CustomerID,
           AVG(o.TotalAmount) AS Avg2024
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    WHERE o.Status = 'Completed'
      AND YEAR(o.PaymentTime) = 2024
    GROUP BY c.CustomerID
),
Avg2025 AS (
    SELECT c.CustomerID,
           AVG(o.TotalAmount) AS Avg2025
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    WHERE o.Status = 'Completed'
      AND YEAR(o.PaymentTime) = 2025
    GROUP BY c.CustomerID
)
SELECT a.CustomerID,
       c.FullName,
       ROUND(a.Avg2024, 2) AS AvgTotalOrderValue2024,
       ROUND(b.Avg2025, 2) AS AvgTotalOrderValue2025,
       CAST(ROUND(((b.Avg2025 - a.Avg2024) / a.Avg2024) * 100, 2) AS VARCHAR(10)) + '%' AS Percentagechange
FROM Avg2024 a
JOIN Avg2025 b ON a.CustomerID = b.CustomerID
JOIN Customers c ON a.CustomerID = c.CustomerID
ORDER BY a.CustomerID;
```

### 💡 Công thức % tăng trưởng

```
        Avg2025 - Avg2024
% = ───────────────────── × 100
            Avg2024

Ví dụ: 2024 = 100, 2025 = 150
% = (150-100)/100 × 100 = 50%

Ví dụ: 2024 = 100, 2025 = 80
% = (80-100)/100 × 100 = -20%
```

---

## 📌 QUESTION 8: STORED PROCEDURE + MONTHLY SUMMARY [1 điểm]

### 📖 Đọc đề
> "Create a stored procedure MonthlySalesSummary that generates a monthly sales report for a specified year. Display all 12 months, even if no orders."

### 🧠 Tư duy

```
Yêu cầu: Procedure báo cáo doanh thu theo tháng
Input:   @year INT
Output:  Month (MM/YYYY), NumberOfOrders, TotalRevenue
ĐK:     Phải hiện CẢ 12 tháng (kể cả tháng không có đơn)
```

### 🔍 Phân tích

| Bước | Xác định |
|------|----------|
| 1. Input param | @year INT |
| 2. Tạo số 1-12 | Dùng CTE hoặc VALUES |
| 3. LEFT JOIN Orders | Để giữ tháng không có đơn |
| 4. Filter | Status = 'Completed', YEAR() = @year |
| 5. Aggregate | COUNT(OrderID), SUM(Quantity × Price) |
| 6. Format | 'Month/Year' |

### ✅ Code

```sql
CREATE PROCEDURE MonthlySalesSummary
    @year INT
AS
BEGIN
    WITH Months AS (
        SELECT 1 AS Month UNION ALL SELECT 2 UNION ALL SELECT 3
        UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6
        UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
        UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL SELECT 12
    )
    SELECT CAST(m.Month AS VARCHAR(2)) + '/' + CAST(@year AS VARCHAR(4)) AS Month,
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

### 💡 Cách tạo số 1-12

```sql
-- Cách 1: CTE (nhưng SQL Server không hỗ trợ đệ quy trong CTE này)
-- Cách 2: VALUES
SELECT * FROM (VALUES (1), (2), ..., (12)) AS Months(Month)

-- Cách 3: UNION ALL (đơn giản nhất)
SELECT 1 AS Month UNION ALL SELECT 2 ...
```

---

## 📌 QUESTION 9: TRIGGER - UPDATE TOTAL AMOUNT [1 điểm]

### 📖 Đọc đề
> "Create a trigger trg_UpdateTotalAmount on OrderDetails to recalculate TotalAmount in Orders whenever OrderDetails is inserted, updated, or deleted."

### 🧠 Tư duy

```
Yêu cầu: Trigger tự động tính lại TotalAmount khi OrderDetails thay đổi
Event:   INSERT, UPDATE, DELETE trên OrderDetails
Action:  UPDATE Orders.TotalAmount = SUM(Quantity × Price)
```

### 🔍 Phân tích

| Thành phần | Giá trị |
|------------|---------|
| Tên trigger | trg_UpdateTotalAmount |
| Bảng | OrderDetails |
| Event | INSERT, UPDATE, DELETE |
| Timing | AFTER |
| Logic | Cập nhật TotalAmount cho các Order bị ảnh hưởng |

### ✅ Code

```sql
CREATE TRIGGER trg_UpdateTotalAmount
ON OrderDetails
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Cập nhật cho các Order bị ảnh hưởng
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

### 💡 Bảng ảo trong Trigger

```
┌─────────────────────────────────────────────────────────┐
│  INSERT: inserted có NEW, deleted TRỐNG                 │
│  UPDATE: inserted có NEW, deleted có OLD                │
│  DELETE: inserted TRỐNG, deleted có OLD                 │
└─────────────────────────────────────────────────────────┘

→ UNION để lấy TẤT CẢ OrderID bị ảnh hưởng
```

---

## 📌 QUESTION 10: INSERT + SUBQUERY [1 điểm]

### 📖 Đọc đề
> "Create a reservation for CustomerID = 7, 5 guests, on November 20, 2025, at 19:15. ReservationID = 210. Assign to table with smallest TableID with capacity >= 5."

### 🧠 Tư duy

```
Yêu cầu: Insert Reservations + Insert ReservationTables
         Table tìm: MIN(TableID) WHERE Capacity >= 5
```

### 🔍 Phân tích

| Bước | Xác định |
|------|----------|
| 1. Insert Reservations | ReservationID = 210, CustomerID = 7... |
| 2. Tìm TableID | SELECT MIN(TableID) FROM Tables WHERE Capacity >= 5 |
| 3. Insert ReservationTables | (210, TableID tìm được) |

### ✅ Code

```sql
-- Bước 1: Insert reservation
INSERT INTO Reservations (ReservationID, CustomerID, ReservationTime, GuestCount, Status)
VALUES (210, 7, '2025-11-20 19:15', 5, 'Confirmed');

-- Bước 2: Insert vào ReservationTables với table tìm được
INSERT INTO ReservationTables (ReservationID, TableID)
SELECT 210, MIN(TableID)
FROM Tables
WHERE Capacity >= 5;
```

### 💡 Subquery trong INSERT

```sql
-- Dùng subquery để tìm giá trị
INSERT INTO ReservationTables (ReservationID, TableID)
VALUES (210, (SELECT MIN(TableID) FROM Tables WHERE Capacity >= 5));

-- Hoặc SELECT ... FROM (phổ biến hơn)
INSERT INTO ReservationTables (ReservationID, TableID)
SELECT 210, MIN(TableID)
FROM Tables
WHERE Capacity >= 5;
```

---

## 🎯 PHẦN 4: TỔNG HỢP SYNTAX

### 4.1 LEFT JOIN với điều kiện

```sql
-- Điều kiện trong ON (khuyến nghị cho LEFT JOIN)
FROM table1 t1
LEFT JOIN table2 t2 ON t1.id = t2.id AND t2.status = 'Active'

-- Điều kiện trong WHERE
FROM table1 t1
LEFT JOIN table2 t2 ON t1.id = t2.id
WHERE t2.status = 'Active' OR t2.id IS NULL
```

### 4.2 ISNULL / COALESCE

```sql
-- ISNULL (SQL Server)
ISNULL(column, 0)

-- COALESCE (chuẩn SQL)
COALESCE(column, 0)
```

### 4.3 LIKE patterns

```sql
-- Bắt đầu bằng
LIKE 'Nguyễn%'

-- Kết thúc bằng
LIKE '%@gmail.com'

-- Chứa
LIKE '%Khu A%'
```

### 4.4 CTE (Common Table Expression)

```sql
WITH CTEName AS (
    SELECT ...
)
SELECT ... FROM CTEName;
```

### 4.5 Trigger với INSERT/UPDATE/DELETE

```sql
CREATE TRIGGER trigger_name
ON table_name
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    -- Logic
    -- Use inserted and deleted tables
END;
```

---

## 🎯 PHẦN 5: CHECKLIST TRƯỚC KHI NỘP

```
☐ Folder tên đúng: RollNo_Name_DBI202_11
☐ Không có subfolder
☐ File naming: Q1.sql, Q2.sql, ..., Q10.sql
☐ Q1.sql: Có CREATE DATABASE (chỉ Q1 có)
☐ Q2-Q10: KHÔNG có USE, GO, EXEC
☐ Chỉ chứa câu trả lời (không có test code)
☐ LEFT JOIN khi cần giữ NULL
☐ ISNULL khi cần giá trị mặc định
☐ CÓ ROUND khi làm tròn
☐ CÁCH tính % đúng
```

---

## 🎯 PHẦN 6: FAQ - CÂU HỎI THƯỜNG GẶP

### Q1: Tại sao Q4 dùng LEFT JOIN từ Tables?

```
Vì đề yêu cầu "include tables even if no customer reserved"
→ Tables là bảng chính (bên trái)
→ LEFT JOIN để giữ TẤT CẢ bàn
```

### Q2: Khi nào dùng ISNULL?

```
Dùng khi:
- LEFT JOIN tạo ra NULL
- Cần hiển thị 0 thay vì NULL
- Tính toán với aggregate có thể NULL
```

### Q3: Tính % tăng trưởng có âm không?

```
CÓ! Nếu Avg2025 < Avg2024 thì % sẽ âm
Ví dụ: (80-100)/100 × 100 = -20%
```

### Q4: Tại sao Q6 cần CTE?

```
Vì cần:
1. Tính doanh thu TẤT CẢ món (kể cả = 0)
2. Tính AVG từ TẤT CẢ món đó
3. So sánh từng món với AVG

Nếu không CTE: sẽ mất các món = 0
```

### Q5: Trigger với INSERT/UPDATE/DELETE khác gì?

```
INSERT:   inserted có NEW, deleted EMPTY
UPDATE:   inserted có NEW, deleted có OLD
DELETE:   inserted EMPTY, deleted có OLD

→ UNION để lấy ALL affected OrderID
```

---

## 🎯 PHẦN 7: TRICKS & TRAPS

### ⚠️ CÁC BẪY THƯỜNG GẶP

| Bẫy | VD | Cách tránh |
|-----|----|------------|
| Sai JOIN type | INNER thay LEFT | Đọc kỹ "include even if" |
| Quên ISNULL | NULL thay vì 0 | Dùng ISNULL(..., 0) |
| Điều kiện WHERE sai | Lọc bỏ NULL | Đặt điều kiện trong ON |
| Quên ROUND | Số quá dài | ROUND(..., 2) |
| Sai công thức % | (new-old)/old | Công thức đúng |
| Quên UNION trong trigger | Chỉ lấy inserted | UNION inserted + deleted |
| Khó chịu with MONTH() | Lỗi月份 | Dùng CTE hoặc tách riêng |

### ✅ MẸO ĐẠT ĐIỂM CAO

1. **Đọc đề kỹ 2 lần** - đặc biệt "include even if"
2. **Vẽ sơ đồ JOIN** trước khi viết
3. **Test từng phần** - CTE, subquery
4. **Format code** - dễ đọc
5. **So sánh output** với đề bài từng cột

---

## 🎯 PHẦN 8: FULL SOLUTION - THAM KHẢO

```sql
-- ==========================================
-- Q1: CREATE DATABASE + TABLES
-- ==========================================

CREATE DATABASE RestaurantDB;
GO

USE RestaurantDB;
GO

-- Tables without FK
CREATE TABLE Tables (
    TableID INT PRIMARY KEY,
    TableNumber INT,
    Capacity INT,
    Location NVARCHAR(100)
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FullName NVARCHAR(100),
    Phone VARCHAR(15),
    Email VARCHAR(50),
    CreatedDate DATE
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FullName NVARCHAR(100),
    Role NVARCHAR(50),
    HireDate DATE,
    Salary DECIMAL(18, 2)
);

CREATE TABLE MenuItems (
    ItemID INT PRIMARY KEY,
    ItemName NVARCHAR(100),
    Category NVARCHAR(50),
    Price DECIMAL(12, 2),
    IsAvailable BIT
);

-- Tables with FK
CREATE TABLE Reservations (
    ReservationID INT PRIMARY KEY,
    CustomerID INT,
    ReservationTime DATETIME,
    GuestCount INT,
    Status NVARCHAR(20),
    Notes NVARCHAR(200),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    EmployeeID INT,
    ReservationID INT,
    OrderTime DATETIME,
    Status NVARCHAR(20),
    PaymentTime DATETIME,
    PaymentMethod NVARCHAR(50),
    TotalAmount DECIMAL(18, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ReservationID) REFERENCES Reservations(ReservationID)
);

-- Junction tables
CREATE TABLE ReservationTables (
    ReservationID INT,
    TableID INT,
    PRIMARY KEY (ReservationID, TableID),
    FOREIGN KEY (ReservationID) REFERENCES Reservations(ReservationID),
    FOREIGN KEY (TableID) REFERENCES Tables(TableID)
);

CREATE TABLE OrderTables (
    OrderID INT,
    TableID INT,
    PRIMARY KEY (OrderID, TableID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (TableID) REFERENCES Tables(TableID)
);

CREATE TABLE OrderDetails (
    OrderID INT,
    ItemID INT,
    Quantity INT,
    Price DECIMAL(12, 2),
    PRIMARY KEY (OrderID, ItemID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ItemID) REFERENCES MenuItems(ItemID)
);

-- ==========================================
-- Q2: Employees (Chef/Manager) hired in 2021
-- ==========================================

SELECT EmployeeID, FullName, Role, HireDate, Salary
FROM Employees
WHERE Role IN ('Chef', 'Manager') AND YEAR(HireDate) = 2021;

-- ==========================================
-- Q3: Reservations 2025 in Khu A
-- ==========================================

SELECT c.CustomerID, c.FullName, r.ReservationTime, rt.TableID, t.Location
FROM Customers c
JOIN Reservations r ON c.CustomerID = r.CustomerID
JOIN ReservationTables rt ON r.ReservationID = rt.ReservationID
JOIN Tables t ON rt.TableID = t.TableID
WHERE YEAR(r.ReservationTime) = 2025 AND t.Location LIKE '%Khu A%';

-- ==========================================
-- Q4: Tables Khu A/B/C + Sep 2025 reservations
-- ==========================================

SELECT t.TableID, t.Capacity, t.Location, c.CustomerID, c.FullName
FROM Tables t
LEFT JOIN ReservationTables rt ON t.TableID = rt.TableID
LEFT JOIN Reservations r ON rt.ReservationID = r.ReservationID
LEFT JOIN Customers c ON r.CustomerID = c.CustomerID
WHERE (t.Location LIKE '%Khu A%' OR t.Location LIKE '%Khu B%' OR t.Location LIKE '%Khu C%')
  AND (MONTH(r.ReservationTime) = 9 AND YEAR(r.ReservationTime) = 2025 OR r.ReservationTime IS NULL)
ORDER BY t.Capacity DESC, t.Location ASC;

-- ==========================================
-- Q5: Customers Nguyễn/Bùi + Orders 2025
-- ==========================================

SELECT c.CustomerID, c.FullName,
       ISNULL(COUNT(o.OrderID), 0) AS NumberOfOrders,
       ISNULL(SUM(o.TotalAmount), 0) AS TotalAmount
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
   AND o.Status = 'Completed' AND YEAR(o.PaymentTime) = 2025
WHERE c.FullName LIKE 'Nguyễn%' OR c.FullName LIKE 'Bùi%'
GROUP BY c.CustomerID, c.FullName
ORDER BY c.CustomerID;

-- ==========================================
-- Q6: Items below average sales 2023
-- ==========================================

WITH AllItemSales AS (
    SELECT m.ItemID, m.ItemName, m.Category,
           ISNULL(SUM(od.Quantity * od.Price), 0) AS TotalAmount
    FROM MenuItems m
    LEFT JOIN OrderDetails od ON m.ItemID = od.ItemID
    LEFT JOIN Orders o ON od.OrderID = o.OrderID
        AND o.Status = 'Completed' AND YEAR(o.PaymentTime) = 2023
    GROUP BY m.ItemID, m.ItemName, m.Category
)
SELECT ItemID, ItemName, Category, TotalAmount
FROM AllItemSales
WHERE TotalAmount < (SELECT AVG(TotalAmount) FROM AllItemSales)
ORDER BY TotalAmount ASC, ItemID ASC;

-- ==========================================
-- Q7: Percentage change 2024-2025
-- ==========================================

WITH Avg2024 AS (
    SELECT c.CustomerID, AVG(o.TotalAmount) AS Avg2024
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    WHERE o.Status = 'Completed' AND YEAR(o.PaymentTime) = 2024
    GROUP BY c.CustomerID
),
Avg2025 AS (
    SELECT c.CustomerID, AVG(o.TotalAmount) AS Avg2025
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    WHERE o.Status = 'Completed' AND YEAR(o.PaymentTime) = 2025
    GROUP BY c.CustomerID
)
SELECT a.CustomerID, c.FullName,
       ROUND(a.Avg2024, 2) AS AvgTotalOrderValue2024,
       ROUND(b.Avg2025, 2) AS AvgTotalOrderValue2025,
       CAST(ROUND(((b.Avg2025 - a.Avg2024) / a.Avg2024) * 100, 2) AS VARCHAR(10)) + '%' AS Percentagechange
FROM Avg2024 a
JOIN Avg2025 b ON a.CustomerID = b.CustomerID
JOIN Customers c ON a.CustomerID = c.CustomerID
ORDER BY a.CustomerID;

-- ==========================================
-- Q8: Monthly Sales Summary Procedure
-- ==========================================

CREATE PROCEDURE MonthlySalesSummary
    @year INT
AS
BEGIN
    WITH Months AS (
        SELECT 1 AS Month UNION ALL SELECT 2 UNION ALL SELECT 3
        UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6
        UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
        UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL SELECT 12
    )
    SELECT CAST(m.Month AS VARCHAR(2)) + '/' + CAST(@year AS VARCHAR(4)) AS Month,
           ISNULL(COUNT(DISTINCT o.OrderID), 0) AS NumberOfOrders,
           ISNULL(SUM(od.Quantity * od.Price), 0) AS TotalRevenue
    FROM Months m
    LEFT JOIN Orders o ON MONTH(o.PaymentTime) = m.Month
        AND YEAR(o.PaymentTime) = @year AND o.Status = 'Completed'
    LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID
    GROUP BY m.Month
    ORDER BY m.Month;
END;

-- ==========================================
-- Q9: Trigger Update TotalAmount
-- ==========================================

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

-- ==========================================
-- Q10: Insert Reservation
-- ==========================================

INSERT INTO Reservations (ReservationID, CustomerID, ReservationTime, GuestCount, Status)
VALUES (210, 7, '2025-11-20 19:15', 5, 'Confirmed');

INSERT INTO ReservationTables (ReservationID, TableID)
SELECT 210, MIN(TableID)
FROM Tables
WHERE Capacity >= 5;
```

---

**Chúc bạn thi tốt! 🎉**

Made with ❤️ for DBI202 students
