# 📘 DBI202 - CODING GUIDE CHO NEWBIE
## Paper 5 - Restaurant Management System - Tư duy & Hướng dẫn chi tiết từng bước

---

## 🚨 QUAN TRỌNG: Q1.SQL NỘP GÌ?

```
❌ KHÔNG nộp: CREATE DATABASE, USE, GO, EXEC
✅ CHỈ nộp:  CREATE TABLE statements

Q1.sql CHỈ chứa CREATE TABLE - không có gì khác!
```

### 📋 Mẫu Q1.sql (Paper 5):

```sql
CREATE TABLE Tables (
    TableID INT PRIMARY KEY,
    TableNumber INT,
    Capacity INT,
    Location NVARCHAR(50)
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FullName NVARCHAR(50),
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    CreatedDate DATE
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FullName NVARCHAR(50),
    Role NVARCHAR(50),
    HireDate DATE,
    Salary DECIMAL(18,2)
);

CREATE TABLE MenuItems (
    ItemID INT PRIMARY KEY,
    ItemName NVARCHAR(100),
    Category NVARCHAR(50),
    Price MONEY,
    IsAvailable BIT
);

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
    PaymentMethod NVARCHAR(20),
    TotalAmount MONEY,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ReservationID) REFERENCES Reservations(ReservationID)
);

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
    Price MONEY,
    PRIMARY KEY (OrderID, ItemID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ItemID) REFERENCES MenuItems(ItemID)
);
```

---

## 🎯 PHẦN 1: TƯ DUY KHI ĐỌC ĐỀ BÀI

### Step 1: Đọc đề bài - Đừng vội code! ⚠️

Khi nhận đề thi, hãy làm theo thứ tự sau:

```
┌─────────────────────────────────────────────────────────┐
│  1. Lướt qua toàn bộ đề (10 câu hỏi)                    │
│     → Hiểu xem bài thi hỏi CÁI GÌ                       │
│                                                          │
│  2. Xem ERD Diagram (Picture 1.1 và Database Diagram)    │
│     → Xác định các bảng, trường, quan hệ                │
│                                                          │
│  3. Đọc kỹ phần SUBMISSION RULES                        │
│     → Tránh bị 0 điểm vì sai format                     │
│                                                          │
│  4. Bắt đầu làm từng câu một                             │
└─────────────────────────────────────────────────────────┘
```

### Step 2: Phân tích đề - Từ vựng quan trọng

| Từ khóa | Nghĩa | SQL thường dùng |
|---------|------|-----------------|
| "retrieve", "display", "show" | Lấy dữ liệu | SELECT |
| "which/where/who" | Điều kiện lọc | WHERE |
| "distinct", "duplicate records are not repeated" | Loại bỏ trùng | DISTINCT |
| "even if not ordered by any customer" | Bao gồm cả NULL | LEFT JOIN |
| "start with" | Bắt đầu bằng | LIKE 'Nguyen%' |
| "average", "below average" | So sánh với TB | AVG(), subquery |
| "stored procedure" | Thủ tục lưu trữ | CREATE PROCEDURE |
| "trigger" | Trigger | CREATE TRIGGER |
| "insert", "create a new reservation" | Thêm dữ liệu | INSERT |

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

### 2.1 Cách đọc ERD (Picture 1.1 - Conceptual)

```
Hình chữ nhật         = Entity (Bảng)
Hình bầu dục          = Attribute
Hình bầu dục đôi      = Multi-valued attribute (sẽ thành bảng riêng)
Hình thoi (diamond)   = Relationship
Chữ underlined        = Primary Key
```

**Lưu ý đặc biệt:**
- Multi-valued attribute (Phone) → Tạo bảng riêng: `EmployeePhone`
- Composite attribute (address) → Tách thành: `street`, `city`

### 2.2 Physical Database Schema

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│  Customers  │     │  Employees   │     │  MenuItems  │
├─────────────┤     ├──────────────┤     ├─────────────┤
│ CustomerID  │     │ EmployeeID   │     │ ItemID      │
│ FullName    │     │ FullName     │     │ ItemName    │
│ Phone       │     │ Role         │     │ Category    │
│ Email       │     │ HireDate     │     │ Price       │
│ CreatedDate │     │ Salary       │     │ IsAvailable │
└──────┬──────┘     └──────┬───────┘     └──────┬──────┘
       │                   │                     │
       │                   │                     │
       ▼                   ▼                     ▼
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│ Reservations│     │    Orders    │     │ OrderDetails│
├─────────────┤     ├──────────────┤     ├─────────────┤
│ ReservationID│    │ OrderID      │     │ OrderID     │←──┐
│ CustomerID  │     │ CustomerID   │     │ ItemID      │   │
│ ReservationTime│  │ EmployeeID   │     │ Quantity    │   │
│ GuestCount  │     │ ReservationID│     │ Price       │   │
│ Status      │     │ OrderTime    │     └─────────────┘   │
│ Notes       │     │ Status       │           │            │
└──────┬──────┘     │ PaymentTime  │           │            │
       │            │ PaymentMethod│           │            │
       │            │ TotalAmount  │           │            │
       │            └──────┬───────┘           │            │
       │                   │                   │            │
       ▼                   ▼                   │            │
┌───────────────────────────────┐            │            │
│     ReservationTables         │            │            │
├───────────────────────────────┤            │            │
│ ReservationID (PK, FK)        │            │            │
│ TableID (PK, FK)              │            │            │
└──────┬────────────────────────┘            │            │
       │                                     │            │
       │            ┌────────────────────────┘            │
       │            │                                         │
       ▼            ▼                                         ▼
