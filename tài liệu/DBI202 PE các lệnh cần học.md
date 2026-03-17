
2026-03-14 16:30

Status:

Tags: [[DBI202]]
Disable spell check :`teh`
# DBI202 PE các lệnh cần học

## 1. Tạo Database

```sql
CREATE DATABASE TenDatabase
GO

USE TenDatabase
GO
```

---

## 2. Drop Table nếu đã tồn tại

```sql
-- Cách 1: dùng IF OBJECT_ID
IF OBJECT_ID('TenBang', 'U') IS NOT NULL
    DROP TABLE TenBang
GO

-- Nếu có nhiều bảng, phải drop bảng CON trước (bảng có FK)
-- vì bảng cha đang được tham chiếu
IF OBJECT_ID('Accounts', 'U') IS NOT NULL
    DROP TABLE Accounts
GO
IF OBJECT_ID('Clients', 'U') IS NOT NULL
    DROP TABLE Clients
GO
```

---

## 3. Primary Key

```sql
-- Cách 1: viết thẳng sau cột
CREATE TABLE Clients (
    Id INT PRIMARY KEY IDENTITY,  
    -- IDENTITY = tự tăng 1, 2, 3...
    Name NVARCHAR(50)
)

-- Cách 2: khai báo riêng bên dưới
CREATE TABLE Clients (
    Id INT,
    Name NVARCHAR(50),
    PRIMARY KEY (Id)
)
```

---

## 4. Foreign Key & References

```sql
-- Cách 1: viết thẳng sau cột
CREATE TABLE Accounts (
    Id INT PRIMARY KEY IDENTITY,
    ClientId INT FOREIGN KEY REFERENCES Clients(Id)
)

-- Cách 2: khai báo riêng bên dưới
CREATE TABLE Accounts (
    Id INT PRIMARY KEY IDENTITY,
    ClientId INT,
    FOREIGN KEY (ClientId) REFERENCES Clients(Id)
)
```

> ⚠️ Lưu ý: Bảng **cha** (Clients) phải được tạo **trước** bảng **con** (Accounts)

---

## 5. Số thực — DECIMAL(15, 2) DEFAULT 0

```sql
-- DECIMAL(tổng chữ số, chữ số sau dấu phẩy)
-- DECIMAL(15, 2) = tối đa 15 chữ số, trong đó 2 số sau dấu phẩy
-- Ví dụ: 9999999999999.99

CREATE TABLE Accounts (
    Id INT PRIMARY KEY IDENTITY,
    Balance DECIMAL(15, 2) DEFAULT 0  -- mặc định là 0
)
```

> So sánh các kiểu số thực:
> | Kiểu | Mô tả |
> |------|-------|
> | `FLOAT` | số thực, không kiểm soát chữ số thập phân |
> | `DECIMAL(p, s)` | chính xác, kiểm soát được số chữ số |
> | `NUMERIC(p, s)` | giống DECIMAL |

---

## 6. INSERT INTO ... VALUES

```sql
-- Insert 1 dòng
INSERT INTO Clients (FirstName, LastName)
VALUES ('Adam', 'Smith')

-- Insert nhiều dòng cùng lúc
INSERT INTO Clients (FirstName, LastName)
VALUES
('Adam', 'Smith'),
('Peter', 'Parker'),
('David', 'Sampson')
```


---

## 1. Tạo Stored Procedure

```sql
CREATE PROCEDURE TenProcedure
    @Param1 INT, -- inp/tham số
    @Param2 DECIMAL(10,2) OUTPUT -- Tham số đầu ra (Bắt buộc có chữ OUTPUT)
AS
BEGIN
    -- code ở đây
END
```

```sql
CREATE PROCEDURE proc_SumQuantityProduct
    @store_id INT,                    -- Tham số đầu vào
    @SumQuantity DECIMAL(10,2) OUTPUT -- Tham số đầu ra (Bắt buộc có chữ OUTPUT)
AS
BEGIN
    -- Gán kết quả tính tổng vào biến Output
    SELECT @SumQuantity = SUM(quantity)
    FROM stocks
    WHERE store_id = @store_id;
END;
```

