# DBI202 - CODING GUIDE - Bank Management System
## Paper 112131 - Tư duy & Hướng dẫn chi tiết từng bước

---

## PHẦN 1: TƯ DUY KHI ĐỌC ĐỀ BÀI

### Step 1: Đọc đề bài - Đừng vội code! ⚠️

Khi nhận đề thi, hãy làm theo thứ tự sau:

```
┌─────────────────────────────────────────────────────────┐
│  1. Lướt qua toàn bộ đề (5 câu hỏi)                     │
│     → Hiểu xem bài thi hỏi CÁI GÌ                       │
│                                                          │
│  2. Xem ERD Diagram có sẵn                              │
│     → Xác định Client, AccountType                      │
│     → Cần thêm Account entity                           │
│                                                          │
│  3. Đọc kỹ phần SUBMISSION RULES                        │
│     → 2 files: .sql và .docx (ERD)                      │
│                                                          │
│  4. Bắt đầu làm từng câu một                             │
└─────────────────────────────────────────────────────────┘
```

### Step 2: Phân tích đề - Từ vựng quan trọng

| Từ khóa | Nghĩa | SQL thường dùng |
|---------|------|-----------------|
| "complete the ERD" | Hoàn chỉnh sơ đồ | Vẽ ERD |
| "create table(s)" | Tạo bảng | CREATE TABLE |
| "insert 5 data rows" | Chèn 5 dòng dữ liệu | INSERT INTO |
| "stored procedure" | Thủ tục lưu trữ | CREATE PROCEDURE |
| "withdraw money" | Rút tiền | UPDATE balance |
| "rollback" | Hoàn tác | ROLLBACK, BEGIN TRANSACTION |
| "raise an error" | Báo lỗi | RAISERROR, THROW |
| "trigger" | Trigger | CREATE TRIGGER |
| "view" | View | CREATE VIEW |
| "more than $300" | Lọc điều kiện | WHERE > 300, HAVING |
| "default value of 0" | Giá trị mặc định | DEFAULT 0 |
| "up to 15 digits, 2 decimal" | Kiểu dữ liệu | DECIMAL(15,2) |

### Step 3: Quy trình giải 1 câu hỏi

```
┌─────────────────────────────────────────────────────────────┐
│  CÂU HỎI → PHÂN TÍCH → ĐỊNH DANH BẢNG → VIẾT SQL → CHECK  │
└─────────────────────────────────────────────────────────────┘
     ↓          ↓            ↓             ↓          ↓
   Đọc       Cần         Entity nào?    Cú pháp      Có
   yêu cầu   output       Relationship?  nào?         đúng?
```

---

## PHẦN 2: ERD DIAGRAM - PHÂN TÍCH THỰC THỂ

### 2.1 ERD CÓ SẴN (Đề bài cho)

```
┌──────────────┐        ┌──────────────┐
│    Client    │        │ AccountType  │
├──────────────┤        ├──────────────┤
│ Id (PK)      │        │ Id (PK)      │
│ FirstName    │        │ Name         │
│ LastName     │        │              │
└──────────────┘        └──────────────┘
```

### 2.2 ERD SAU KHI HOÀN THIỆN (Câu 1)

```
┌──────────────┐
│    Client    │
├──────────────┤
│ Id (PK)      │
│ FirstName    │
│ LastName     │
└──────┬───────┘
       │ 1
       │
       │ has
       │
       │ N
┌──────▼───────┐
│   Account    │  ← Entity MỚI cần thêm
├──────────────┤
│ AccountId(PK)│
│ Balance      │
└──────┬───────┘
       │ N
       │
       │ of
       │
       │ 1
┌──────▼───────┐
│ AccountType  │
├──────────────┤
│ Id (PK)      │
│ Name         │
└──────────────┘
```

### 2.3 Phân tích mối quan hệ

| Mối quan hệ | Loại | Giải thích |
|-------------|------|------------|
| Client - Account | 1:N | 1 Client có nhiều Account |
| AccountType - Account | 1:N | 1 AccountType có nhiều Account |

---

## PHẦN 3: TỪNG CÂU HỎI - PHÂN TÍCH & GIẢI

---

## CÂU 1: HOÀN THIỆN ERD [2 điểm]

### Đọc đề
> "Complete the ERD according to the given details:
> - Each client can have many accounts.
> - Each account is of one account type.
> Each account has an ID and a balance..."

