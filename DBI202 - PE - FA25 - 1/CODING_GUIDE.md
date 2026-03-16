# DBI202 - CODING GUIDE CHO NEWBIE
## Paper 1 - Bike Store Database - Tư duy & Hướng dẫn chi tiết từng bước

---

## 🚨 QUAN TRỌNG: Q1.SQL NỘP GÌ?

```
❌ KHÔNG nộp: CREATE DATABASE, USE, GO, EXEC
✅ CHỈ nộp:  CREATE TABLE statements

Q1.sql CHỈ chứa CREATE TABLE - không có gì khác!
```

### 📋 Mẫu Q1.sql (Paper 1 - Bike Store):

```sql
CREATE TABLE stores (
    store_id INT PRIMARY KEY,
    store_name NVARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    street NVARCHAR(100),
    city NVARCHAR(50),
    state VARCHAR(5),
    zip_code VARCHAR(10)
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name NVARCHAR(50),
    last_name NVARCHAR(50),
    phone VARCHAR(20),
    email VARCHAR(100),
    street NVARCHAR(100),
    city NVARCHAR(50),
    state VARCHAR(5),
    zip_code VARCHAR(10)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name NVARCHAR(150),
    model_year INT,
    list_price DECIMAL(12, 2),
    brand_name NVARCHAR(50),
    category_name NVARCHAR(50)
);

CREATE TABLE staffs (
    staff_id INT PRIMARY KEY,
    first_name NVARCHAR(50),
    last_name NVARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    active BIT,
    store_id INT,
    manager_id INT,
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    FOREIGN KEY (manager_id) REFERENCES staffs(staff_id)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_status INT,
    order_date DATE,
    required_date DATE,
    shipped_date DATE,
    customer_id INT,
    store_id INT,
    staff_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    FOREIGN KEY (staff_id) REFERENCES staffs(staff_id)
);

CREATE TABLE stocks (
    store_id INT,
    product_id INT,
    quantity INT,
    PRIMARY KEY (store_id, product_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE order_items (
    order_id INT,
    item_id INT,
    product_id INT,
    quantity INT,
    list_price DECIMAL(12, 2),
    discount DECIMAL(4, 2),
    PRIMARY KEY (order_id, item_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
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
│  2. Xem ERD Diagram                                      │
│     → Xác định các bảng: stores, staffs, customers,     │
│         orders, products, stocks, order_items            │
│                                                          │
│  3. Đọc kỹ phần SUBMISSION RULES                        │
│     → Folder: RollNo_Name_DBI202_01                     │
│     → Files: Q1.sql, Q2.sql, ..., Q10.sql               │
│     → KHÔNG dùng: CREATE DATABASE, USE, GO, EXEC        │
│                                                          │
│  4. Bắt đầu làm từng câu một                             │
└─────────────────────────────────────────────────────────┘
```

### Step 2: Phân tích đề - Từ vựng quan trọng

| Từ khóa | Nghĩa | SQL thường dùng |
|---------|------|-----------------|
| "create database and tables" | Tạo DB và bảng | CREATE DATABASE, CREATE TABLE |
| "living in New York" | Sống tại New York | WHERE city = 'New York' |
| "containing the word 'City'" | Chứa chuỗi 'City' | LIKE '%City%' |
| "between ... and ..." | Trong khoảng ngày | BETWEEN ... AND |
| "lowest list_price" | Giá thấp nhất | MIN() hoặc subquery |
| "total quantity" | Tổng số lượng | SUM(quantity) |
| "highest list_price within each category" | Giá cao nhất theo nhóm | MAX() + GROUP BY |
| "stored procedure" | Thủ tục lưu trữ | CREATE PROCEDURE |
| "output parameter" | Tham số đầu ra | @param OUTPUT |
| "delete rows" | Xóa dòng | DELETE |
| "belongs to category_name" | Thuộc danh mục | JOIN + WHERE |

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
│    stores    │
├──────────────┤
│ store_id (PK)│
│ store_name   │
│ ...          │
└──────┬───────┘
       │ 1
       │
       │ has (staffs)
       │
       │ N
┌──────▼───────┐         ┌──────────────┐
│   staffs     │         │  customers   │
├──────────────┤         ├──────────────┤
│ staff_id(PK) │         │customer_id(PK)│
│ first_name   │         │ first_name   │
│ last_name    │         │ last_name    │
│ store_id (FK)│         │ city         │
│ manager_id   │         │ state        │
└──────┬───────┘         └──────┬───────┘
       │ 1                      │ 1
       │                        │
       │ places                 │ places
       │                        │
       │ N                      │ N
┌──────▼───────┐         ┌──────▼───────┐
│   orders     │────────►│ order_items  │
├──────────────┤         ├──────────────┤
│ order_id (PK)│         │ order_id (PK)│
│ order_date   │         │ item_id (PK) │
│ customer_id  │         │ product_id   │
│ store_id     │         │ quantity     │
│ staff_id     │         └──────┬───────┘
└──────────────┘                │
                                │ N
                                │