---

## 2. BEGIN TRANSACTION / COMMIT / ROLLBACK

```sql
BEGIN TRANSACTION   -- bắt đầu transaction

    -- làm gì đó...

COMMIT              -- xác nhận lưu thay đổi
ROLLBACK            -- hoàn dữ liệu
RETURN              -- thoát procedur
```

|                     | Mô tả                                                                 | Khi nào dùng                 |
| ------------------- | --------------------------------------------------------------------- | ---------------------------- |
| `BEGIN TRANSACTION` | Bắt đầu "vùng an toàn"<br>đảm bảo: **cả 2 thành công, hoặc hủy hết.** | Trước khi thực hiện thay đổi |
| `COMMIT`            | Xác nhận lưu tất cả thay đổi                                          | Khi mọi thứ thành công       |
| `ROLLBACK`          | Hủy tất cả, quay về trạng thái ban đầu                                | Khi có lỗi xảy ra            |
- `ROLLBACK` + `RETURN` thường đi chung với nhau
	- Không có trường hợp nào cần `ROLLBACK` mà không `RETURN`, vì sau khi hủy transaction thì không có lý do gì chạy tiếp nữa.

---

## 3. IF / ELSE

```sql
IF @Amount <= 0
BEGIN
    -- làm gì đó
END
ELSE
BEGIN
    -- làm gì đó khác
END
```

---

## 4. RAISERROR & RETURN

```sql
RAISERROR('Thông báo lỗi', 16, 1)
-- 16 = mức độ lỗi (thường dùng 16)
-- 1  = state (thường để 1)

RETURN  -- thoát khỏi procedure ngay lập tức
```

---

## 5. EXISTS / NOT EXISTS

```sql
-- Kiểm tra có tồn tại không
IF EXISTS (SELECT 1 FROM Accounts WHERE Id = @AccountId)
BEGIN
    -- tồn tại
END

IF NOT EXISTS (SELECT 1 FROM Accounts WHERE Id = @AccountId)
BEGIN
    -- không tồn tại
END
```


---

## 7. UPDATE

```sql
UPDATE Accounts
SET Balance = Balance - @Amount
WHERE Id = @AccountId
```

---

## 8. EXIST + SELECT dùng để CHECK tồn tại
```sql
-- Kiểm tra có tồn tại không, không quan tâm data
IF EXISTS (SELECT 1 FROM Accounts WHERE Id = @AccountId)

IF NOT EXISTS (SELECT 1 FROM Accounts WHERE Id = @AccountId)
```
- SELECT 1 : là dữ liệu ko có cần lưu

---

## 9. SELECT cho biến bằng giá trị trong table
```sql
-- Lấy giá trị từ bảng gán vào biến
SELECT @Balance = Balance FROM Accounts WHERE Id = @AccountId
```

|       | Có `@`                   | Không có `@`         |     |
| ----- | ------------------------ | -------------------- | --- |
| Là    | Biến (variable)          | Tên cột trong bảng   |     |
| Lưu ở | RAM, trong procedure     | Database, trong bảng |     |
| Ví dụ | `@balance`, `@AccountId` | `Balance`, `Id`      |     |

**Đọc dòng đó theo nghĩa tiếng Việt:**
```
Lấy giá trị cột [Balance] từ bảng Accounts
↓
gán vào biến @balance
điều kiện: cột [Id] = biến @AccountId
```

---

## 10. DECLARE — Khai báo biến
```sql
-- Khai báo biến
DECLARE @TenBien KieuDuLieu

-- Ví dụ
DECLARE @Balance DECIMAL(15, 2)
DECLARE @Name NVARCHAR(50)
DECLARE @Count INT

-- Khai báo nhiều biến cùng lúc
DECLARE @Balance DECIMAL(15, 2), @Name NVARCHAR(50)
```

---
## 11. UPDATE — Cập nhật dữ liệu