### Tư duy

```
Yêu cầu: Vẽ entity Account và các mối quan hệ
Input:   ERD có Client, AccountType
Output:  Entity Account + 2 mối quan hệ
```

### Phân tích

| Bước | Xác định |
|------|----------|
| 1. Entity mới | Account |
| 2. Attributes của Account | AccountId (PK), Balance |
| 3. Mối quan hệ 1 | Client -(1:N)-> Account (has) |
| 4. Mối quan hệ 2 | AccountType -(1:N)-> Account (of) |

### Hướng dẫn vẽ trong MS Word

```
1. Vẽ hình chữ nhật cho entity Account
2. Thêm attribute: AccountId (gạch chân = PK), Balance
3. Vẽ hình thoi cho relationship "has" giữa Client và Account
4. Vẽ hình thoi cho relationship "of" giữa AccountType và Account
5. Đánh số cardinality: 1 và N
```

### Chú ý về ký hiệu ERD

```
Hình chữ nhật          = Entity (Bảng)
Hình thoi              = Relationship (Mối quan hệ)
Chữ gạch chân          = Primary Key
Số 1 ở cuối            = One (Một bên)
Số N hoặc M ở cuối     = Many (Nhiều bên)
```

---

## CÂU 2: CREATE TABLE + INSERT [2 điểm]

### Đọc đề
> "From the complete ERD in question 1, write SQL statements to create the table(s) corresponding to the entity(ies) added to the diagram. Insert 5 appropriate data rows..."

### Tư duy

```
Yêu cầu: Tạo bảng Account + chèn 5 dòng dữ liệu
Input:   Entity Account từ câu 1
ĐK:      Balance: 15 digits, 2 decimal, default = 0
Output:  CREATE TABLE + 5 INSERT statements
```

### Phân tích

| Thành phần | Giá trị |
|------------|---------|
| Tên bảng | Account |
| Primary Key | AccountId |
| Columns | AccountId, Balance |
| Data type Balance | DECIMAL(15,2) hoặc NUMERIC(15,2) |
| Default value | 0 |
| Số dòng insert | 5 |

### Code

```sql
-- Tạo bảng Account
CREATE TABLE Account (
    AccountId INT PRIMARY KEY,
    Balance DECIMAL(15, 2) DEFAULT 0
);

-- Chèn 5 dòng dữ liệu
INSERT INTO Account (AccountId, Balance) VALUES (1, 1500.50);
INSERT INTO Account (AccountId, Balance) VALUES (2, 3250.00);
INSERT INTO Account (AccountId, Balance) VALUES (3, 500.75);
INSERT INTO Account (AccountId, Balance) VALUES (4, 0);
INSERT INTO Account (AccountId, Balance) VALUES (5, 10000.00);
```

### Phân tích DECIMAL(15,2)

```
DECIMAL(15,2) nghĩa là gì?
├─ Tổng cộng: 15 chữ số
├─ Số thập phân: 2 chữ số
└─ Số nguyên: 13 chữ số

Ví dụ: 1234567890123.45
         └─────────┘└─┘
           13 chữ số  2 chữ số
```

### Tips

```sql
-- Có thể chèn nhiều dòng cùng lúc (SQL Server 2008+)
INSERT INTO Account (AccountId, Balance) VALUES
(1, 1500.50),
(2, 3250.00),
(3, 500.75),
(4, 0),
(5, 10000.00);

-- Khi không nhập Balance, sẽ tự động là 0
INSERT INTO Account (AccountId) VALUES (6);  -- Balance = 0
```

---

## CÂU 3: STORED PROCEDURE - WITHDRAW [2 điểm]

### Đọc đề
> "Write a stored procedure to withdraw money from an account. In order for a withdrawal to be successful:
> - the amount to be withdrawn must be a positive number
> - the account ID must be valid
> - the balance of the account must not be lower than the amount to be withdrawn
> In case any criterion above is violated, rollback and/or raise an error."

### Tư duy

```
Yêu cầu: Tạo procedure rút tiền với validation
Input:   @AccountId, @Amount
Output:  Trừ balance (nếu hợp lệ) hoặc báo lỗi
Validation:
  1. Amount > 0
  2. AccountId tồn tại
  3. Balance >= Amount
```

### Phân tích