┌──────────────────────────────┐     ┌─────────────────────────┐
│          Tables              │     │      OrderTables        │
├──────────────────────────────┤     ├─────────────────────────┤
│ TableID (PK)                 │     │ OrderID (PK, FK)        │
│ TableNumber                  │     │ TableID (PK, FK)        │
│ Capacity                     │     └─────────────────────────┘
│ Location                     │
└──────────────────────────────┘
```

### 2.3 Công thức chuyển ERD sang TABLE

**BẮT BUỘC NHỚ:**

```
1. Entity → Table
2. Attribute → Column
3. Primary Key (PK) → PRIMARY KEY
4. Foreign Key (FK) → FOREIGN KEY REFERENCES
5. Multi-valued attribute → Table riêng (tên bảng + tên thuộc tính)
6. Composite attribute → Tách thành các column riêng
7. Relationship M:N → Bridging table (Composite PK)
```

---

## 🎯 PHẦN 3: TỪNG CÂU HỎI - PHÂN TÍCH & GIẢI

---

## 📌 QUESTION 1: CREATE TABLE [2 điểm]

### ⚠️ QUAN TRỌNG - SUBMISSION RULES CHO Q1

```
❌ KHÔNG nộp: CREATE DATABASE, USE, GO, EXEC
✅ CHỈ nộp:  CREATE TABLE statements

Khi làm bài:
  → Tạo file Q1_temp.sql có đầy đủ CREATE DATABASE, USE, GO để test
  → Sau khi test OK, copy chỉ CREATE TABLE vào Q1.sql để nộp
```

### 📖 Đọc đề
> "Create one database and then write SQL statements to create, in this database, all tables derived from the ERD..."

### 🧠 Tư duy

```
Yêu cầu: Chuyển ERD → SQL CREATE TABLE
Lưu ý:   Đây là BT chuyển từ ERD sang SQL (KHÔNG cần chạy được)
Input:   ERD Picture 1.1
Output:  SQL CREATE TABLE statements (KHÔNG có CREATE DATABASE, USE, GO)
```

### 🔍 Phân tích

1. **Từ Conceptual ERD (Picture 1.1):**
   - Restaurants, Employees, Shifts
   - Multi-valued: Phone → EmployeePhone
   - Composite: address → street, city

2. **Từ Physical Schema:**
   - 9 bảng chính (Tables, Customers, Employees, MenuItems, Reservations, ReservationTables, Orders, OrderTables, OrderDetails)

3. **Thứ tự tạo:**
   - Strong Entity trước (Tables, Customers, Employees, MenuItems)
   - Weak Entity sau (Reservations, Orders)
   - Bridging table cuối cùng (ReservationTables, OrderTables, OrderDetails)

### ✅ Code

```sql
-- Bước 1: Tạo bảng MẠNH (không có FK)

CREATE TABLE Tables (
    TableID INT PRIMARY KEY,
    TableNumber INT,
    Capacity INT,
    Location NVARCHAR(50)
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FullName NVARCHAR(50),
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    CreatedDate DATE
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FullName NVARCHAR(50),
    Role NVARCHAR(50),
    HireDate DATE,
    Salary DECIMAL(18,2)
);

CREATE TABLE MenuItems (
    ItemID INT PRIMARY KEY,
    ItemName NVARCHAR(100),
    Category NVARCHAR(50),
    Price MONEY,
    IsAvailable BIT
);

-- Bước 2: Tạo bảng YẾU (có FK)

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
    PaymentMethod NVARCHAR(20),
    TotalAmount MONEY,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ReservationID) REFERENCES Reservations(ReservationID)
);

-- Bước 3: Tạo Bridging Tables

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
    Price MONEY,
    PRIMARY KEY (OrderID, ItemID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ItemID) REFERENCES MenuItems(ItemID)
);

-- Multi-valued attribute từ Conceptual ERD
CREATE TABLE EmployeePhone (
    EmployeeID INT,
    Phone NVARCHAR(20),
    PRIMARY KEY (EmployeeID, Phone),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);
```

### ✅ Code (Q1.sql - NỘP file này)

```sql
-- ==========================================
-- Q1.sql - File NỘP (Chỉ có CREATE TABLE)
-- ==========================================

-- Bước 1: Tạo bảng MẠNH (không có FK)
CREATE TABLE Tables (
    TableID INT PRIMARY KEY,
    TableNumber INT,
    Capacity INT,
    Location NVARCHAR(50)
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FullName NVARCHAR(50),
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    CreatedDate DATE
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FullName NVARCHAR(50),
    Role NVARCHAR(50),
    HireDate DATE,
    Salary DECIMAL(18,2)
);

CREATE TABLE MenuItems (
    ItemID INT PRIMARY KEY,
    ItemName NVARCHAR(100),
    Category NVARCHAR(50),
    Price MONEY,
    IsAvailable BIT
);

-- Bước 2: Tạo bảng YẾU (có FK)
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
    PaymentMethod NVARCHAR(20),
    TotalAmount MONEY,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ReservationID) REFERENCES Reservations(ReservationID)
);

-- Bước 3: Tạo Bridging Tables
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
    Price MONEY,
    PRIMARY KEY (OrderID, ItemID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ItemID) REFERENCES MenuItems(ItemID)
);

-- Multi-valued attribute từ Conceptual ERD
CREATE TABLE EmployeePhone (
    EmployeeID INT,
    Phone NVARCHAR(20),
    PRIMARY KEY (EmployeeID, Phone),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);