```sql
UPDATE TenBang
SET TenCot = GiaTriMoi
WHERE DieuKien
```

```sql
-- Ví dụ: trừ tiền
UPDATE Accounts
SET Balance = Balance - @Amount
WHERE Id = @AccountId
```

> ⚠️ **Luôn có WHERE** — nếu không có WHERE sẽ cập nhật **toàn bộ** bảng

---
## 12. TRIGGER — Tự động chạy khi có thay đổi

```sql
CREATE TRIGGER TenTrigger
ON TenBang
AFTER UPDATE  -- hoặc INSERT, DELETE
AS
BEGIN
    -- code ở đây
END
```

 **2 bảng ảo trong Trigger**

| Bảng       | Chứa gì                                     |
| ---------- | ------------------------------------------- |
| `inserted` | Dữ liệu **sau** khi thay đổi (giá trị mới)  |
| `deleted`  | Dữ liệu **trước** khi thay đổi (giá trị cũ) |

```sql
-- Lấy giá trị từ bảng ảo
SELECT @NewBalance = Balance FROM inserted
SELECT @OldBalance = Balance FROM deleted
```

---
## 13.1 DATE — Ngày giờ

**Lấy ngày giờ hiện tại**
```sql
GETDATE()  -- trả về ngày giờ hiện tại
SET @Date = GETDATE();
```

## 13.2 CONVERT — Format ngày giờ

```sql
CONVERT(NVARCHAR, GETDATE(), style)
---
CONVERT(NVARCHAR, GETDATE(), 105) -- dd-MM-yyyy 
CONVERT(NVARCHAR, GETDATE(), 108) -- HH:mm:ss
```

|Style|Format|Ví dụ|
|---|---|---|
|`105`|dd-MM-yyyy|14-03-2026|
|`108`|HH:mm:ss|16:30:00|
|`103`|dd/MM/yyyy|14/03/2026|
|`101`|MM/dd/yyyy|03/14/2026|
|`120`|yyyy-MM-dd HH:mm:ss|2026-03-14 16:30:00|

---

## 14. CAST — Chuyển kiểu dữ liệu

```sql
CAST(GiaTri AS KieuMoi)
```

**Các trường hợp hay dùng**

| Từ         | Sang       | Ví dụ                            |
| ---------- | ---------- | -------------------------------- |
| `INT`      | `NVARCHAR` | `CAST(@Id AS NVARCHAR)`          |
| `DECIMAL`  | `NVARCHAR` | `CAST(@Balance AS NVARCHAR)`     |
| `NVARCHAR` | `INT`      | `CAST('123' AS INT)`             |
| `NVARCHAR` | `DECIMAL`  | `CAST('99.99' AS DECIMAL(15,2))` |

---

## 15. CONCAT() - Nối chuỗi

```sql
CONCAT(value1, value2, value3, ...)

-- Ví dụ
CONCAT('Account: ', @AccountId)
CONCAT('On ', @Date, ' balance changed from ', @OldBalance, ' to ', @NewBalance, '.')
```

> ✅ Tự chuyển số sang chuỗi, tự bỏ qua NULL, không cần CAST
> ⚠️ Không trộn `CONCAT()` với `+`

---
## 16. Nối chuỗi (dùng dấu `+` )

**Cách 1: Dùng `+`**
```sql
'Chuỗi 1' + 'Chuỗi 2'

-- Số phải CAST trước
'Account: ' + CAST(@Id AS NVARCHAR)
```

> ⚠️ Nếu có NULL → cả chuỗi thành NULL
> ⚠️ Dùng dấu **nháy đơn**

---

## 17. SET — Gán giá trị cho biến

```sql
SET @TenBien = GiaTri
```

 **Các trường hợp hay dùng**
```sql
-- Gán giá trị cố định
SET @Amount = 100
SET @Name = N'Hello'

-- Gán kết quả tính toán
SET @Total = @Price * @Quantity

-- Gán chuỗi nối
SET @Date = CONVERT(NVARCHAR, GETDATE(), 105)
          + ' ' + CONVERT(NVARCHAR, GETDATE(), 108)
```