| Bước | Logic |
|------|-------|
| 1. Nhận param | @AccountId INT, @Amount DECIMAL(15,2) |
| 2. Check Amount > 0 | IF @Amount <= 0 → RAISERROR |
| 3. Check Account tồn tại | IF NOT EXISTS → RAISERROR |
| 4. Check Balance đủ | IF Balance < @Amount → RAISERROR |
| 5. Trừ tiền | UPDATE Account SET Balance -= @Amount |
| 6. Xử lý lỗi | BEGIN TRANSACTION + ROLLBACK |

### Code

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

### Cấu trúc TRY-CATCH trong SQL Server

```
BEGIN TRY
    -- Code có thể gây lỗi
END TRY
BEGIN CATCH
    -- Xử lý khi có lỗi
    ROLLBACK;
    THROW;
END CATCH
```

### Phân biệt RAISERROR vs THROW

| | RAISERROR | THROW |
|--|-----------|-------|
| Phiên bản | Cũ (SQL 2005+) | Mới (SQL 2012+) |
| Syntax | RAISERROR(msg, level, state) | THROW |
| Khuyến nghị | Dùng THROW | THROW |

### Test procedure (không nộp)

```sql
-- Test case 1: Rút tiền hợp lệ
EXEC sp_WithdrawMoney 1, 500.00;

-- Test case 2: Số tiền âm (sẽ báo lỗi)
EXEC sp_WithdrawMoney 1, -100.00;

-- Test case 3: Account không tồn tại
EXEC sp_WithdrawMoney 999, 100.00;

-- Test case 4: Không đủ tiền
EXEC sp_WithdrawMoney 1, 999999.00;
```

---

## CÂU 4: TABLE + TRIGGER [2 điểm]

### Đọc đề
> "Create a table NotificationEmails (Id, Recipient, Subject, Content). Add a trigger to the table containing information about accounts and create a new message whenever this accounts table is updated.
> - Recipient - AccountId
> - Subject - "Update on account: {AccountId}"
> - Content - "On {date} your balance was changed from {old balance} to {new balance}.""

### Tư duy

```
Yêu cầu: Tạo bảng NotificationEmails + Trigger khi Account cập nhật
Bảng 1:  NotificationEmails (Id, Recipient, Subject, Content)
Bảng 2:  Account (có sẵn)
Trigger:  Khi UPDATE Account → Insert vào NotificationEmails
```

### Phân tích

| Thành phần | Giá trị |
|------------|---------|
| Bảng mới | NotificationEmails |
| Columns | Id (PK), Recipient, Subject, Content |
| Trigger table | Account |
| Trigger event | UPDATE |
| Timing | AFTER UPDATE |
| Logic | Insert email notification |

### Code

```sql
-- Tạo bảng NotificationEmails
CREATE TABLE NotificationEmails (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Recipient INT,                    -- AccountId
    Subject NVARCHAR(255),
    Content NVARCHAR(MAX)
);

-- Tạo trigger
CREATE TRIGGER tr_Account_Update
ON Account
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @AccountId INT;
    DECLARE @OldBalance DECIMAL(15, 2);
    DECLARE @NewBalance DECIMAL(15, 2);
    DECLARE @CurrentDate NVARCHAR(50);

    -- Lấy thông tin từ bảng inserted và deleted
    SELECT
        @AccountId = i.AccountId,
        @NewBalance = i.Balance,
        @OldBalance = d.Balance
    FROM inserted i
    INNER JOIN deleted d ON i.AccountId = d.AccountId;

    -- Format ngày tháng
    SET @CurrentDate = CONVERT(NVARCHAR(50), GETDATE(), 105); -- dd-mm-yyyy

    -- Insert vào NotificationEmails
    INSERT INTO NotificationEmails (Recipient, Subject, Content)
    VALUES (
        @AccountId,
        'Update on account: ' + CAST(@AccountId AS NVARCHAR(10)),
        'On ' + @CurrentDate + ' your balance was changed from '
            + CAST(@OldBalance AS NVARCHAR(20)) + ' to '
            + CAST(@NewBalance AS NVARCHAR(20)) + '.'
    );
END;
```

### Phân tích bảng ảo trong Trigger