```

### 💡 Tips
- **Q1.sql**: KHÔNG có CREATE DATABASE, USE, GO - Chỉ CREATE TABLE
- **Q1_temp.sql**: CÓ đầy đủ CREATE DATABASE, USE, GO - Dùng để test
- Data type phải GIỐNG HỆT với ERD
- Composite PK: `PRIMARY KEY (col1, col2)`
- Thứ tự tạo: Strong Entity → Weak Entity → Bridging Tables

---

## 📌 QUESTION 2: SELECT WHERE + OR [1 điểm]

### 📖 Đọc đề
> "Display all employees who are chefs or managers and were hired in 2021"

### 🧠 Tư duy

```
Yêu cầu: Lấy nhân viên là Chef HOẶC Manager, tuyển năm 2021
Input:   Bảng Employees
Output:  EmployeeID, FullName, Role, HireDate, Salary
ĐK lọc:  (Role = 'Chef' OR Role = 'Manager') AND YEAR(HireDate) = 2021
```

### 🔍 Phân tích

| Cần lấy | Từ bảng nào | Điều kiện |
|---------|-------------|-----------|
| Tất cả columns | Employees | Role IN ('Chef', 'Manager') AND YEAR(HireDate) = 2021 |

### ✅ Code

```sql
SELECT EmployeeID, FullName, Role, HireDate, Salary
FROM Employees
WHERE (Role = 'Chef' OR Role = 'Manager')
  AND YEAR(HireDate) = 2021;
```

Hoặc ngắn gọn hơn:

```sql
SELECT EmployeeID, FullName, Role, HireDate, Salary
FROM Employees
WHERE Role IN ('Chef', 'Manager')
  AND YEAR(HireDate) = 2021;
```

### 💡 Formula

```sql
SELECT [cột_cần_lấy]
FROM [bảng]
WHERE [điều_kiện_1] OR [điều_kiện_2]
  AND [điều_kiện_3];
```

**⚠️ Lưu ý:** Dùng ngoặc `()` khi kết hợp OR và AND để tránh sai logic!

---

## 📌 QUESTION 3: JOIN + DISTINCT [1 điểm]

### 📖 Đọc đề
> "List all menu items ordered by customer 'Nguyễn Hoài Phương', displaying CustomerID, FullName, ItemID, ItemName. Ensure duplicate records are not repeated"

### 🧠 Tư duy

```
Yêu cầu: Lấy món ăn mà 1 khách hàng đã đặt, loại bỏ trùng
Input:   Customers, Orders, OrderDetails, MenuItems
Output:  CustomerID, FullName, ItemID, ItemName
ĐK lọc:  FullName = 'Nguyễn Hoài Phương'
Đặc biệt: Duplicate records không được lặp lại → DISTINCT
```

### 🔍 Phân tích

| Bước | Xác định |
|------|----------|
| 1. Bảng tham gia | Customers, Orders, OrderDetails, MenuItems |
| 2. Join | CustomerID, OrderID, ItemID |
| 3. Filter | FullName = 'Nguyễn Hoài Phương' |
| 4. Loại trùng | DISTINCT hoặc DISTINCT trong JOIN |

### ✅ Code

```sql
SELECT DISTINCT
    c.CustomerID,
    c.FullName,
    mi.ItemID,
    mi.ItemName
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN MenuItems mi ON od.ItemID = mi.ItemID
WHERE c.FullName = N'Nguyễn Hoài Phương';
```

### 💡 Tại sao cần DISTINCT?

```
Nếu 1 món được đặt nhiều lần → sẽ xuất hiện nhiều lần
DISTINCT loại bỏ các hàng trùng lặp
```

### 💡 Formula

```sql
SELECT DISTINCT [cột]
FROM [bảng1]
JOIN [bảng2] ON [đk]
JOIN [bảng3] ON [đk]
WHERE [điều_kiện];
```

---

## 📌 QUESTION 4: LEFT JOIN + DATE FILTER [1 điểm]

### 📖 Đọc đề
> "Display all main dishes (Category = 'Món chính'), along with customers who ordered them in August 2025. Include menu items even if not ordered by any customer. Sort by ItemName ASC, then CustomerID ASC"

### 🧠 Tư duy

```
Yêu cầu: Hiển thị món chính + khách đặt (tháng 8/2025)
         BAO GỒM cả món không ai đặt → LEFT JOIN
Input:   MenuItems, Orders, OrderDetails, Customers
Output:  Category, ItemID, ItemName, CustomerID, FullName
ĐK lọc:  Category = 'Món chính' AND Month = 8 AND Year = 2025
```

### 🔍 Phân tích

| Keyword | Action |
|---------|--------|
| "even if not ordered" | LEFT JOIN (bên trái giữ nguyên) |
| "August 2025" | MONTH() = 8 AND YEAR() = 2025 |
| "Sort by ItemName ASC, then CustomerID ASC" | ORDER BY ItemName, CustomerID |

### ✅ Code

```sql
SELECT
    mi.Category,
    mi.ItemID,
    mi.ItemName,
    c.CustomerID,
    c.FullName
FROM MenuItems mi
LEFT JOIN OrderDetails od ON mi.ItemID = od.ItemID
LEFT JOIN Orders o ON od.OrderID = o.OrderID
LEFT JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE mi.Category = N'Món chính'
  AND (MONTH(o.PaymentTime) = 8 AND YEAR(o.PaymentTime) = 2025 OR o.PaymentTime IS NULL)
ORDER BY mi.ItemName ASC, c.CustomerID ASC;
```

Hoặc cách khác:

```sql
SELECT
    mi.Category,
    mi.ItemID,
    mi.ItemName,
    c.CustomerID,
    c.FullName
FROM MenuItems mi
LEFT JOIN (
    SELECT od.ItemID, c.CustomerID, c.FullName
    FROM OrderDetails od
    JOIN Orders o ON od.OrderID = o.OrderID
    JOIN Customers c ON o.CustomerID = c.CustomerID
    WHERE MONTH(o.PaymentTime) = 8 AND YEAR(o.PaymentTime) = 2025
) ordered_items ON mi.ItemID = ordered_items.ItemID
WHERE mi.Category = N'Món chính'
ORDER BY mi.ItemName ASC, ordered_items.CustomerID ASC;
```

### 💡 Phân biệt INNER JOIN vs LEFT JOIN

| INNER JOIN | LEFT JOIN |
|------------|-----------|
| Chỉ rows khớp ở cả 2 bảng | TẤT CẢ rows bảng trái + rows khớp |

```
INNER JOIN: Món có khách đặt mới hiện
LEFT JOIN:  TẤT CẢ món đều hiện (kể cả không ai đặt)
```

---

## 📌 QUESTION 5: LEFT JOIN + AGGREGATION + LIKE [1 điểm]

### 📖 Đọc đề
> "List all customers whose full name starts with 'Nguyễn' or 'Bùi', showing CustomerID, FullName, NumberOfOrders (in 2025), TotalAmount. If no completed order in 2025, still display with 0 and 0.00"

### 🧠 Tư duy

```
Yêu cầu: Khách hàng tên bắt đầu 'Nguyễn' hoặc 'Bùi'
         + Đếm đơn hoàn thành năm 2025
         + Tổng tiền đã tiêu
         + KHÔNG có đơn vẫn phải hiện → LEFT JOIN