---

## 18. CREATE VIEW

```sql
CREATE VIEW TenView
AS
    SELECT ...
```

- **VIEW** là một **câu SELECT được lưu lại thành tên**, dùng đi dùng lại như một bảng ảo.

**Không có VIEW** — phải viết lại query mỗi lần:
```sql
-- Lần 1
SELECT c.FirstName, c.LastName
FROM Clients c
JOIN Accounts a ON a.ClientId = c.Id
GROUP BY c.Id, c.FirstName, c.LastName
HAVING SUM(a.Balance) > 300

-- Lần 2 muốn dùng lại → phải viết lại y chang
```

**Có VIEW** — gọi tên là xong:
```sql
-- Tạo 1 lần
CREATE VIEW vw_RichClients AS
SELECT ...

-- Dùng mãi mãi
SELECT * FROM vw_RichClients
```

---

## 19. JOIN

```sql
FROM BangCha c
JOIN BangCon a ON a.CotFK = c.CotPK
```

```sql
-- Ví dụ
FROM Clients c
JOIN Accounts a ON a.ClientId = c.Id
```

| Loại                            | Mô tả                                               |
| ------------------------------- | --------------------------------------------------- |
| `JOIN` / `INNER JOIN`           | Chỉ lấy dòng khớp cả 2 bảng                         |
| `LEFT JOIN`                     | Lấy tất cả bảng trái, bảng phải NULL nếu không khớp |
| `RIGHT JOIN`                    | Lấy tất cả bảng phải, bảng trái NULL nếu không khớp |
| `FULL JOIN` / `FULL OUTER JOIN` | Lấy tất cả dòng cả 2 bảng, NULL nếu không khớp      |

**Khớp = giá trị 2 cột bằng nhau** theo điều kiện `ON`, không nhất thiết phải là FK-PK.
```sql
-- Thường gặp nhất: FK = PK
ON a.ClientId = c.Id

-- Nhưng có thể là bất kỳ điều kiện nào
ON a.Balance = b.Balance
ON a.Name = b.Name
```


---

## 20. GROUP BY + HAVING
```sql
-- GROUP BY: gom nhóm
-- HAVING: lọc sau khi gom (như WHERE nhưng cho SUM, COUNT...)
GROUP BY Customers.Id, Customers.FirstName, Customers.LastName
HAVING SUM(Accounts.Balance) > 300
```

```sql
-- Ví dụ
GROUP BY c.Id, c.FirstName, c.LastName
HAVING SUM(a.Balance) > 300
```
- `c.` là là table nhưng nó viết tắt - alias

| Hàm | Làm gì |
|---|---|
| `SUM(cot)` | Tính tổng |
| `COUNT(cot)` | Đếm số dòng |
| `AVG(cot)` | Tính trung bình |
| `MAX(cot)` | Giá trị lớn nhất |
| `MIN(cot)` | Giá trị nhỏ nhất |
- **các hàm này cần group để biết xử lý theo nhóm nào**

|          | `WHERE`    | `HAVING`                 |
| -------- | ---------- | ------------------------ |
| Lọc      | Từng dòng  | Sau khi GROUP BY         |
| Dùng với | Cột thường | `SUM`, `COUNT`, `AVG`... |

> SQL bắt buộc: **mọi cột trong SELECT phải nằm trong GROUP BY**

**chia group ra rồi thì mỗi group sẽ chạy 1 select riêng**

---

## 20. Alias - viết tắt tên bảng

```sql
-- Alias: đặt tên viết tắt cho bảng
FROM TenBang TenVietTat

-- Ví dụ
FROM Clients c        -- c là alias của Clients
JOIN Accounts a       -- a là alias của Accounts
  ON a.ClientId = c.Id
```

**Không alias** vs **Có alias:**