```
┌─────────────────────────────────────────────────────────┐
│  UPDATE TRIGGER - CÓ 2 BẢNG ẢO                          │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  deleted     inserted                                    │
│  ┌─────────┐  ┌─────────┐                               │
│  │ OLD     │  │ NEW     │                               │
│  │ data    │  │ data    │                               │
│  └─────────┘  └─────────┘                               │
│     Trước        Sau                                     │
│                                                          │
└─────────────────────────────────────────────────────────┘

Khi UPDATE Account:
  - deleted chứa dữ liệu CŨ (balance cũ)
  - inserted chứa dữ liệu MỚI (balance mới)
```

### Format ngày tháng trong SQL Server

```sql
-- Các style phổ biến
CONVERT(NVARCHAR, GETDATE(), 103)  -- dd/mm/yyyy
CONVERT(NVARCHAR, GETDATE(), 105)  -- dd-mm-yyyy
CONVERT(NVARCHAR, GETDATE(), 106)  -- dd mon yyyy
CONVERT(NVARCHAR, GETDATE(), 120)  -- yyyy-mm-dd hh:mm:ss
```

### Test trigger (không nộp)

```sql
-- Test: Cập nhật balance
UPDATE Account SET Balance = 1000 WHERE AccountId = 1;

-- Xem kết quả
SELECT * FROM NotificationEmails;
```

### Cú pháp IDENTITY

```sql
-- Id tự động tăng
Id INT PRIMARY KEY IDENTITY(1,1)
                           └─┬┘
         Bắt đầu từ 1, tăng mỗi lần 1
```

---

## CÂU 5: VIEW - CLIENTS RICH [2 điểm]

### Đọc đề
> "Create a view that displays the first names and last names of all clients who have more than $300 in total of all their accounts."

### Tư duy

```
Yêu cầu: Tạo view hiển thị khách có tổng balance > $300
Input:   Bảng Client, Account
Output:  FirstName, LastName
ĐK lọc:  SUM(Balance) > 300
Cần:     JOIN Client + Account + GROUP BY + HAVING
```

### Phân tích

| Bước | Xác định |
|------|----------|
| 1. Bảng cần | Client, Account |
| 2. Join condition | Client.Id = Account.ClientId (giả định có FK) |
| 3. Aggregate | SUM(Balance) |
| 4. Filter | HAVING SUM(Balance) > 300 |
| 5. Output | FirstName, LastName |

### ⚠️ LƯU Ý QUAN TRỌNG VỀ FOREIGN KEY

```
Đề bài NHỜ MN TẠO BẢNG Account trong câu 2
→ Cần thêm ClientId làm Foreign Key trong Account!
```

### Code (Cập nhật câu 2 - thêm ClientId)

```sql
-- TẠO LẠI bảng Account với ClientId
CREATE TABLE Account (
    AccountId INT PRIMARY KEY,
    ClientId INT,  -- ← Foreign Key đến Client
    Balance DECIMAL(15, 2) DEFAULT 0,
    FOREIGN KEY (ClientId) REFERENCES Client(Id)
);

-- Insert với ClientId
INSERT INTO Account (AccountId, ClientId, Balance) VALUES
(1, 1, 1500.50),
(2, 1, 2000.00),
(3, 2, 250.00),
(4, 3, 500.00),
(5, 4, 50.00);
```

### Code - View

```sql
CREATE VIEW vw_RichClients AS
SELECT
    c.FirstName,
    c.LastName
FROM Client c
JOIN Account a ON c.Id = a.ClientId
GROUP BY c.FirstName, c.LastName
HAVING SUM(a.Balance) > 300;
```

### Cấu trúc VIEW

```sql
CREATE VIEW [tên_view] AS
[SELECT statement];
```

### Test view (không nộp)

```sql
-- Gọi view như một table
SELECT * FROM vw_RichClients;

-- Hoặc thêm điều kiện
SELECT * FROM vw_RichClients
WHERE LastName = 'Smith';
```

### Phân biệt WHERE vs HAVING (lại nữa!)

```sql
-- WHERE: Lọc TRƯỚC khi group
SELECT * FROM Account WHERE Balance > 300;

-- HAVING: Lọc SAU khi group
SELECT ClientId, SUM(Balance)
FROM Account
GROUP BY ClientId
HAVING SUM(Balance) > 300;
```

---

## PHẦN 4: TỔNG HỢP SYNTAX CHO ĐỀ NÀY

### 4.1 DECIMAL/NUMERIC