Input:   Customers, Orders
Output:  CustomerID, FullName, NumberOfOrders, TotalAmount
```

### 🔍 Phân tích

| Keyword | Action |
|---------|--------|
| "starts with" | LIKE 'Nguyễn%' OR LIKE 'Bùi%' |
| "no completed order... still display" | LEFT JOIN |
| "NumberOfOrders" | COUNT(OrderID) |
| "TotalAmount" | SUM(TotalAmount) |
| "in 2025" | YEAR() = 2025 |
| "if no order... show 0" | ISNULL() hoặc COALESCE() |

### ✅ Code

```sql
SELECT
    c.CustomerID,
    c.FullName,
    ISNULL(COUNT(o.OrderID), 0) AS NumberOfOrders,
    ISNULL(SUM(o.TotalAmount), 0) AS TotalAmount
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
    AND o.Status = 'Completed'
    AND YEAR(o.PaymentTime) = 2025
WHERE c.FullName LIKE N'Nguyễn%' OR c.FullName LIKE N'Bùi%'
GROUP BY c.CustomerID, c.FullName
ORDER BY c.CustomerID;
```

### 💡 Formula cho LEFT JOIN + Aggregate

```sql
SELECT
    [cột_bảng_trái],
    ISNULL(COUNT([bảng_phải].[id]), 0) AS [số_lượng],
    ISNULL(SUM([bảng_phải].[số]), 0) AS [tổng]
FROM [bảng_trái] c
LEFT JOIN [bảng_phải] o ON c.id = o.id
    AND [điều_kiện_lọc_bảng_phải]
WHERE [điều_kiện_lọc_bảng_trái]
GROUP BY [cột_bảng_trái];
```

### ⚠️ Quan trọng: WHERE vs ON trong LEFT JOIN

```sql
-- ❌ SAI: Điều kiện lọc bảng phải đặt trong WHERE
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE YEAR(o.PaymentTime) = 2025  -- Sẽ biến LEFT JOIN thành INNER JOIN!

-- ✅ ĐÚNG: Điều kiện lọc bảng phải đặt trong ON
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
    AND YEAR(o.PaymentTime) = 2025  -- Giữ nguyên LEFT JOIN
```

---

## 📌 QUESTION 6: AGGREGATE + SUBQUERY (Below Average) [1 điểm]

### 📖 Đọc đề
> "List all menu items whose total sales amount in 2023 is BELOW THE AVERAGE total sales amount of ALL menu items in 2023 (including those with no sales). Display ItemID, ItemName, Category, TotalAmount. Sort by TotalAmount ASC, then ItemID ASC"

### 🧠 Tư duy

```
Yêu cầu: Tìm món có doanh thu THẤP HƠN TRUNG BÌNH
         Trung bình tính trên TẤT CẢ món (kể cả món bán 0)
Input:   MenuItems, Orders, OrderDetails
Output:  ItemID, ItemName, Category, TotalAmount
```

### 🔍 Phân tích

| Bước | Xác định |
|------|----------|
| 1. Tính doanh thu từng món | LEFT JOIN + SUM(Quantity * Price) |
| 2. Tính trung bình TẤT CẢ | AVG() trên kết quả bước 1 |
| 3. Lọc món < TB | WHERE TotalAmount < (SELECT AVG(...)) |

### ✅ Code

```sql
WITH ItemSales AS (
    SELECT
        mi.ItemID,
        mi.ItemName,
        mi.Category,
        ISNULL(SUM(od.Quantity * od.Price), 0) AS TotalAmount
    FROM MenuItems mi
    LEFT JOIN OrderDetails od ON mi.ItemID = od.ItemID
    LEFT JOIN Orders o ON od.OrderID = o.OrderID
        AND YEAR(o.PaymentTime) = 2023
        AND o.Status = 'Completed'
    GROUP BY mi.ItemID, mi.ItemName, mi.Category
)
SELECT ItemID, ItemName, Category, TotalAmount
FROM ItemSales
WHERE TotalAmount < (SELECT AVG(TotalAmount) FROM ItemSales)
ORDER BY TotalAmount ASC, ItemID ASC;
```

Hoặc không dùng CTE:

```sql
SELECT
    mi.ItemID,
    mi.ItemName,
    mi.Category,
    ISNULL(SUM(od.Quantity * od.Price), 0) AS TotalAmount
FROM MenuItems mi
LEFT JOIN OrderDetails od ON mi.ItemID = od.ItemID
LEFT JOIN Orders o ON od.OrderID = o.OrderID
    AND YEAR(o.PaymentTime) = 2023
    AND o.Status = 'Completed'
GROUP BY mi.ItemID, mi.ItemName, mi.Category
HAVING ISNULL(SUM(od.Quantity * od.Price), 0) <
    (SELECT AVG(ISNULL(SUM(od2.Quantity * od2.Price), 0))
     FROM MenuItems mi2
     LEFT JOIN OrderDetails od2 ON mi2.ItemID = od2.ItemID
     LEFT JOIN Orders o2 ON od2.OrderID = o2.OrderID
        AND YEAR(o2.PaymentTime) = 2023
        AND o2.Status = 'Completed'
     GROUP BY mi2.ItemID)