```sql
-- Không alias (dài)
SELECT Clients.FirstName, Accounts.Balance
FROM Clients
JOIN Accounts ON Accounts.ClientId = Clients.Id

-- Có alias (ngắn hơn)
SELECT c.FirstName, a.Balance
FROM Clients c
JOIN Accounts a ON a.ClientId = c.Id
```

---


## 21. Bảng trung gian (M - N)

Khi ERD có quan hệ **Many-to-Many (M-N)**
→ phải tạo **bảng trung gian (junction table)**

```sql
CREATE TABLE EmployeeShifts (
    EmpId INT,
    ShiftId INT,

    PRIMARY KEY (EmpId, ShiftId),  -- khóa chính kép

    FOREIGN KEY (EmpId) REFERENCES Employees(empID),
    FOREIGN KEY (ShiftId) REFERENCES Shifts(shiftID)
)
```
**Tên bảng N-N = [Tên mối quan hệ].**

**LƯU Ý**
> **Thấy Ovan kép (phone):** Bắt buộc tách bảng `Employeesphone`.
   **Thấy hình thoi (works) nối N-N:** Bắt buộc tách bảng `works`.
  **Thấy thuộc tính phức hợp (address):** Phải rã ra thành các cột nhỏ (`street`, `city`) ngay trong bảng chính chứ không tạo bảng mới.

---

### 22. Phân biệt 3 kiểu SELECT

| Kiểu lệnh                | Mục đích                   | Kết quả                     |
| ------------------------ | -------------------------- | --------------------------- |
| **`SELECT @Biên = Cột`** | **Gán** giá trị vào biến   | Ẩn (dùng để tính toán tiếp) |
| **`SELECT 1`**           | **Check** tồn tại (EXISTS) | Trả về số 1 (nhẹ, nhanh)    |
| **`SELECT *`**           | **Xem** dữ liệu            | Hiện toàn bộ bảng kết quả   |

1. **Gán biến (Dùng trong Store/Trigger):**
```sql
SELECT @Ten = FullName FROM Employees WHERE id = 1
-- Lấy cái FullName cất vào biến @Ten

```

2. **Check tồn tại (Dùng trong IF):**
```sql
IF EXISTS (SELECT 1 FROM Employees WHERE id = 1)
-- Chỉ cần biết có dòng đó hay không, không cần lấy dữ liệu

```

3. **Xem dữ liệu (Dùng khi Query):**
```sql
SELECT * FROM Employees
-- Show hết cả bảng ra màn hình

```

---

## 23. So sánh DATE (Ngày tháng)

```sql
-- 1. So sánh trực tiếp (như số)
SELECT * FROM Employees 
WHERE hireDate > '2021-01-01' -- Sau ngày 01/01/2021

-- 2. Lọc theo Năm, Tháng, Ngày lẻ
SELECT * FROM Employees 
WHERE YEAR(hireDate) = 2021 -- Đúng năm 2021
  AND MONTH(hireDate) = 3   -- Đúng tháng 3

-- 3. Tính khoảng cách thời gian (DATEDIFF)
-- Cú pháp: DATEDIFF(đơn vị, ngày_xa, ngày_gần)
SELECT * FROM Employees 
WHERE DATEDIFF(YEAR, hireDate, GETDATE()) >= 5 -- Làm việc từ 5 năm trở lên

-- 4. Lọc trong khoảng (BETWEEN)
SELECT * FROM Shifts 
WHERE shiftDate BETWEEN '2026-03-01' AND '2026-03-15' -- Từ mùng 1 đến 15

```

> [!tip] Định dạng chuẩn: `'YYYY-MM-DD'` (Năm-Tháng-Ngày)

---

## 24. ORDER BY - Sắp xếp - lấy TOP