```sql
-- DECIMAL(total_digits, decimal_places)
Balance DECIMAL(15, 2)  -- 1234567890123.45
Amount NUMERIC(10, 2)   -- 12345678.99
```

### 4.2 DEFAULT Value

```sql
CREATE TABLE Test (
    Id INT,
    Amount DECIMAL(10,2) DEFAULT 0
);
```

### 4.3 FOREIGN KEY

```sql
-- Cách 1: Tạo cùng lúc với bảng
CREATE TABLE Account (
    AccountId INT,
    ClientId INT,
    FOREIGN KEY (ClientId) REFERENCES Client(Id)
);

-- Cách 2: Sau khi tạo bảng
ALTER TABLE Account
ADD CONSTRAINT FK_Account_Client
FOREIGN KEY (ClientId) REFERENCES Client(Id);
```

### 4.4 TRY-CATCH-TRANSACTION

```sql
CREATE PROCEDURE proc_name
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Code chính
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
```

### 4.5 TRIGGER với UPDATE

```sql
CREATE TRIGGER trigger_name
ON table_name
AFTER UPDATE
AS
BEGIN
    -- inserted: NEW data
    -- deleted: OLD data
    INSERT INTO LogTable (Col)
    SELECT Col FROM inserted;
END;
```

### 4.6 VIEW

```sql
CREATE VIEW view_name AS
SELECT col1, col2, ...
FROM table1
JOIN table2 ON condition
WHERE condition;
```

---

## PHẦN 5: CHECKLIST TRƯỚC KHI NỘP

```
☐ File SQL: PE_DBI202_[RollNo].sql
☐ File ERD: PE_DBI202_[RollNo].docx
☐ Câu 1: Vẽ ERD đầy đủ trong Word
☐ Câu 2: CREATE TABLE có ClientId (FK)
☐ Câu 2: DECIMAL(15,2) DEFAULT 0
☐ Câu 2: 5 dòng INSERT đúng format
☐ Câu 3: Procedure có đầy đủ 3 validations
☐ Câu 3: Dùng TRY-CATCH hoặc kiểm tra IF
☐ Câu 4: NotificationEmails có đủ 4 columns
☐ Câu 4: Trigger dùng cả inserted và deleted
☐ Câu 5: View có JOIN + GROUP BY + HAVING
☐ Không có USE database
☐ Không có test code
```

---

## PHẦN 6: CÁCH LÀM BÀI THỰC CHIẾN

```
┌─────────────────────────────────────────────────────┐
│  BƯỚC 1: Mở MS Word → Vẽ ERD (Câu 1)                 │
│  → Vẽ Account entity + 2 relationships               │
├─────────────────────────────────────────────────────┤
│  BƯỚC 2: Mở SSMS → Viết SQL cho Câu 2                │
│  → CREATE TABLE Account (có FK ClientId!)            │
│  → 5 INSERT statements                               │
├─────────────────────────────────────────────────────┤
│  BƯỚC 3: Viết Procedure (Câu 3)                      │
│  → 3 validations + UPDATE + ROLLBACK                 │
├─────────────────────────────────────────────────────┤
│  BƯỚC 4: Tạo bảng + Trigger (Câu 4)                  │
│  → NotificationEmails + AFTER UPDATE trigger         │
├─────────────────────────────────────────────────────┤
│  BƯỚC 5: Tạo View (Câu 5)                            │
│  → JOIN + GROUP BY + HAVING > 300                    │
├─────────────────────────────────────────────────────┤
│  BƯỚC 6: Test tất cả                                 │
│  → Chạy từng câu, kiểm tra kết quả                   │
├─────────────────────────────────────────────────────┤
│  BƯỚC 7: Clean & Nộp                                 │
│  → Xóa test code, giữ lại câu trả lời                │
└─────────────────────────────────────────────────────┘
```

---

## PHẦN 7: FAQ - CÂU HỎI THƯỜNG GẶP

### Q1: Tại sao phải thêm ClientId vào Account?

```
Vì cần JOIN Client và Account để tính tổng balance
→ Nếu không có FK, không biết Account thuộc Client nào
```

### Q2: DECIMAL(15,2) khác MONEY như thế nào?

```
DECIMAL(15,2): Chính xác 2 số thập phân, phù hợp tiền tệ
MONEY:        Tự động 4 số thập phân, có thể làm tròn

→ Đề bài yêu cầu DECIMAL thì dùng DECIMAL!
```