ORDER BY TotalAmount ASC, mi.ItemID ASC;
```

### 💡 Formula cho "Below/Above Average"

```sql
WITH [tạm] AS (
    SELECT [cột], [hàm_aggregate] AS [giá_trị]
    FROM [bảng]
    GROUP BY [cột]
)
SELECT *
FROM [tạm]
WHERE [giá_trị] < (SELECT AVG([giá_trị]) FROM [tạm]);
```

---

## 📌 QUESTION 7: MULTI-YEAR AGGREGATION + PERCENTAGE [1 điểm]

### 📖 Đọc đề
> "Analyze customer spending trends between 2023 and 2024. For customers who placed orders in BOTH years, calculate: CustomerID, FullName, AvgTotalOrderValue2023, AvgTotalOrderValue2024, PercentageChange"

### 🧠 Tư duy

```
Yêu cầu: So sánh chi tiêu TB 2023 vs 2024
         Chỉ khách CÓ đơn ở CẢ 2 năm
         Tính % tăng trưởng: (2024 - 2023) / 2023 * 100
Input:   Customers, Orders
Output:  5 columns như đề bài
```

### 🔍 Phân tích

| Bước | Xác định |
|------|----------|
| 1. Lọc đơn 2023 | YEAR(PaymentTime) = 2023 AND Status = 'Completed' |
| 2. Lọc đơn 2024 | YEAR(PaymentTime) = 2024 AND Status = 'Completed' |
| 3. Tính TB mỗi năm | AVG(TotalAmount) GROUP BY CustomerID |
| 4. Join 2 năm | INNER JOIN (chỉ lấy khách có cả 2 năm) |
| 5. Tính % | ((TB2024 - TB2023) / TB2023) * 100 |

### ✅ Code

```sql
WITH Sales2023 AS (
    SELECT
        c.CustomerID,
        c.FullName,
        AVG(o.TotalAmount) AS AvgTotalOrderValue2023
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    WHERE YEAR(o.PaymentTime) = 2023 AND o.Status = 'Completed'
    GROUP BY c.CustomerID, c.FullName
),
Sales2024 AS (
    SELECT
        c.CustomerID,
        AVG(o.TotalAmount) AS AvgTotalOrderValue2024
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    WHERE YEAR(o.PaymentTime) = 2024 AND o.Status = 'Completed'
    GROUP BY c.CustomerID
)
SELECT
    s23.CustomerID,
    s23.FullName,
    ROUND(s23.AvgTotalOrderValue2023, 2) AS AvgTotalOrderValue2023,
    ROUND(s24.AvgTotalOrderValue2024, 2) AS AvgTotalOrderValue2024,
    CAST(ROUND(((s24.AvgTotalOrderValue2024 - s23.AvgTotalOrderValue2023) /
                s23.AvgTotalOrderValue2023 * 100), 2) AS NVARCHAR(20)) + ' %' AS PercentageChange
FROM Sales2023 s23
INNER JOIN Sales2024 s24 ON s23.CustomerID = s24.CustomerID
ORDER BY s23.CustomerID;
```

### 💡 Formula tính Percentage Change

```sql
ROUND((([giá_trị_mới] - [giá_trị_cũ]) / [giá_trị_cũ] * 100), 2)
```

### 💡 Cắt chuỗi + thêm '%'

```sql
CAST([số] AS NVARCHAR(20)) + ' %'
-- Hoặc
CONVERT(NVARCHAR(20), [số]) + ' %'
```

---

## 📌 QUESTION 8: STORED PROCEDURE (Monthly Report) [0.5 điểm]

### 📖 Đọc đề
> "Create stored procedure MonthlySalesSummary with input @year int. Display ALL 12 months even if no orders. For each month: Month (format 'M/YYYY'), NumberOfOrders, TotalRevenue"

### 🧠 Tư duy

```
Yêu cầu: Procedure tạo báo cáo tháng
         Phải hiện ĐỦ 12 tháng (1-12)
         Input: @year (int)
Output:  Month, NumberOfOrders, TotalRevenue
```

### 🔍 Phân tích

| Thành phần | Giá trị |
|------------|---------|
| Tên procedure | MonthlySalesSummary |
| Input param | @year INT |
| Output | ResultSet (3 columns) |
| Key technique | LEFT JOIN với bảng chứa 12 tháng |

### ✅ Code

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

Hoặc dùng cách khác (tạo bảng tạm):

```sql
CREATE PROCEDURE MonthlySalesSummary
    @year INT
AS
BEGIN
    WITH AllMonths AS (
        SELECT 1 AS Month
        UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
        UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7
        UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10
        UNION ALL SELECT 11 UNION ALL SELECT 12
    ),
    MonthlyData AS (
        SELECT
            MONTH(o.PaymentTime) AS MonthNum,
            COUNT(DISTINCT o.OrderID) AS OrderCount,
            SUM(od.Quantity * od.Price) AS Revenue
        FROM Orders o
        JOIN OrderDetails od ON o.OrderID = od.OrderID
        WHERE YEAR(o.PaymentTime) = @year
            AND o.Status = 'Completed'
        GROUP BY MONTH(o.PaymentTime)
    )
    SELECT
        CAST(am.Month AS NVARCHAR(10)) + '/' + CAST(@year AS NVARCHAR(10)) AS [Month],
        ISNULL(md.OrderCount, 0) AS NumberOfOrders,
        ISNULL(md.Revenue, 0) AS TotalRevenue
    FROM AllMonths am
    LEFT JOIN MonthlyData md ON am.Month = md.MonthNum
    ORDER BY am.Month;
END;
```

### 💡 Cấu trúc PROCEDURE

```sql
CREATE PROCEDURE [tên_procedure]
    [@param1] [data_type]        -- Input parameter
    -- [@param2] [type] OUTPUT   -- Output parameter (nếu có)
