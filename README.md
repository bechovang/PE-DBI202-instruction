# 📘 PE-DBI202 - Practical Exam Instruction

> **Tài liệu hướng dẫn ôn tập chi tiết cho kỳ thi Practical Exam DBI202 - Database Design**
>
> Môn: DBI202 - Thiết kế Cơ sở Dữ liệu

---

## 📋 Table of Contents

- [About](#about)
- [Features](#features)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Document Structure](#document-structure)
- [How to Use](#how-to-use)
- [Exam Preparation Guide](#exam-preparation-guide)
- [Common SQL Patterns](#common-sql-patterns)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

---

## 🎯 About

**PE-DBI202** là kho tài liệu tổng hợp dành cho sinh viên FPT University chuẩn bị cho kỳ thi Practical Exam của môn DBI202 (Database Design). Tài liệu bao gồm:

- Đề thi thực hành từ các năm trước (Paper 1, 2, 5, 10, 11, 112131...)
- Hướng dẫn chi tiết tư duy khi đọc đề bài
- Coding guide từng câu hỏi với phân tích bước-by-step
- Template cú pháp SQL tổng hợp
- Đáp án tham khảo cho một số đề thi

### Database System

- **RDBMS**: Microsoft SQL Server / SQL Server Management Studio (SSMS)
- **SQL Version**: T-SQL (Transact-SQL)

---

## ✨ Features

### 📚 Multiple Exam Papers

| Paper | Description | Status |
|-------|-------------|--------|
| Paper 1 | Car Service Management System | ✅ Full Guide |
| Paper 2 | Car Service Management System | ✅ Full Guide + Answers |
| Paper 5 | Restaurant Management System | ✅ Full Guide |
| Paper 10 | Restaurant Management System | ✅ Full Guide |
| Paper 11 | Restaurant Management System | ✅ Full Guide |
| Paper 112131 | Banking System | ✅ Full Guide |

### 📖 Comprehensive Documentation

- **CODING_GUIDE.md**: Hướng dẫn chi tiết từng câu hỏi
  - Tư duy khi đọc đề
  - Phân tích yêu cầu
  - Code giải mẫu với giải thích
  - Tips & Tricks tránh bẫy

- **syntax_template.md**: Tổng hợp cú pháp SQL
  - 18 phần từ cơ bản đến nâng cao
  - Template sẵn dùng cho từng dạng bài
  - Keyword mapping từ tiếng Anh sang SQL

### 🎯 Learning Resources

- Step-by-step problem solving approach
- ERD diagram analysis
- SQL query patterns and templates
- Common mistakes to avoid
- Quick reference for exam day

---

## 📁 Project Structure

```
PE-DBI202-instruction/
├── README.md                          # File này
├── .gitignore                         # Git ignore file
├── PROMPT.txt                         # Lịch sử phát triển tài liệu
├── syntax_template.md                 # Template cú pháp SQL tổng hợp
│
├── DBI202 - PE - FA25 - 1/            # Paper 1
│   ├── CODING_GUIDE.md                # Hướng dẫn chi tiết
│   ├── debai.txt                      # Đề bài
│   ├── debai.pdf                      # Đề bài (PDF)
│   ├── Given.rar                      # Database script
│   └── dap an tham khao/             # Đáp án tham khảo
│       └── DBI202_01/
│           ├── Q1.sql, Q2.sql, ...
│
├── DBI202 - PE - FA25 - 2/            # Paper 2
│   ├── CODING_GUIDE.md                # Hướng dẫn chi tiết
│   ├── SYNTAX.md                       # Bảng tóm tắt cú pháp
│   ├── debai.txt                      # Đề bài
│   ├── debai.pdf                      # Đề bài (PDF)
│   ├── Given.rar                      # Database script
│   └── Given/
│       └── DBI2/
│           ├── Q1.sql, Q2.sql, ...   # Script tạo database
│
├── DBI202 - FA25 - PE - Đề số 5/     # Paper 5
│   ├── CODING_GUIDE.md                # Restaurant System
│   ├── debai.txt                      # Đề bài
│   └── debai.pdf                      # Đề bài (PDF)
│
├── DBI202 - FA25 - PE - Đề 10/       # Paper 10
│   ├── CODING_GUIDE.md                # Restaurant System
│   ├── debai.txt                      # Đề bài
│   ├── debai.pdf                      # Đề bài (PDF)
│   ├── Given.rar                      # Database script
│   └── *.webp                         # Ảnh đề bài
│
├── DBI202 - FA25 - PE - Đề số 11/     # Paper 11
│   ├── CODING_GUIDE.md                # Restaurant System
│   ├── debai.txt                      # Đề bài
│   └── debai.pdf                      # Đề bài (PDF)
│
├── DBI202 - PE - FA25 - 112131/       # Paper 112131
│   ├── CODING_GUIDE.md                # Banking System
│   ├── debai.txt                      # Đề bài
│   └── debai.pdf                      # Đề bài (PDF)
│
└── webp_to_pdf.py                    # Tool chuyển webp → pdf
```

---

## 🚀 Getting Started

### Prerequisites

- **Software**: SQL Server Management Studio (SSMS)
- **Knowledge**: Basic SQL, Database Design concepts
- **Time**: Recommend studying at least 1 week before exam

### Installation

1. **Clone repository**
   ```bash
   git clone <repository-url>
   cd PE-DBI202-instruction
   ```

2. **Extract database scripts**
   - Mở folder `Given.rar` trong từng đề
   - Extract để lấy `.sql` file

3. **Setup database**
   ```sql
   -- Chạy script tạo database
   -- File thường nằm trong Given/DBI2/Q1.sql
   ```

---

## 📖 Document Structure

### CODING_GUIDE.md Structure

Mỗi file `CODING_GUIDE.md` được cấu trúc như sau:

```
┌─────────────────────────────────────────────────────────────┐
│  PHẦN 1: TƯ DUY KHI ĐỌC ĐỀ BÀI                                   │
│  - Quy trình đọc đề                                          │
│  - Từ vựng quan trọng                                       │
│  - Mapping từ khóa → SQL                                    │
├─────────────────────────────────────────────────────────────┤
│  PHẦN 2: ERD DIAGRAM                                          │
│  - Cách đọc ERD                                             │
│  - Physical Database Schema                                  │
│  - Quy tắc chuyển ERD sang TABLE                            │
├─────────────────────────────────────────────────────────────┤
│  PHẦN 3: TỪNG CÂU HỎI - PHÂN TÍCH & GIẢI                        │
│  - Question 1: CREATE TABLE                                 │
│  - Question 2-10: Với từng câu                              │
│    + Đọc đề                                                 │
│    + Tư duy                                                 │
│    + Phân tích                                              │
│    + Code mẫu                                               │
│    + Tips                                                   │
├─────────────────────────────────────────────────────────────┤
│  PHẦN 4-10: TỔNG HỢP, CHECKLIST, MẸO, FAQ, TRICKS               │
└─────────────────────────────────────────────────────────────┘
```

### syntax_template.md Structure

```
1. CREATE DATABASE & TABLES
2. SELECT Statements
3. JOIN Operations
4. AGGREGATE Functions
5. GROUP BY & HAVING
6. LIKE Patterns              ← MỚI THÊM
7. Date Functions             ← MỚI CẬP NHẬT
8. Subqueries
9. CTE (Common Table Expression)
10. Stored Procedures
11. Functions
12. Triggers
13. Views
14. Transactions & Error Handling
15. Data Manipulation
16. Keyword Mapping
17. ERD to Table Conversion   ← MỚI THÊM
18. Common Patterns            ← MỚI THÊM
```

---

## 📝 How to Use

### For Exam Preparation

1. **Bước 1: Học lý thuyết (1-2 ngày)**
   - Đọc `syntax_template.md` để nắm cú pháp cơ bản
   - Thực hành các câu SQL cơ bản

2. **Bước 2: Luyện đề (3-5 ngày)**
   - Làm từng đề từ Paper 1 → Paper 11
   - Đọc CODING_GUIDE.md của từng đề
   - So sánh với đáp án tham khảo
   - Rút kinh nghiệm cho từng dạng bài

3. **Bước 3: Ôn tập (1-2 ngày)**
   - Review `syntax_template.md` - Quick Reference
   - Review các Common Patterns
   - Đọc lại Traps & Tricks

### During Exam

1. **Đọc đề kỹ 2 lần**
   - Lần 1: Hiểu yêu cầu tổng thể
   - Lần 2: Ghi chú các từ khóa quan trọng

2. **Áp dụng tư duy 3 bước**
   ```
   CÂU HỎI → PHÂN TÍCH → ĐỊNH DANH BẢNG → VIẾT SQL
   ```

3. **Trước khi nộp**
   - Check lại output column
   - Check data type
   - Check PK, FK
   - Clean test code

---

## 🎓 Exam Preparation Guide

### Dạng bài thường gặp

| Câu hỏi | Dạng bài | Điểm | Cú pháp chính |
|---------|----------|-------|----------------|
| Q1 | CREATE TABLE | 2.0 | CREATE TABLE, PK, FK |
| Q2 | SELECT WHERE | 1.0 | SELECT, WHERE, OR/AND |
| Q3 | JOIN + DISTINCT | 1.0 | JOIN, DISTINCT |
| Q4 | LEFT JOIN + Date | 1.0 | LEFT JOIN, YEAR(), MONTH() |
| Q5 | LEFT JOIN + Aggregate | 1.0 | LEFT JOIN, COUNT(), SUM(), ISNULL() |
| Q6 | Below/Above Average | 1.0 | CTE, AVG(), subquery |
| Q7 | Multi-Year Analysis | 1.0 | Multiple CTE, INNER JOIN, percentage |
| Q8 | Stored Procedure | 0.5 | CREATE PROCEDURE, CTE 12 months |
| Q9 | Trigger | 0.5 | CREATE TRIGGER, inserted, deleted |
| Q10 | INSERT + Subquery | 0.5 | INSERT, SELECT subquery |

### Submission Rules

```
┌─────────────────────────────────────────────────────────────┐
│  ✅ Folder naming: RollNo_Name_DBI202_XX                    │
│     Ví dụ: se01245_LongNT_DBI202_01                         │
│                                                             │
│  ✅ File naming: Q1.sql, Q2.sql, ..., Q10.sql                │
│                                                             │
│  ✅ KHÔNG tạo subfolder                                      │
│                                                             │
│  ✅ KHÔNG dùng CREATE DATABASE (trừ Q1)                       │
│                                                             │
│  ✅ KHÔNG dùng USE database                                   │
│                                                             │
│  ✅ KHÔNG dùng GO, EXEC (trong file nộp)                     │
│                                                             │
│  ✅ Chỉ chứa câu lệnh trả lời (không test code)               │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔧 Common SQL Patterns

### Pattern 1: LEFT JOIN + Aggregate

**Khi đề nói**: "include even if no/NULL"

```sql
SELECT
    c.CustomerID,
    c.FullName,
    ISNULL(COUNT(o.OrderID), 0) AS NumberOfOrders,
    ISNULL(SUM(o.TotalAmount), 0) AS TotalAmount
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
    AND o.Status = 'Completed'        -- Trong ON!
    AND YEAR(o.PaymentTime) = 2025   -- Trong ON!
GROUP BY c.CustomerID, c.FullName;
```

### Pattern 2: Below/Above Average

**Khi đề nói**: "below the average of ALL items"

```sql
WITH AllSales AS (
    SELECT mi.ItemID, mi.ItemName,
           ISNULL(SUM(od.Quantity * od.Price), 0) AS TotalAmount
    FROM MenuItems mi
    LEFT JOIN OrderDetails od ON mi.ItemID = od.ItemID
    LEFT JOIN Orders o ON od.OrderID = o.OrderID
    GROUP BY mi.ItemID, mi.ItemName
)
SELECT * FROM AllSales
WHERE TotalAmount < (SELECT AVG(TotalAmount) FROM AllSales);
```

### Pattern 3: Monthly Report (12 Months)

**Khi cần**: Report hiển thị đủ 12 tháng

```sql
CREATE PROCEDURE MonthlySalesSummary @year INT
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
    LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID
    GROUP BY m.Month
    ORDER BY m.Month;
END;
```

### Pattern 4: Trigger Update TotalAmount

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

---

## ⚠️ Troubleshooting

### Common Mistakes

| Bẫy | VD | Cách tránh |
|-----|----|------------|
| Sai data type | `INT` thay vì `DECIMAL` | Xem kỹ ERD |
| Quên DISTINCT | Duplicate rows | `DISTINCT` |
| WHERE thay HAVING | `WHERE COUNT(*) >= 3` | Dùng `HAVING` |
| Sai điều kiện LEFT JOIN | `WHERE` thay vì `ON` | Đặt điều kiện trong `ON` |
| Quên ISNULL | NULL trong kết quả | `ISNULL(SUM(), 0)` |
| Quên N cho unicode | `FullName = 'Nguyễn'` | `N'Nguyễn'` |
| Quên ROUND | Số thập phân dài | `ROUND(value, 2)` |
| Quên ngoặc OR/AND | `WHERE A OR B AND C` | `WHERE (A OR B) AND C` |

### Error Messages

```
❌ "Cannot insert duplicate key"
   → Check Primary Key constraint

❌ "Invalid column name"
   → Check column spelling

❌ "Ambiguous column name"
   → Dùng table alias: t1.col1

❌ "Must declare the scalar variable"
   → Khai báo biến trong Procedure
```

---

## 🤝 Contributing

### How to Add New Exam Papers

1. Tạo folder mới theo format: `DBI202 - FA25 - PE - Đề số XX/`
2. Thêm các file:
   - `debai.txt` hoặc `debai.pdf`
   - `CODING_GUIDE.md` (theo template)
   - `Given.rar` (database script)

### Adding New Coding Guides

Sử dụng template từ `DBI202 - PE - FA25 - 2/CODING_GUIDE.md`

---

## 📄 License

This project is for educational purposes only.

---

## 🙏 Acknowledgments

- FPT University - DBI202 Course
- All contributors who helped improve this documentation

---

**Made with ❤️ for DBI202 Students**

**Good luck with your exam! 🎉**

---

## 📞 Contact

For questions or suggestions, please open an issue in this repository.

---

*Last updated: 2025-03-05*