### Q3: TRIGGER khi nào chạy?

```
AFTER UPDATE: Chay SAU KHI dữ liệu đã thay đổi
→ inserted chứa NEW data
→ deleted chứa OLD data
```

### Q4: HAVING > 300 hay WHERE Balance > 300?

```sql
-- ❌ SAI - WHERE không dùng với aggregate
WHERE SUM(Balance) > 300

-- ✅ ĐÚNG - HAVING dùng với aggregate
HAVING SUM(Balance) > 300
```

### Q5: Procedure cần RETURN không?

```
Không bắt buộc, nhưng nên dùng để thoát sớm khi validate fail
RETURN;
```

---

## PHẦN 8: TRICKS & TRAPS

### CÁC BẪY THƯỜNG GẶP

| Bẫy | VD | Cách tránh |
|-----|----|------------|
| Quên Foreign Key | Account không có ClientId | Thêm FK ClientId |
| Sai data type | INT thay vì DECIMAL(15,2) | Đọc kỹ đề |
| Quên DEFAULT 0 | Balance NULL khi insert | Thêm DEFAULT 0 |
| WHERE thay HAVING | WHERE SUM() > 300 | Dùng HAVING |
| Trigger chỉ đọc inserted | Không lấy old balance | Dùng cả inserted + deleted |
| View thiếu JOIN | Chỉ query từ Account | JOIN với Client |
| Subject sai format | "Update account 1" | "Update on account: 1" |

---

## PHẦN 9: FULL SOLUTION - THAM KHẢO

```sql
-- ==========================================
-- CÂU 2: CREATE TABLE + INSERT
-- ==========================================

CREATE TABLE Account (
    AccountId INT PRIMARY KEY,
    ClientId INT,
    Balance DECIMAL(15, 2) DEFAULT 0,
    FOREIGN KEY (ClientId) REFERENCES Client(Id)
);

INSERT INTO Account (AccountId, ClientId, Balance) VALUES
(1, 1, 1500.50),
(2, 1, 2000.00),
(3, 2, 250.00),
(4, 3, 500.00),
(5, 4, 50.00);

-- ==========================================
-- CÂU 3: STORED PROCEDURE
-- ==========================================

CREATE PROCEDURE sp_WithdrawMoney
    @AccountId INT,
    @Amount DECIMAL(15, 2)
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        IF @Amount <= 0
        BEGIN
            RAISERROR('Amount must be positive.', 16, 1);
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM Account WHERE AccountId = @AccountId)
        BEGIN
            RAISERROR('Account does not exist.', 16, 1);
            RETURN;
        END

        DECLARE @CurrentBalance DECIMAL(15, 2);
        SELECT @CurrentBalance = Balance FROM Account WHERE AccountId = @AccountId;

        IF @CurrentBalance < @Amount
        BEGIN
            RAISERROR('Insufficient balance.', 16, 1);
            RETURN;
        END

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

-- ==========================================
-- CÂU 4: TABLE + TRIGGER
-- ==========================================

CREATE TABLE NotificationEmails (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Recipient INT,
    Subject NVARCHAR(255),
    Content NVARCHAR(MAX)
);

CREATE TRIGGER tr_Account_Update
ON Account
AFTER UPDATE
AS
BEGIN
    INSERT INTO NotificationEmails (Recipient, Subject, Content)
    SELECT
        i.AccountId,
        'Update on account: ' + CAST(i.AccountId AS NVARCHAR(10)),
        'On ' + CONVERT(NVARCHAR, GETDATE(), 105) +
        ' your balance was changed from ' + CAST(d.Balance AS NVARCHAR(20)) +
        ' to ' + CAST(i.Balance AS NVARCHAR(20)) + '.'
    FROM inserted i
    INNER JOIN deleted d ON i.AccountId = d.AccountId;
END;

-- ==========================================
-- CÂU 5: VIEW
-- ==========================================

CREATE VIEW vw_RichClients AS
SELECT c.FirstName, c.LastName
FROM Client c
JOIN Account a ON c.Id = a.ClientId
GROUP BY c.FirstName, c.LastName
HAVING SUM(a.Balance) > 300;
```

---

**Chúc bạn thi tốt! 🎉**

Made for DBI202 - Bank Management System