**Sắp xếp tăng dần (Mặc định)**
```sql
-- ASC: Thấp -> Cao, A -> Z, Cũ -> Mới
SELECT * FROM Employees 
ORDER BY Salary ASC 
```
**Sắp xếp giảm dần**
```sql
-- DESC: Cao -> Thấp, Z -> A, Mới -> Cũ
SELECT * FROM Employees 
ORDER BY Salary DESC 
```
**Sắp xếp nhiều tiêu chí**
```sql
-- Ưu tiên cột trước, nếu bằng nhau thì xét cột sau
SELECT * FROM Employees 
ORDER BY Role ASC, Salary DESC 
-- Giải thích: Xếp theo Chức vụ (A-Z), nếu trùng chức vụ thì ai lương cao đứng trước.
```
**Kết hợp với TOP**
```sql
-- Ví dụ: Lấy 3 nhân viên lương cao nhất
SELECT TOP 3 * FROM Employees 
ORDER BY Salary DESC 

```

> [!danger] Thứ tự "bất di bất dịch"
> **SELECT** → **FROM** → **WHERE** → **GROUP BY** → **HAVING** → **ORDER BY** (Luôn đứng bét bảng).

---

## 25. LIKE - Tìm kiếm theo mẫu (Pattern Matching)

**Dấu % (Đại diện cho 0, 1 hoặc nhiều ký tự)**

```sql
SELECT * FROM Customers WHERE CustomerName LIKE 'a%'    -- Bắt đầu bằng 'a'
SELECT * FROM Customers WHERE CustomerName LIKE '%a'    -- Kết thúc bằng 'a'
SELECT * FROM Customers WHERE CustomerName LIKE '%or%'  -- Chứa 'or' ở bất kỳ đâu
SELECT * FROM Customers WHERE CustomerName LIKE 'a%s'   -- Bắt đầu 'a' và kết thúc 's'
```
- % = chuỗi ký tự kéo dài
**Dấu _ (Đại diện cho DUY NHẤT 1 ký tự)**
```sql
SELECT * FROM Customers WHERE City LIKE 'L_nd__'       -- Khớp 'London' (L + 1 ký tự + nd + 2 ký tự)
SELECT * FROM Customers WHERE CustomerName LIKE '_r%'  -- Chữ thứ hai phải là 'r'
SELECT * FROM Customers WHERE CustomerName LIKE 'a__%' -- Bắt đầu bằng 'a' và dài ít nhất 3 ký tự
```
- `_` = 1 ký tự bất kỳ
**Dấu [] (Tìm theo nhóm hoặc khoảng ký tự)**
```sql
-- 3. Dấu [] (Tìm theo nhóm hoặc khoảng ký tự)
SELECT * FROM Customers WHERE City LIKE '[bsp]%'       -- Bắt đầu bằng 'b', 's', hoặc 'p'
SELECT * FROM Customers WHERE City LIKE '[a-c]%'       -- Bắt đầu từ 'a' đến 'c'
SELECT * FROM Customers WHERE City LIKE '[!bsp]%'      -- KHÔNG bắt đầu bằng 'b', 's', hoặc 'p' (Dùng ! hoặc ^)
```
- `[]` tìm theo nhóm
**Tìm kiếm chính xác (Không dùng wildcard)**
```sql
-- 4. Tìm kiếm chính xác (Không dùng wildcard)
SELECT * FROM Customers WHERE Country LIKE 'Spain'     -- Giống hệt toán tử '='

```
- giống hệt `=`


---


## 26. BETWEEN - Chọn giá trị trong khoảng

**Với số (Tìm sản phẩm giá từ 10 đến 20)**
```sql
-- Lưu ý: BETWEEN ở SQL Server lấy cả 10 và 20 (Inclusive)
SELECT * FROM Products
WHERE Price BETWEEN 10 AND 20
```
**Với ngày tháng (Tìm đơn hàng trong tháng 07/1996)**
```sql
-- 2. 
SELECT * FROM Orders
WHERE OrderDate BETWEEN '1996-07-01' AND '1996-07-31'
```
**Với chuỗi văn bản (Sắp xếp theo Danh sách theo chữ cái)**
```sql
-- 3. Với chuỗi văn bản (Sắp xếp theo bảng chữ cái)
SELECT * FROM Products
WHERE ProductName BETWEEN 'Geitost' AND 'Louisiana'
ORDER BY ProductName
```
**Kết hợp phủ định (Lấy các giá trị nằm NGOÀI khoảng)**
```sql
-- 4. Kết hợp phủ định (Lấy các giá trị nằm NGOÀI khoảng)
SELECT * FROM Products
WHERE Price NOT BETWEEN 10 AND 20
```
**Kết hợp với IN (Lọc khoảng giá VÀ thuộc nhóm ID nhất định)**
```sql
-- 5. 
SELECT * FROM Products
WHERE Price BETWEEN 10 AND 20
AND CategoryID IN (1, 2, 3)

```