┌──────────────┐                │
│   products   │◄───────────────┘
├──────────────┤       N
│ product_id(PK)│       │
│ product_name  │       │ has
│ list_price    │       │
│ category_name │       │
└──────┬───────┘       │
       │ 1             │
       │               │
       │ N             │
┌──────▼───────┐       │
│   stocks     │◄───────┘
├──────────────┤
│ store_id (PK)│  ← Composite PK
│ product_id(PK)│
│ quantity     │
└──────────────┘
```

### 2.3 Công thức chuyển ERD sang TABLE

**BẮT BUỘC NHỚ:**

```
1. Entity → Table
2. Attribute → Column
3. Primary Key (PK) → PRIMARY KEY
4. Foreign Key (FK) → FOREIGN KEY REFERENCES
5. Composite PK → PRIMARY KEY (col1, col2)
6. Relationship → ForeignKey trong bảng con
```

### 2.4 Các bảng trong database

| Bảng | Primary Key | Foreign Keys |
|------|-------------|--------------|
| stores | store_id | - |
| staffs | staff_id | store_id, manager_id (self) |
| customers | customer_id | - |
| orders | order_id | customer_id, store_id, staff_id |
| products | product_id | - |
| stocks | store_id + product_id | store_id, product_id |
| order_items | order_id + item_id | order_id, product_id |

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
> "Create one database and then write SQL statements to create, in this database, all tables derived from the ERD given..."

### 🧠 Tư duy

```
Yêu cầu: Chuyển ERD → SQL CREATE TABLE
Lưu ý:   Đây là BT chuyển từ ERD sang SQL (KHÔNG cần chạy được)
Input:   ERD Diagram
Output:  SQL CREATE TABLE statements (KHÔNG có CREATE DATABASE, USE, GO)
```

### 🔍 Phân tích

| Bước | Xác định |
|------|----------|
| 1. Số lượng bảng | 7 bảng (stores, staffs, customers, orders, products, stocks, order_items) |
| 2. Thứ tự tạo | Bảng mạnh trước (không FK) → Bảng có FK |
| 3. Composite PK | stocks (store_id, product_id), order_items (order_id, item_id) |
| 4. Self-referencing | staffs.manager_id → staffs.staff_id |

### ✅ Code (Q1_temp.sql - Dùng để TEST)

```sql
-- ==========================================
-- Q1_temp.sql - File dùng để test (KHÔNG NỘP)
-- ==========================================

-- Tạo database
CREATE DATABASE BikeStore;
GO

USE BikeStore;
GO

-- Bước 1: Tạo bảng MẠNH (không có FK)

-- Table stores
CREATE TABLE stores (
    store_id INT PRIMARY KEY,
    store_name NVARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    street NVARCHAR(100),
    city NVARCHAR(50),
    state VARCHAR(5),
    zip_code VARCHAR(10)
);

-- Table customers
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name NVARCHAR(50),
    last_name NVARCHAR(50),
    phone VARCHAR(20),
    email VARCHAR(100),
    street NVARCHAR(100),
    city NVARCHAR(50),
    state VARCHAR(5),
    zip_code VARCHAR(10)
);

-- Table products
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name NVARCHAR(150),
    model_year INT,
    list_price DECIMAL(12, 2),
    brand_name NVARCHAR(50),
    category_name NVARCHAR(50)
);

-- Bước 2: Tạo bảng có FK

-- Table staffs (có self-referencing)
CREATE TABLE staffs (
    staff_id INT PRIMARY KEY,
    first_name NVARCHAR(50),
    last_name NVARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    active BIT,
    store_id INT,
    manager_id INT,
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    FOREIGN KEY (manager_id) REFERENCES staffs(staff_id)
);

-- Table orders
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_status INT,
    order_date DATE,
    required_date DATE,
    shipped_date DATE,
    customer_id INT,
    store_id INT,
    staff_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    FOREIGN KEY (staff_id) REFERENCES staffs(staff_id)
);