AS
BEGIN
    -- Logic xử lý
    -- Có thể dùng CTE, temp table, biến...
END;
```

### 🔍 Cách test

```sql
-- Gọi procedure
EXEC MonthlySalesSummary 2023;
```

---

## 📌 QUESTION 9: TRIGGER (Update TotalAmount) [0.5 điểm]

### 📖 Đọc đề
> "Create trigger trg_UpdateTotalAmount on OrderDetails to ensure TotalAmount in Orders always stays accurate. When OrderDetails is inserted/updated/deleted, automatically recalculate total as sum of (Quantity * Price). If all details deleted, set to 0"

### 🧠 Tư duy

```
Yêu cầu: Trigger tự động cập nhật TotalAmount trong Orders
         Khi OrderDetails THAY ĐỔI (INSERT/UPDATE/DELETE)
         → Tính lại SUM(Quantity * Price)
         Nếu không còn detail nào → TotalAmount = 0
```

### 🔍 Phân tích

| Thành phần | Giá trị |
|------------|---------|
| Tên trigger | trg_UpdateTotalAmount |
| Bảng | OrderDetails |
| Event | INSERT, UPDATE, DELETE |
| Timing | AFTER |
| Logic | Update Orders.TotalAmount = SUM(Quantity * Price) |

### ✅ Code

```sql
CREATE TRIGGER trg_UpdateTotalAmount
ON OrderDetails
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Cập nhật cho các order bị ảnh hưởng bởi INSERT/UPDATE
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

Hoặc chi tiết hơn:

```sql
CREATE TRIGGER trg_UpdateTotalAmount
ON OrderDetails
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @OrderID INT;

    -- Lấy OrderID từ inserted (INSERT/UPDATE)
    DECLARE cursor_inserted CURSOR FOR
    SELECT DISTINCT OrderID FROM inserted
    WHERE OrderID IS NOT NULL;

    OPEN cursor_inserted;
    FETCH NEXT FROM cursor_inserted INTO @OrderID;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        UPDATE Orders
        SET TotalAmount = ISNULL((
            SELECT SUM(Quantity * Price)
            FROM OrderDetails
            WHERE OrderID = @OrderID
        ), 0)
        WHERE OrderID = @OrderID;

        FETCH NEXT FROM cursor_inserted INTO @OrderID;
    END;
    CLOSE cursor_inserted;
    DEALLOCATE cursor_inserted;

    -- Lấy OrderID từ deleted (DELETE)
    DECLARE cursor_deleted CURSOR FOR
    SELECT DISTINCT OrderID FROM deleted
    WHERE OrderID IS NOT NULL;

    OPEN cursor_deleted;
    FETCH NEXT FROM cursor_deleted INTO @OrderID;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        UPDATE Orders
        SET TotalAmount = ISNULL((
            SELECT SUM(Quantity * Price)
            FROM OrderDetails
            WHERE OrderID = @OrderID
        ), 0)
        WHERE OrderID = @OrderID;

        FETCH NEXT FROM cursor_deleted INTO @OrderID;
    END;
    CLOSE cursor_deleted;
    DEALLOCATE cursor_deleted;
END;
```

### 💡 Bảng ảo trong Trigger

| Bảng ảo | Mô tả | Event |
|----------|-------|-------|
| `inserted` | Chứa rows ĐÃ THÊM/CẬP NHẬT | INSERT, UPDATE |
| `deleted` | Chứa rows ĐÃ XÓA/CŨ | DELETE, UPDATE |

```
INSERT → inserted có dữ liệu mới, deleted rỗng
DELETE → deleted có dữ liệu cũ, inserted rỗng
UPDATE → deleted có dữ liệu cũ, inserted có dữ liệu mới
```

### 💡 Formula Trigger cập nhật aggregate

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

## 📌 QUESTION 10: INSERT WITH SUBQUERY [0.5 điểm]

### 📖 Đọc đề
> "Create a new reservation for CustomerID = 7, 5 guests, on Nov 20, 2025 at 19:15. ReservationID = 210. Then assign to the smallest table with capacity >= 5"

### 🧠 Tư duy

```
Yêu cầu: Insert reservation
         → Insert vào Reservations
         → Insert vào ReservationTables với bàn nhỏ nhất (>= 5 khách)
```

### 🔍 Phân tích

| Bước | Action |
|------|--------|
| 1. Insert reservation | INSERT INTO Reservations |
| 2. Tìm bàn phù hợp | MIN(TableID) WHERE Capacity >= 5 |
| 3. Insert vào ReservationTables | INSERT với subquery |

### ✅ Code

```sql
-- Bước 1: Insert reservation
INSERT INTO Reservations (ReservationID, CustomerID, ReservationTime, GuestCount, Status, Notes)
VALUES (210, 7, '2025-11-20 19:15', 5, 'Pending', NULL);

-- Bước 2: Insert vào ReservationTables với bàn nhỏ nhất >= 5
INSERT INTO ReservationTables (ReservationID, TableID)
SELECT 210, MIN(TableID)
FROM Tables
WHERE Capacity >= 5;
```

Hoặc viết trong 1 block (nếu được phép):

```sql
-- Cách 1: Tách 2 câu
INSERT INTO Reservations (ReservationID, CustomerID, ReservationTime, GuestCount, Status)
VALUES (210, 7, '2025-11-20 19:15', 5, 'Pending');

INSERT INTO ReservationTables (ReservationID, TableID)
VALUES (210, (SELECT MIN(TableID) FROM Tables WHERE Capacity >= 5));
```

### 💡 INSERT với subquery

```sql
INSERT INTO [bảng] ([col1], [col2])
VALUES ([giá_trị_1], (SELECT [giá_trị] FROM [bảng_khác] WHERE [đk]));
```

---

## 🎯 PHẦN 4: TỔNG HỢP SYNTAX

### 4.1 SELECT Statement