---


## 27. COUNT
 **ĐẾM TOÀN BỘ (Dùng khi muốn biết tổng số lượng)**
```sql
-- 
SELECT COUNT(*) AS total_records 
FROM university; 
```
```
-- Giải thích: Trả về một con số duy nhất là tổng số dòng trong bảng.
```
**ĐẾM THEO NHÓM**
```sql
-- 2. 
SELECT 
    system_id, 
    COUNT(id) AS numberOfCriteria 
FROM ranking_criteria
GROUP BY system_id; 
```
```
-- Giải thích: 
-- + SELECT: Chọn cột muốn hiện và hàm đếm.
-- + COUNT(id): Đếm số lượng tiêu chí.
-- + AS: Đặt tên cột là 'numberOfCriteria' theo yêu cầu đề.
-- + GROUP BY: Bắt buộc phải có để gom nhóm theo ID hệ thống.

```
**ĐẾM CÓ ĐIỀU KIỆN (Dùng lọc nhóm sau khi đếm)**
```sql
-- 
SELECT 
    university_id, 
    COUNT(ranking_criteria_id) AS total_ranks
FROM university_ranking_year
GROUP BY university_id
HAVING COUNT(ranking_criteria_id) > 5;

```
```
-- Giải thích: 
-- + HAVING: Chỉ lấy những trường đại học có hơn 5 tiêu chí xếp hạng.
```

---
## 28. Subquery trong WHERE

```sql
-- Lấy nhân viên có lương cao hơn mức lương trung bình
SELECT * FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees)
```

```sql
-- Lấy client có tài khoản tồn tại
SELECT * FROM Clients
WHERE Id IN (SELECT ClientId FROM Accounts)
```

> ⚠️ Dùng `=` khi subquery trả về **1 giá trị**, dùng `IN` khi trả về **nhiều dòng**

---

## 29. DELETE — Xóa dữ liệu

```sql
DELETE FROM TenBang
WHERE DieuKien
```

> ⚠️ **Luôn có WHERE** — không có WHERE sẽ xóa **toàn bộ** bảng

**Xóa liên quan FK — phải xóa bảng CON trước**
```sql
-- ❌ Sai: xóa Clients trước khi xóa Accounts → lỗi FK
DELETE FROM Clients WHERE Id = 5

-- ✅ Đúng: xóa bảng con trước, bảng cha sau
DELETE FROM Accounts WHERE ClientId = 5
DELETE FROM Clients  WHERE Id = 5
```

> ⚠️ Bảng có **FK trỏ vào** = bảng cha → phải xóa sau cùng

|                | `DELETE`               | `TRUNCATE`          | `DROP`               |
| -------------- | ---------------------- | ------------------- | -------------------- |
| Xóa gì         | Từng dòng có điều kiện | Toàn bộ dữ liệu     | Cả bảng lẫn cấu trúc |
| WHERE          | ✅ Có                   | ❌ Không             | ❌ Không              |
| Rollback được  | ✅ Có                   | ✅ Có                | ❌ Không              |
| IDENTITY reset | ❌ Không                | ✅ Reset về 1        | ❌ Không còn bảng     |
| Khi nào dùng   | Xóa có chọn lọc        | Xóa sạch để làm lại | Bỏ hẳn bảng          |

---

## 30. Stored Procedure — Nâng cao

### 30.1 DROP + CREATE — Cách chuẩn khi đi thi