-- Table stocks (Composite PK)
CREATE TABLE stocks (
    store_id INT,
    product_id INT,
    quantity INT,
    PRIMARY KEY (store_id, product_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Table order_items (Composite PK)
CREATE TABLE order_items (
    order_id INT,
    item_id INT,
    product_id INT,
    quantity INT,
    list_price DECIMAL(12, 2),
    discount DECIMAL(4, 2),
    PRIMARY KEY (order_id, item_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

### ✅ Code (Q1.sql - NỘP file này)

```sql
-- ==========================================
-- Q1.sql - File NỘP (Chỉ có CREATE TABLE)
-- ==========================================

-- Table stores
CREATE TABLE stores (
    store_id INT PRIMARY KEY,
    store_name NVARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    street NVARCHAR(100),
    city NVARCHAR(50),
    state VARCHAR(5),
    zip_code VARCHAR(10)
);

-- Table customers
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name NVARCHAR(50),
    last_name NVARCHAR(50),
    phone VARCHAR(20),
    email VARCHAR(100),
    street NVARCHAR(100),
    city NVARCHAR(50),
    state VARCHAR(5),
    zip_code VARCHAR(10)
);

-- Table products
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name NVARCHAR(150),
    model_year INT,
    list_price DECIMAL(12, 2),
    brand_name NVARCHAR(50),
    category_name NVARCHAR(50)
);

-- Table staffs (có self-referencing)
CREATE TABLE staffs (
    staff_id INT PRIMARY KEY,
    first_name NVARCHAR(50),
    last_name NVARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    active BIT,
    store_id INT,
    manager_id INT,
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    FOREIGN KEY (manager_id) REFERENCES staffs(staff_id)
);

-- Table orders
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_status INT,
    order_date DATE,
    required_date DATE,
    shipped_date DATE,
    customer_id INT,
    store_id INT,
    staff_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    FOREIGN KEY (staff_id) REFERENCES staffs(staff_id)
);

-- Table stocks (Composite PK)
CREATE TABLE stocks (
    store_id INT,
    product_id INT,
    quantity INT,
    PRIMARY KEY (store_id, product_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Table order_items (Composite PK)
CREATE TABLE order_items (
    order_id INT,
    item_id INT,
    product_id INT,
    quantity INT,
    list_price DECIMAL(12, 2),
    discount DECIMAL(4, 2),
    PRIMARY KEY (order_id, item_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

### 💡 Tips
- **Q1.sql**: KHÔNG có CREATE DATABASE, USE, GO - Chỉ CREATE TABLE
- **Q1_temp.sql**: CÓ đầy đủ CREATE DATABASE, USE, GO - Dùng để test
- Thứ tự tạo quan trọng: Bảng không FK → Bảng có FK
- Self-referencing: manager_id tham chiếu đến staff_id của cùng bảng
- Composite PK: `PRIMARY KEY (col1, col2)`

---

## 📌 QUESTION 2: SELECT WHERE + ORDER BY [0.5 điểm]

### 📖 Đọc đề
> "Write a query to list Customers living in New York. The result includes: customer_id, first_name, last_name, email. Sort in ascending order by last_name, first_name."

### 🧠 Tư duy

```
Yêu cầu: Lấy khách hàng ở New York, sắp xếp theo tên
Input:   Bảng customers
Output:  customer_id, first_name, last_name, email
ĐK lọc:  city = 'New York'
Sắp xếp: ORDER BY last_name ASC, first_name ASC
```

### 🔍 Phân tích

| Cần lấy | Từ bảng nào | Điều kiện | Sắp xếp |
|---------|-------------|-----------|---------|
| customer_id, first_name, last_name, email | customers | city = 'New York' | last_name ASC, first_name ASC |

### ✅ Code

```sql
SELECT customer_id,
       first_name,
       last_name,
       email
FROM customers
WHERE city = 'New York'
ORDER BY last_name ASC, first_name ASC;
```

### 💡 Formula

```sql
SELECT [cột_cần_lấy]
FROM [bảng]
WHERE [điều_kiện]
ORDER BY [cột1] ASC, [cột2] ASC;
```

---

## 📌 QUESTION 3: SELECT LIKE + ORDER BY [1 điểm]

### 📖 Đọc đề
> "Write a query to list products with a product_name containing the word 'City'. The result includes: product_id, product_name, list_price. Sort in ascending order by product_name."

### 🧠 Tư duy

```
Yêu cầu: Lấy sản phẩm có tên chứa 'City'
Input:   Bảng products
Output:  product_id, product_name, list_price
ĐK lọc:  product_name chứa 'City'
Sắp xếp: product_name ASC
```

### 🔍 Phân tích

| Keyword | SQL |
|---------|-----|
| "containing the word 'City'" | LIKE '%City%' |
| "sort in ascending order" | ORDER BY ... ASC |

### ✅ Code

```sql
SELECT product_id,
       product_name,
       list_price
FROM products
WHERE product_name LIKE '%City%'
ORDER BY product_name ASC;
```

### 💡 3 cách dùng LIKE

```sql
-- Bắt đầu bằng 'City'
WHERE product_name LIKE 'City%'

-- Kết thúc bằng 'City'
WHERE product_name LIKE '%City'

-- Chứa 'City' ở bất kỳ đâu
WHERE product_name LIKE '%City%'
```

---

## 📌 QUESTION 4: DATE FILTER WITH BETWEEN [1 điểm]

### 📖 Đọc đề
> "Write a query to find orders between 2025-08-05 and 2025-08-15 (YYYY-MM-DD). Display: order_id, customer_id, order_date, store_id, staff_id. Sort in ascending order by order_date."

### 🧠 Tư duy

```
Yêu cầu: Lấy đơn hàng trong khoảng ngày
Input:   Bảng orders
Output:  order_id, customer_id, order_date, store_id, staff_id
ĐK lọc:  order_date BETWEEN '2025-08-05' AND '2025-08-15'
Sắp xếp: order_date ASC
```

### 🔍 Phân tích

| Bước | Xác định |
|------|----------|
| 1. Bảng cần | orders |
| 2. Filter date | BETWEEN '2025-08-05' AND '2025-08-15' |
| 3. Sort | order_date ASC |

### ✅ Code

```sql
SELECT order_id,
       customer_id,
       order_date,
       store_id,
       staff_id
FROM orders
WHERE order_date BETWEEN '2025-08-05' AND '2025-08-15'
ORDER BY order_date ASC;
```

### 💡 3 cách filter date

```sql
-- Cách 1: BETWEEN (khuyến nghị - bao gồm cả 2 đầu)
WHERE order_date BETWEEN '2025-08-05' AND '2025-08-15'

-- Cách 2: >= và <=
WHERE order_date >= '2025-08-05' AND order_date <= '2025-08-15'

-- Cách 3: YEAR + MONTH + DAY
WHERE YEAR(order_date) = 2025
  AND MONTH(order_date) = 8
  AND DAY(order_date) BETWEEN 5 AND 15
```

---

## 📌 QUESTION 5: LOWEST PRICE (SUBQUERY) [1 điểm]

### 📖 Đọc đề
> "Write a query to find the products with the lowest list_price. Display: product_id, product_name, list_price."

### 🧠 Tư duy

```
Yêu cầu: Tìm sản phẩm có giá thấp nhất
Input:   Bảng products
Output:  product_id, product_name, list_price
Logic:   Lấy products có list_price = MIN(list_price)
```

### 🔍 Phân tích

| Keyword | Action |
|---------|--------|
| "lowest" | Giá trị nhỏ nhất |
| "products with the lowest" | Có thể CÓ HƠN 1 sản phẩm |

### ✅ Code

```sql
SELECT product_id,
       product_name,
       list_price
FROM products
WHERE list_price = (SELECT MIN(list_price) FROM products);
```

### 💡 2 cách tìm giá trị thấp nhất

```sql
-- Cách 1: Subquery (Đúng - vì có thể có nhiều sản phẩm cùng giá)
SELECT * FROM products
WHERE list_price = (SELECT MIN(list_price) FROM products);

-- Cách 2: TOP 1 (SAI - chỉ lấy 1 sản phẩm)
SELECT TOP 1 * FROM products
ORDER BY list_price ASC;
```

### 💡 Formula cho "lowest/highest"

```sql
-- Lowest
SELECT * FROM table
WHERE column = (SELECT MIN(column) FROM table);

-- Highest
SELECT * FROM table
WHERE column = (SELECT MAX(column) FROM table);
```

---

## 📌 QUESTION 6: GROUP BY + ORDER BY DESC + ASC [1 điểm]

### 📖 Đọc đề
> "Write a query to calculate the total quantity in each store. The result includes: store_id, store_name, total_qty_in_stock. Sort in descending order by total_qty_in_stock and ascending order by store_id."

### 🧠 Tư duy

```
Yêu cầu: Tính tổng quantity theo từng store
Input:   Bảng stores, stocks
Output:  store_id, store_name, total_qty_in_stock
Agg:     SUM(quantity)
Group:   BY store_id, store_name
Sort:    total_qty DESC, store_id ASC
```

### 🔍 Phân tích

| Bước | Xác định |
|------|----------|
| 1. Bảng cần | stores, stocks |
| 2. Join | stores.store_id = stocks.store_id |
| 3. Aggregate | SUM(quantity) AS total_qty_in_stock |
| 4. Group by | store_id, store_name |
| 5. Sort | total_qty_in_stock DESC, store_id ASC |

### ✅ Code

```sql
SELECT s.store_id,
       s.store_name,
       SUM(st.quantity) AS total_qty_in_stock
FROM stores s
JOIN stocks st ON s.store_id = st.store_id
GROUP BY s.store_id, s.store_name
ORDER BY total_qty_in_stock DESC, s.store_id ASC;
```

### 💡 Formula cho GROUP BY + ORDER BY nhiều cột

```sql
SELECT [cột], SUM/AVG/COUNT([cột]) AS [tên]
FROM [bảng1]
JOIN [bảng2] ON [đk]
GROUP BY [cột_cần_group]
ORDER BY [aggregate_col] DESC, [non_aggregate_col] ASC;
```

---

## 📌 QUESTION 7: MAX WITHIN EACH GROUP [1 điểm]

### 📖 Đọc đề
> "Write a query to find the highest list_price of products within each category_name. The result includes: category_name, product_id, product_name, list_price. Sort in ascending order by category_name and product_id."

### 🧠 Tư duy

```
Yêu cầu: Tìm sản phẩm có giá cao nhất TRONG TỪNG category
Input:   Bảng products
Output:  category_name, product_id, product_name, list_price
Logic:   Với mỗi category, lấy product có MAX(list_price)
```

### 🔍 Phân tích

| Bước | Xác định |
|------|----------|
| 1. Bảng cần | products |
| 2. Cần join chính nó | Để tìm max theo group |
| 3. Filter | list_price = MAX(list_price) trong mỗi category |

### ✅ Code

```sql
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
ORDER BY p.category_name ASC, p.product_id ASC;
```

### 💡 Giải thích logic

```
Ý tưởng: Với mỗi product, kiểm tra xem list_price của nó
         có bằng MAX list_price của category đó không?

┌─────────────────────────────────────────┐
│  Category: "BMX"                        │
│  Products: BMX 200 (299), BMX Spark (149)│
│  MAX price = 299                        │
│  → Chỉ lấy BMX 200                      │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│  Category: "City"                       │
│  Products: City Pro (399), City Lite (199)│
│  MAX price = 399                        │
│  → Chỉ lấy City Pro                     │
└─────────────────────────────────────────┘
```

### 💡 Formula cho "max/min within each group"

```sql
SELECT t1.group_col, t1.other_col, t1.value_col
FROM table t1
WHERE t1.value_col = (
    SELECT MAX(t2.value_col)
    FROM table t2
    WHERE t2.group_col = t1.group_col
)
ORDER BY t1.group_col;
```

---

## 📌 QUESTION 8: STORED PROCEDURE WITH OUTPUT [1 điểm]

### 📖 Đọc đề
> "Create a stored procedure named proc_SumQuantityProduct to calculate the total products quantity of each store_id. Where @store_id int is an input parameter and @SumQuantity Decimal(10,2) is an output parameter."

### 🧠 Tư duy

```
Yêu cầu: Tạo procedure tính tổng quantity theo store
Input:   @store_id INT
Output:  @SumQuantity DECIMAL(10,2) OUTPUT
Logic:   SUM(quantity) WHERE store_id = @store_id
```

### 🔍 Phân tích

| Thành phần | Giá trị |
|------------|---------|
| Tên procedure | proc_SumQuantityProduct |
| Input param | @store_id INT |
| Output param | @SumQuantity DECIMAL(10,2) OUTPUT |
| Logic | SUM(quantity) FROM stocks WHERE store_id = @store_id |

### ✅ Code

```sql
CREATE PROCEDURE proc_SumQuantityProduct
    @store_id INT,
    @SumQuantity DECIMAL(10,2) OUTPUT
AS
BEGIN
    SELECT @SumQuantity = SUM(quantity)
    FROM stocks
    WHERE store_id = @store_id;
END;
```

### 💡 Cấu trúc PROCEDURE với OUTPUT

```sql
CREATE PROCEDURE [tên_procedure]
    [@param_input] [data_type],          -- Input parameter
    [@param_output] [data_type] OUTPUT    -- Output parameter
AS
BEGIN
    -- Gán giá trị cho output parameter
    SELECT @param_output = [hàm_aggregate]([cột])
    FROM [bảng]
    WHERE [điều_kiện];
END;
```

### 🔍 Cách test (đừng nộp phần này)

```sql
-- Khai báo biến
DECLARE @x DECIMAL(10,2);

-- Gọi procedure
EXEC proc_SumQuantityProduct 2, @x OUTPUT;

-- Xem kết quả
SELECT @x AS SumQuantityProduct;
```

---

## 📌 QUESTION 9: MULTI-JOIN + DISTINCT [1 điểm]

### 📖 Đọc đề
> "Write a query to list the staffs who processed orders for customers in the state of 'CA'. Display: staff_id, first_name, last_name."

### 🧠 Tư duy

```
Yêu cầu: Liệt kê staff đã xử lý orders cho khách ở state 'CA'
Input:   Bảng staffs, orders, customers
Output:  staff_id, first_name, last_name
ĐK lọc:  customers.state = 'CA'
Join:    staffs → orders → customers
```

### 🔍 Phân tích

| Bước | Xác định |
|------|----------|
| 1. Bảng cần | staffs, orders, customers |
| 2. Join path | staffs.staff_id = orders.staff_id → orders.customer_id = customers.customer_id |
| 3. Filter | customers.state = 'CA' |
| 4. Unique | DISTINCT (vì 1 staff có thể xử lý nhiều orders) |

### ✅ Code

```sql
SELECT DISTINCT s.staff_id,
                s.first_name,
                s.last_name
FROM staffs s
JOIN orders o ON s.staff_id = o.staff_id
JOIN customers c ON o.customer_id = c.customer_id
WHERE c.state = 'CA';
```

### 💡 Tại sao cần DISTINCT?

```
┌─────────────────────────────────────────────────┐
│  Staff A có thể xử lý NHIỀU orders              │
│  → Nếu không DISTINCT, Staff A xuất hiện N lần  │
│  → DISTINCT giữ lại mỗi staff chỉ 1 lần         │
└─────────────────────────────────────────────────┘
```

### 💡 Formula cho Multi-JOIN

```sql
SELECT DISTINCT [cột]
FROM [bảng1]
JOIN [bảng2] ON [đk1]
JOIN [bảng3] ON [đk2]
WHERE [điều_kiện];
```

---

## 📌 QUESTION 10: DELETE WITH SUBQUERY [1 điểm]

### 📖 Đọc đề
> "Write a query to delete rows from the stocks table whose product_id belongs to category_name is 'Mountain'."

### 🧠 Tư duy

```
Yêu cầu: Xóa stocks có product thuộc category 'Mountain'
Input:   Bảng stocks, products
ĐK:      product_id IN (sản phẩm có category_name = 'Mountain')
```

### 🔍 Phân tích

| Bước | Xác định |
|------|----------|
| 1. Bảng xóa | stocks |
| 2. ĐK xóa | product_id IN (subquery) |
| 3. Subquery | SELECT product_id FROM products WHERE category_name = 'Mountain' |

### ✅ Code

```sql
DELETE FROM stocks
WHERE product_id IN (
    SELECT product_id
    FROM products
    WHERE category_name = 'Mountain'
);
```

### 💡 2 cách viết với subquery

```sql
-- Cách 1: IN (khuyến nghị)
DELETE FROM stocks
WHERE product_id IN (
    SELECT product_id FROM products WHERE category_name = 'Mountain'
);

-- Cách 2: EXISTS
DELETE FROM stocks
WHERE EXISTS (
    SELECT 1 FROM products
    WHERE products.product_id = stocks.product_id
      AND category_name = 'Mountain'
);
```

### ⚠️ CẢNH BÁO: DELETE với JOIN

```sql
-- SQL Server KHÔNG hỗ trợ DELETE với JOIN trực tiếp
-- ❌ SAI trong SQL Server:
DELETE FROM stocks s
JOIN products p ON s.product_id = p.product_id
WHERE p.category_name = 'Mountain';

-- ✅ ĐÚNG: Dùng subquery IN/EXISTS
DELETE FROM stocks
WHERE product_id IN (...);
```

---

## 🎯 PHẦN 4: TỔNG HỢP SYNTAX

### 4.1 SELECT với WHERE và ORDER BY

```sql
SELECT col1, col2, col3
FROM table
WHERE condition
ORDER BY col1 ASC, col2 DESC;
```

### 4.2 LIKE - Tìm kiếm chuỗi

```sql
-- Chứa chuỗi
WHERE col LIKE '%keyword%'

-- Bắt đầu bằng chuỗi
WHERE col LIKE 'keyword%'

-- Kết thúc bằng chuỗi
WHERE col LIKE '%keyword'
```

### 4.3 BETWEEN - Lọc khoảng

```sql
-- Ngày tháng
WHERE date_col BETWEEN '2025-08-05' AND '2025-08-15'

-- Số
WHERE price BETWEEN 100 AND 500
```

### 4.4 GROUP BY + ORDER BY

```sql
SELECT col1, SUM(col2) AS total
FROM table
GROUP BY col1
ORDER BY total DESC, col1 ASC;
```

### 4.5 Subquery trong WHERE

```sql
-- Min/Max
WHERE col = (SELECT MAX(col) FROM table)

-- IN list
WHERE col IN (SELECT col FROM table WHERE condition)
```

### 4.6 Stored Procedure

```sql
CREATE PROCEDURE proc_name
    @input param_type,
    @output param_type OUTPUT
AS
BEGIN
    SELECT @output = AGG(col)
    FROM table
    WHERE col = @input;
END;
```

### 4.7 DELETE với Subquery

```sql
DELETE FROM table1
WHERE col IN (
    SELECT col FROM table2 WHERE condition
);
```

---

## 🎯 PHẦN 5: CHECKLIST TRƯỚC KHI NỘP

```
☐ Folder tên đúng: RollNo_Name_DBI202_01
☐ Không có subfolder
☐ File naming: Q1.sql, Q2.sql, ..., Q10.sql
☐ Q1.sql: CHỈ có CREATE TABLE (KHÔNG có CREATE DATABASE, USE, GO)
☐ Q2-Q10: KHÔNG có USE, GO, EXEC
☐ Chỉ chứa câu trả lời (không có test code)
☐ Data type đúng với ERD
☐ PK, FK đúng
☐ Output column đúng với đề bài
☐ ORDER BY đúng thứ tự
☐ DISTINCT khi cần (Q9)
```

---

## 🎯 PHẦN 6: CÁCH LÀM BÀI THỰC CHIẾN

```
┌─────────────────────────────────────────────────────┐
│  BƯỚC 1: Tạo folder theo quy định                    │
│  → se01245_LongNT_DBI202_01                          │
├─────────────────────────────────────────────────────┤
│  BƯỚC 2: Tạo 10 file rỗng                           │
│  → Q1.sql, Q2.sql, ..., Q10.sql                      │
├─────────────────────────────────────────────────────┤
│  BƯỚC 3: Chạy script provided                        │
│  → Tạo database, tables, data                        │
├─────────────────────────────────────────────────────┤
│  BƯỚC 4: Làm từng câu một                            │
│  → Đọc → Phân tích → Viết code → Test                │
├─────────────────────────────────────────────────────┤
│  BƯỚC 5: Review lại từng câu                         │
│  → So sánh output với đề bài                         │
├─────────────────────────────────────────────────────┤
│  BƯỚC 6: Clean test code                             │
│  → Chỉ giữ lại câu lệnh trả lời                      │
│  → Xóa USE, GO, EXEC, DECLARE                        │
├─────────────────────────────────────────────────────┤
│  BƯỚC 7: Nộp bài                                     │
└─────────────────────────────────────────────────────┘
```

---

## 🎯 PHẦN 7: MẸO NHỚ CÚ PHÁP

### Phương pháp "Keyword Mapping"

```
Đề bài nói              → SQL keyword
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"living in"             → WHERE city = '...'
"containing the word"    → LIKE '%word%'
"between ... and ..."    → BETWEEN ... AND
"lowest/highest"         → WHERE col = (SELECT MIN/MAX...)
"total quantity"         → SUM(quantity)
"within each category"   → Subquery với WHERE group = group
"output parameter"       → @param OUTPUT
"who processed orders"   → JOIN orders WHERE ...
"belongs to category"    → IN (subquery)
"delete rows"            → DELETE FROM ... WHERE ... IN
```

### Phương pháp "Table Mapping"

```
Đề bài nói              → Bảng cần dùng
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"customers"              → customers table
"products"               → products table
"orders"                 → orders table
"staffs"                 → staffs table
"stores"                 → stores table
"stocks"                 → stocks table
"order_items"            → order_items table
```

---

## 🎯 PHẦN 8: FAQ - CÂU HỎI THƯỜNG GẶP

### Q1: Tại sao Q1 có CREATE DATABASE nhưng các câu khác không?

```
Q1: Tạo database mới → Cần CREATE DATABASE
Q2-Q10: Database đã có → Chỉ cần viết câu lệnh query
→ Nếu Q2-Q10 có USE database sẽ bị 0 điểm!
```

### Q2: Khi nào dùng DISTINCT?

```
Dùng khi:
- Muốn loại bỏ duplicate
- 1 entity có thể liên kết với nhiều rows (như staff-orders)

Ví dụ: Staff A xử lý 5 orders
→ Không DISTINCT: Staff A xuất hiện 5 lần
→ Có DISTINCT: Staff A xuất hiện 1 lần
```

### Q3: Subquery IN hay EXISTS tốt hơn?

```
IN:         Đơn giản, dễ hiểu
EXISTS:     Nhanh hơn với dataset lớn

Với bài thi: IN là đủ tốt và dễ viết hơn
```

### Q4: Tại sao phải GROUP BY nhiều cột?

```
Vì SELECT có nhiều cột non-aggregate
→ Phải GROUP BY tất cả các cột đó

Ví dụ:
SELECT store_id, store_name, SUM(quantity)
→ GROUP BY store_id, store_name
```

### Q5: ORDER BY với DESC và ASC cùng lúc?

```sql
ORDER BY total_qty DESC, store_id ASC
─────────────────    ─────────────
   Sắp xếp chính      Sắp xếp phụ

Khi total_qty bằng nhau, thì sắp xếp theo store_id
```

---

## 🎯 PHẦN 9: TRICKS & TRAPS

### ⚠️ CÁC BẪY THƯỜNG GẶP

| Bẫy | VD | Cách tránh |
|-----|----|------------|
| Quên DISTINCT | Staff xuất hiện nhiều lần | Thêm DISTINCT |
| TOP 1 cho lowest price | Chỉ lấy 1 sản phẩm | Dùng subquery với MIN |
| WHERE với aggregate | WHERE SUM(qty) > 10 | Dùng HAVING |
| Quên ORDER BY thứ cấp | Chỉ sort 1 cột | Thêm ASC/DESC cho các cột khác |
| DELETE với JOIN | DELETE JOIN trong SQL Server | Dùng IN subquery |
| Quên OUTPUT param | @param thay vì OUTPUT | Thêm OUTPUT |
| Composite PK sai | PRIMARY KEY (col1) | PRIMARY KEY (col1, col2) |

### ✅ MẸO ĐẠT ĐIỂM CAO

1. **Đọc đề kỹ 2 lần** trước khi code
2. **Vẽ sơ đồ JOIN** giữa các bảng
3. **Test từng câu** trước khi chuyển sang câu khác
4. **Đặt alias** ngắn gọn: s cho stores, p cho products, st cho stocks
5. **Format code** cho dễ đọc (indent, xuống dòng)
6. **So sánh output** với đề bài từng cột một

---

## 🎯 PHẦN 10: FULL SOLUTION - THAM KHẢO

```sql
-- ==========================================
-- Q1: CREATE DATABASE + TABLES
-- ==========================================

CREATE DATABASE BikeStore;
GO

USE BikeStore;
GO

CREATE TABLE stores (
    store_id INT PRIMARY KEY,
    store_name NVARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    street NVARCHAR(100),
    city NVARCHAR(50),
    state VARCHAR(5),
    zip_code VARCHAR(10)
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name NVARCHAR(50),
    last_name NVARCHAR(50),
    phone VARCHAR(20),
    email VARCHAR(100),
    street NVARCHAR(100),
    city NVARCHAR(50),
    state VARCHAR(5),
    zip_code VARCHAR(10)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name NVARCHAR(150),
    model_year INT,
    list_price DECIMAL(12, 2),
    brand_name NVARCHAR(50),
    category_name NVARCHAR(50)
);

CREATE TABLE staffs (
    staff_id INT PRIMARY KEY,
    first_name NVARCHAR(50),
    last_name NVARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    active BIT,
    store_id INT,
    manager_id INT,
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    FOREIGN KEY (manager_id) REFERENCES staffs(staff_id)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_status INT,
    order_date DATE,
    required_date DATE,
    shipped_date DATE,
    customer_id INT,
    store_id INT,
    staff_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    FOREIGN KEY (staff_id) REFERENCES staffs(staff_id)
);

CREATE TABLE stocks (
    store_id INT,
    product_id INT,
    quantity INT,
    PRIMARY KEY (store_id, product_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE order_items (
    order_id INT,
    item_id INT,
    product_id INT,
    quantity INT,
    list_price DECIMAL(12, 2),
    discount DECIMAL(4, 2),
    PRIMARY KEY (order_id, item_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- ==========================================
-- Q2: Customers in New York
-- ==========================================

SELECT customer_id,
       first_name,
       last_name,
       email
FROM customers
WHERE city = 'New York'
ORDER BY last_name ASC, first_name ASC;

-- ==========================================
-- Q3: Products containing 'City'
-- ==========================================

SELECT product_id,
       product_name,
       list_price
FROM products
WHERE product_name LIKE '%City%'
ORDER BY product_name ASC;

-- ==========================================
-- Q4: Orders between dates
-- ==========================================

SELECT order_id,
       customer_id,
       order_date,
       store_id,
       staff_id
FROM orders
WHERE order_date BETWEEN '2025-08-05' AND '2025-08-15'
ORDER BY order_date ASC;

-- ==========================================
-- Q5: Products with lowest price
-- ==========================================

SELECT product_id,
       product_name,
       list_price
FROM products
WHERE list_price = (SELECT MIN(list_price) FROM products);

-- ==========================================
-- Q6: Total quantity per store
-- ==========================================

SELECT s.store_id,
       s.store_name,
       SUM(st.quantity) AS total_qty_in_stock
FROM stores s
JOIN stocks st ON s.store_id = st.store_id
GROUP BY s.store_id, s.store_name
ORDER BY total_qty_in_stock DESC, s.store_id ASC;

-- ==========================================
-- Q7: Highest price per category
-- ==========================================

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
ORDER BY p.category_name ASC, p.product_id ASC;

-- ==========================================
-- Q8: Stored procedure
-- ==========================================

CREATE PROCEDURE proc_SumQuantityProduct
    @store_id INT,
    @SumQuantity DECIMAL(10,2) OUTPUT
AS
BEGIN
    SELECT @SumQuantity = SUM(quantity)
    FROM stocks
    WHERE store_id = @store_id;
END;

-- ==========================================
-- Q9: Staffs with CA customers
-- ==========================================

SELECT DISTINCT s.staff_id,
                s.first_name,
                s.last_name
FROM staffs s
JOIN orders o ON s.staff_id = o.staff_id
JOIN customers c ON o.customer_id = c.customer_id
WHERE c.state = 'CA';

-- ==========================================
-- Q10: Delete Mountain category stocks
-- ==========================================

DELETE FROM stocks
WHERE product_id IN (
    SELECT product_id
    FROM products
    WHERE category_name = 'Mountain'
);
```

---

## 📚 TÀI LIỆU THAM KHẢO

- Microsoft SQL Server Documentation
- W3Schools SQL Tutorial
- Entity-Relationship Diagram (ERD) Basics

---

**Chúc bạn thi tốt! 🎉**

Made with ❤️ for DBI202 students