```sql
-- Cơ bản
SELECT column1, column2 FROM table WHERE condition;

-- Với JOIN
SELECT t1.col1, t2.col2
FROM table1 t1
JOIN table2 t2 ON t1.id = t2.id
WHERE condition;

-- Với LEFT JOIN (bao gồm NULL)
SELECT t1.col1, t2.col2
FROM table1 t1
LEFT JOIN table2 t2 ON t1.id = t2.id
WHERE condition;

-- Với GROUP BY
SELECT col, COUNT(*) AS total, SUM(amount) AS total_amt
FROM table
GROUP BY col
HAVING COUNT(*) > 5;

-- Với TOP
SELECT TOP 1 col, MAX(val) as max_val
FROM table
ORDER BY max_val DESC;
```

### 4.2 JOIN Types

```sql
-- INNER JOIN: Chỉ rows khớp cả 2 bảng
SELECT * FROM A JOIN B ON A.id = B.id;

-- LEFT JOIN: Tất cả rows A + rows khớp B
SELECT * FROM A LEFT JOIN B ON A.id = B.id;

-- RIGHT JOIN: Tất cả rows B + rows khớp A
SELECT * FROM A RIGHT JOIN B ON A.id = B.id;

-- FULL JOIN: Tất cả rows cả 2 bảng
SELECT * FROM A FULL JOIN B ON A.id = B.id;
```

### 4.3 Date Functions

```sql
-- Lấy năm, tháng, ngày
YEAR(date_column)
MONTH(date_column)
DAY(date_column)

-- Filter date
WHERE date_column BETWEEN '2025-01-01' AND '2025-12-31'
WHERE YEAR(date_column) = 2025
WHERE MONTH(date_column) = 8

-- Format date
CAST(MONTH(date) AS NVARCHAR) + '/' + CAST(YEAR(date) AS NVARCHAR)
```

### 4.4 Aggregate Functions

```sql
COUNT(*)          -- Đếm tất cả rows
COUNT(column)     -- Đếm rows không NULL
COUNT(DISTINCT col)  -- Đếm giá trị khác nhau
SUM(column)       -- Tổng
AVG(column)       -- Trung bình
MAX(column)       -- Giá trị lớn nhất
MIN(column)       -- Giá trị nhỏ nhất

-- Với NULL
ISNULL(SUM(col), 0)     -- SQL Server
COALESCE(SUM(col), 0)   -- Standard
```

### 4.5 String Functions

```sql
LIKE 'pattern'          -- So sánh mẫu
LIKE 'Nguyễn%'          -- Bắt đầu bằng 'Nguyễn'
LIKE '%name'            -- Kết thúc bằng 'name'
LIKE '%key%'            -- Chứa 'key'

CONCAT(str1, str2)      -- Nối chuỗi
str1 + str2             -- Nối chuỗi (SQL Server)
CAST(num AS NVARCHAR)   -- Chuyển số thành chuỗi
```

### 4.6 DML Statements

```sql
-- INSERT
INSERT INTO table(col1, col2) VALUES (val1, val2);
INSERT INTO table(col1, col2) SELECT col1, col2 FROM table2;

-- UPDATE
UPDATE table SET col1 = val1 WHERE condition;

-- DELETE
DELETE FROM table WHERE condition;
```

### 4.7 Stored Procedure

```sql
CREATE PROCEDURE proc_name
    @input param_type,
    @output param_type OUTPUT
AS
BEGIN
    -- SQL statements
    -- Có thể dùng CTE, temp table
END;
```

### 4.8 Trigger

```sql
CREATE TRIGGER trigger_name
ON table_name
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    -- SQL statements
    -- Dùng inserted, deleted tables
END;
```

### 4.9 CTE (Common Table Expression)

```sql
WITH CTE_Name AS (
    SELECT col1, col2, SUM(amount) AS total
    FROM table
    GROUP BY col1, col2
)
SELECT * FROM CTE_Name WHERE total > 1000;
```

---

## 🎯 PHẦN 5: CHECKLIST TRƯỚC KHI NỘP

```
☐ Folder tên đúng: RollNo_Name_DBI202_05
☐ Không có subfolder
☐ File naming: Q1.sql, Q2.sql, ..., Q10.sql
☐ Q1.sql: CHỈ có CREATE TABLE (KHÔNG có CREATE DATABASE, USE, GO)
☐ Q2-Q10: KHÔNG có USE, GO, EXEC
☐ Chỉ chứa câu trả lời (không có test code)
☐ Data type đúng với ERD
☐ PK, FK đúng
☐ Output column đúng với đề bài
☐ DISTINCT khi cần thiết
☐ LEFT JOIN khi "include ... even if not..."
☐ ISNULL/COALESCE cho giá trị NULL
☐ ROUND cho số thập phân
☐ ORDER BY đúng thứ tự
```

---

## 🎯 PHẦN 6: CÁCH LÀM BÀI THỰC CHIẾN

```
┌─────────────────────────────────────────────────────┐
│  BƯỚC 1: Tạo folder theo quy định                    │
│  → se01245_LongNT_DBI202_05                          │
├─────────────────────────────────────────────────────┤
│  BƯỚC 2: Tạo 10 file rỗng                           │
│  → Q1.sql, Q2.sql, ..., Q10.sql                      │
├─────────────────────────────────────────────────────┤
│  BƯỚC 3: Làm từng câu một                            │
│  → Đọc → Phân tích → Viết code → Test                │
├─────────────────────────────────────────────────────┤
│  BƯỚC 4: Review lại từng câu                         │
│  → So sánh output với đề bài                         │
├─────────────────────────────────────────────────────┤
│  BƯỚC 5: Clean test code                             │
│  → Chỉ giữ lại câu lệnh trả lời                      │
├─────────────────────────────────────────────────────┤
│  BƯỚC 6: Nộp bài                                     │
└─────────────────────────────────────────────────────┘
```

---