```sql
-- Bước 1: Xóa nếu đã tồn tại
IF OBJECT_ID('proc_TenProcedure', 'P') IS NOT NULL
    DROP PROCEDURE proc_TenProcedure
GO

-- Bước 2: Tạo mới
CREATE PROCEDURE proc_TenProcedure
    @Store_id INT,
    @SumQuantity DECIMAL(10,2) OUTPUT
AS
BEGIN
    SELECT @SumQuantity = SUM(st.quantity)
    FROM stocks st
    WHERE st.store_id = @Store_id
END
GO
```

> ⚠️ `GO` bắt buộc phải có giữa `DROP` và `CREATE` — SQL Server yêu cầu `CREATE PROCEDURE` phải là lệnh đầu tiên trong 1 batch

---

### 30.2 OUTPUT — Tham số đầu ra

```sql
CREATE PROCEDURE proc_SumQuantityProduct
    @Store_id INT,              -- tham số đầu vào
    @SumQuantity DECIMAL(10,2) OUTPUT  -- tham số đầu ra
AS
BEGIN
    SELECT @SumQuantity = SUM(st.quantity)
    FROM stocks st
    WHERE st.store_id = @Store_id
END
```

**Cách gọi:**

```sql
DECLARE @KetQua DECIMAL(10,2)

EXEC proc_SumQuantityProduct 
    @Store_id = 2, 
    @SumQuantity = @KetQua OUTPUT  -- phải ghi OUTPUT khi gọi

SELECT @KetQua AS TongSoLuong
```

> ⚠️ Khi gọi EXEC cũng phải ghi `OUTPUT` — thiếu chữ này biến `@KetQua` sẽ luôn NULL

---

### 30.3 Debug bằng PRINT

```sql
-- Chèn vào trong Procedure để kiểm tra
PRINT 'StoreID: ' + CAST(@Store_id AS NVARCHAR)
PRINT 'Tong: ' + ISNULL(CAST(@SumQuantity AS NVARCHAR), 'NULL')
--              ^ISNULL dùng để tránh in ra trống khi biến bị NULL
```

|Kết quả PRINT|Ý nghĩa|
|---|---|
|Hiện đúng số|Logic trong Proc chuẩn|
|Hiện `NULL`|Điều kiện `WHERE` không khớp dòng nào|

> ✅ Kết quả PRINT hiện ở tab **Messages**, không phải tab **Results**

---

### 30.4 Debug — Quy trình chuẩn 3 bước

**Bước 1: Chạy SELECT thô để biết con số kỳ vọng**

```sql
SELECT SUM(quantity) FROM stocks WHERE store_id = 2
-- Ghi nhớ con số này → đây là đáp án đúng
```

**Bước 2: Gọi Proc + kiểm tra OUTPUT**

```sql
DECLARE @KetQua DECIMAL(10,2)
EXEC proc_SumQuantityProduct @Store_id = 2, @SumQuantity = @KetQua OUTPUT

IF @KetQua IS NULL
    SELECT 'Loi: NULL, kiem tra lai WHERE' AS Status
ELSE
    SELECT @KetQua AS KetQuaThanhCong
```

**Bước 3: Dọn dẹp trước khi nộp**

```sql
-- Xóa hết các dòng PRINT
-- Xóa khối IF...DROP
-- Chỉ giữ lại đúng 1 khối CREATE PROCEDURE...END
```

---

### 30.5 Lỗi hay gặp khi thi

|Triệu chứng|Nguyên nhân|Cách fix|
|---|---|---|
|Biến OUTPUT luôn NULL|Thiếu chữ `OUTPUT` khi gọi EXEC|Thêm `OUTPUT` sau tên biến|
|Không thấy bảng kết quả|Tab Results bị ẩn|Nhấn `Ctrl + R`|
|Gạch đỏ dưới tên Proc|Lỗi hiển thị của SSMS|Cứ chạy, không ảnh hưởng|
|`CREATE` báo lỗi|Thiếu `GO` giữa DROP và CREATE|Thêm `GO` vào giữa|

---



# References