## 🎯 PHẦN 7: MẸO NHỚ CÚ PHÁP

### Phương pháp "Keyword Mapping"

```
Đề bài nói                    → SQL keyword
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"display, show, list"         → SELECT
"which is/where"               → WHERE
"and, or"                      → AND, OR (dùng ngoặc!)
"starts with"                 → LIKE 'xyz%'
"distinct, not repeated"      → DISTINCT
"even if not ordered"          → LEFT JOIN
"average, below average"       → AVG() + subquery
"count, number of"            → COUNT()
"total, sum"                  → SUM()
"create procedure"             → CREATE PROCEDURE
"trigger"                      → CREATE TRIGGER
"insert, create new"           → INSERT
```

### Phương pháp "Table Mapping"

```
Đề bài nói              → Bảng cần dùng
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"customer"              → Customers
"employee"              → Employees
"menu item"             → MenuItems
"order"                 → Orders
"order detail"          → OrderDetails
"reservation"           → Reservations
"table"                 → Tables
```

---

## 🎯 PHẦN 8: FAQ - CÂU HỎI THƯỜNG GẶP

### Q1: Khi nào dùng INNER JOIN, LEFT JOIN?

```
INNER JOIN: Chỉ lấy rows khớp ở cả 2 bảng
LEFT JOIN:  Lấy TẤT CẢ rows bảng trái + rows khớp bảng phải

→ Dùng LEFT JOIN khi đề nói "include ... even if not..."
```

### Q2: Tại sao phải GROUP BY nhiều cột?

```
Vì SELECT có nhiều cột non-aggregate
→ Phải GROUP BY tất cả các cột đó
```

### Q3: ISNULL khác với COALESCE như thế nào?

```
ISNULL(col, 0)        -- SQL Server specific
COALESCE(col, 0)      -- SQL standard

→ Cả 2 đều thay NULL bằng giá trị mặc định
```

### Q4: Tại sao cần DISTINCT trong JOIN?

```
Khi 1 quan hệ M:N tạo ra rows trùng lặp
→ DISTINCT loại bỏ các hàng giống hệt nhau
```

### Q5: Cách tính percentage change?

```sql
((new_value - old_value) / old_value) * 100

→ ROUND để lấy 2 chữ số thập phân
→ CAST thành string + ' %' để hiển thị
```

### Q6: Trigger khác Procedure như thế nào?

```
Procedure:  Gọi thủ công (EXEC)
Trigger:    Tự chạy khi có sự kiện (INSERT/UPDATE/DELETE)

→ Trigger dùng để tự động hóa logic
```

### Q7: Cách tạo 12 tháng cho báo cáo?

```
Dùng UNION ALL để tạo list 1-12:
WITH Months AS (
    SELECT 1 UNION ALL SELECT 2 ... UNION ALL SELECT 12
)

→ LEFT JOIN với data để bao gồm tháng không có data
```

---

## 🎯 PHẦN 9: TRICKS & TRAPS

### ⚠️ CÁC BẪY THƯỜNG GẬP

| Bẫy | VD | Cách tránh |
|-----|----|------------|
| Sai data type | `INT` thay vì `DECIMAL` | Xem kỹ ERD |
| Quên DISTINCT | Duplicate rows | `DISTINCT` hoặc DISTINCT col |
| WHERE thay HAVING | `WHERE COUNT(*) >= 3` | Dùng `HAVING` cho aggregate |
| Sai thứ tự JOIN | Bảng yếu trước bảng mạnh | Bảng mạnh trước |
| Sai điều kiện LEFT JOIN | `WHERE` thay vì `ON` | Đặt điều kiện trong `ON` |
| Quên ISNULL | NULL trong kết quả | `ISNULL(SUM(), 0)` |
| Quên N cho unicode | `FullName = 'Nguyễn'` | `N'Nguyễn'` |
| Quên ngoặc OR/AND | `WHERE A OR B AND C` | `WHERE (A OR B) AND C` |
| Quên ROUND | Số thập phân dài | `ROUND(value, 2)` |

### ✅ MẸO ĐẠT ĐIỂM CAO

1. **Đọc đề kỹ 2 lần** trước khi code
2. **Vẽ sơ đồ** relationships giữa bảng
3. **Test từng câu** trước khi chuyển câu khác
4. **Đặt alias** ngắn gọn: `c` cho Customer, `o` cho Order
5. **Format code** cho dễ đọc (indent, xuống dòng)
6. **So sánh output** với đề bài từng cột một
7. **Dùng CTE** cho query phức tạp (Q6, Q7)
8. **ISNULL** cho mọi aggregate khi có LEFT JOIN

---

## 🎯 PHẦN 10: EXERCISE - TỰ LUYỆN

### Bài tập 1: SELECT cơ bản
> "Lấy tất cả thông tin nhân viên là 'Chef'"

```sql
SELECT * FROM Employees WHERE Role = 'Chef';
```

### Bài tập 2: JOIN
> "Hiển thị tên món + số lượng đã đặt trong tháng 8/2025"

```sql
SELECT mi.ItemName, SUM(od.Quantity) AS TotalQty
FROM MenuItems mi
JOIN OrderDetails od ON mi.ItemID = od.ItemID
JOIN Orders o ON od.OrderID = o.OrderID
WHERE MONTH(o.PaymentTime) = 8 AND YEAR(o.PaymentTime) = 2025
GROUP BY mi.ItemName;
```

### Bài tập 3: LEFT JOIN
> "Hiển thị TẤT CẢ khách + số đơn họ đã đặt"

```sql
SELECT c.FullName, COUNT(o.OrderID) AS OrderCount
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.FullName;
```

---

## 📚 TÀI LIỆU THAM KHẢO

- Microsoft SQL Server Documentation
- W3Schools SQL Tutorial
- Entity-Relationship Diagram (ERD) Basics

---

**Chúc bạn thi tốt! 🎉**

Made with ❤️ for DBI202 students
