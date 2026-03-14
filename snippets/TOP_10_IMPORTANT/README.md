# 🎯 TOP 10 SQL SNIPPETS SKELETON
## Khung sườn linh hoạt cho nhiều dạng câu hỏi

---

## 📋 Danh sách 10 Snippet quan trọng nhất

| # | Shortcut | Tên Snippet | Câu hỏi thường | Điểm |
|---|----------|-------------|----------------|------|
| 1 | `ctfk` | Create Table + FK | Q1 | 1.5-2đ |
| 2 | `ctpk` | Create Table + Composite PK | Q1 | 1.5-2đ |
| 3 | `sel` | SELECT WHERE | Q2 | 0.5-1đ |
| 4 | `join` | Multi-Table JOIN | Q3, Q4 | 0.5-1đ |
| 5 | `lj` | LEFT JOIN Skeleton | Q4, Q5 | 1đ |
| 6 | `grp` | GROUP BY HAVING | Q3 | 1đ |
| 7 | `proc` | PROCEDURE Skeleton | Q6, Q8 | 0.5-1đ |
| 8 | `trig` | TRIGGER Skeleton | Q7, Q9 | 1đ |
| 9 | `cte` | CTE Skeleton | Q6, Q7 | 0.5-1đ |
| 10 | `delins` | DELETE/INSERT Skeleton | Q9, Q10 | 0.5đ |

---

## 🔧 CÀI ĐẶT CHỈ 10 SNIPPET NÀY

### Bước 1: Mở thư mục Code Snippets
```
Win + R → Gõ:
%ProgramFiles(x86)%\Microsoft SQL Server Management Studio 19\Code Snippets\SQL
```

### Bước 2: Copy 10 file .snippet vào thư mục trên

### Bước 3: Khởi động lại SSMS

### Bước 4: Gõ shortcut + Tab để dùng

---

## 📖 CHI TIẾT TỪNG SNIPPET

### 1️⃣ ctfk - Create Table + Foreign Key

**Shortcut:** `ctfk` + Tab

**Skeleton:**
```sql
CREATE TABLE $TableName$ (
    $PK$ INT PRIMARY KEY,
    $Col1$ $Type1$,
    $Col2$ $Type2$,
    $FK$ INT,
    FOREIGN KEY ($FK$) REFERENCES $RefTable$($RefCol$)
);
```

**Dùng cho:**
- Bảng có Foreign Key
- Orders, Reservations, InvoiceDetails...

---

### 2️⃣ ctpk - Create Table + Composite PK

**Shortcut:** `ctpk` + Tab

**Skeleton:**
```sql
CREATE TABLE $TableName$ (
    $Col1$ INT,
    $Col2$ INT,
    $Col3$ $Type3$,
    PRIMARY KEY ($Col1$, $Col2$),
    FOREIGN KEY ($Col1$) REFERENCES $RefTable1$($RefCol1$),
    FOREIGN KEY ($Col2$) REFERENCES $RefTable2$($RefCol2$)
);
```

**Dùng cho:**
- Junction table (N:N)
- OrderDetails, ReservationTables, OrderTables...

---

### 3️⃣ sel - SELECT WHERE Skeleton

**Shortcut:** `sel` + Tab

**Skeleton:**
```sql
SELECT $Col1$, $Col2$, $Col3$
FROM $Table$
WHERE $Condition$
ORDER BY $SortCol$ $Direction$;
```

**Biến thể:**
- Bỏ ORDER BY nếu không cần sắp xếp
- Thêm DISTINCT nếu cần loại trùng
- Thêm TOP n nếu cần giới hạn

---

### 4️⃣ join - Multi-Table JOIN Skeleton

**Shortcut:** `join` + Tab

**Skeleton:**
```sql
SELECT t1.$Col1$, t2.$Col2$, t3.$Col3$
FROM $Table1$ t1
JOIN $Table2$ t2 ON t1.$Join1$ = t2.$Join1$
JOIN $Table3$ t3 ON t2.$Join2$ = t3.$Join2$
WHERE $Condition$;
```

**Dùng cho:**
- JOIN 3+ bảng
- Customer → Order → OrderDetails → Product

---

### 5️⃣ lj - LEFT JOIN Skeleton

**Shortcut:** `lj` + Tab

**Skeleton:**
```sql
SELECT t1.$Col1$, t1.$Col2$,
       ISNULL(COUNT(t2.$ID$), 0) AS $CountAlias$,
       ISNULL(SUM(t2.$SumCol$), 0) AS $SumAlias$
FROM $Table1$ t1
LEFT JOIN $Table2$ t2 ON t1.$JoinCol$ = t2.$JoinCol$
    AND t2.$FilterCondition$
WHERE t1.$Condition$
GROUP BY t1.$Col1$, t1.$Col2$;
```

**⚠️ QUAN TRỌNG:**
- Điều kiện lọc bảng phải đặt trong `ON`
- Dùng `ISNULL(..., 0)` để thay NULL bằng 0

**Dùng cho:**
- "include even if no orders"
- "display 0 if no data"

---

### 6️⃣ grp - GROUP BY HAVING Skeleton

**Shortcut:** `grp` + Tab

**Skeleton:**
```sql
SELECT $GroupCol$, $AggFunc$($Col$) AS $Alias$
FROM $Table1$ t1
JOIN $Table2$ t2 ON t1.$Join$ = t2.$Join$
WHERE $RowFilter$
GROUP BY $GroupCol$
HAVING $AggFunc$($Col$) $Operator$ $Value$;
```

**Biến thể:**
- `COUNT(*)`, `SUM()`, `AVG()`, `MAX()`, `MIN()`
- `HAVING COUNT(*) >= 3`
- `HAVING SUM() > 1000`

---

### 7️⃣ proc - PROCEDURE Skeleton

**Shortcut:** `proc` + Tab

**Skeleton:**
```sql
CREATE PROCEDURE $ProcName$
    @Param1 $Type1$,
    @Param2 $Type2$ OUTPUT
AS
BEGIN
    -- Option 1: Return result set
    SELECT $Col1$, $Col2$
    FROM $Table$
    WHERE $Col$ = @Param1;

    -- Option 2: Return OUTPUT parameter
    SELECT @Param2 = $AggFunc$($Col$)
    FROM $Table$
    WHERE $Col$ = @Param1;
END;
```

**Dùng cho:**
- "count distinct belonging to"
- "calculate total of"
- Procedure trả về bảng hoặc output param

---

### 8️⃣ trig - TRIGGER Skeleton

**Shortcut:** `trig` + Tab

**Skeleton:**
```sql
CREATE TRIGGER $TriggerName$
ON $TableName$
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Option 1: Display data
    SELECT $Col1$, $Col2$
    FROM $TableName$
    WHERE $PK$ IN (SELECT $PK$ FROM inserted);

    -- Option 2: Update aggregate
    UPDATE p
    SET p.$Total$ = ISNULL((
        SELECT SUM(c.$Calc$)
        FROM $ChildTable$ c
        WHERE c.$FK$ = p.$PK$
    ), 0)
    FROM $ParentTable$ p
    WHERE p.$PK$ IN (
        SELECT $FK$ FROM inserted
        UNION
        SELECT $FK$ FROM deleted
    );

    -- Option 3: Insert into log table
    INSERT INTO $LogTable$ ($Col1$, $Col2$)
    SELECT $Val1$, $Val2$
    FROM inserted;
END;
```

**Bảng ảo:**
| Event | inserted | deleted |
|-------|-----------|---------|
| INSERT | NEW | Empty |
| UPDATE | NEW | OLD |
| DELETE | Empty | OLD |

**Dùng cho:**
- "after inserting... display..."
- "when... is updated... recalculate..."
- "create notification when..."

---

### 9️⃣ cte - CTE Skeleton

**Shortcut:** `cte` + Tab

**Skeleton:**
```sql
WITH $CTEName$ AS (
    SELECT $Col1$, $Col2$, $AggFunc$($Col3$) AS $Alias$
    FROM $Table$
    WHERE $Filter$
    GROUP BY $Col1$, $Col2$
)
SELECT *
FROM $CTEName$
WHERE $Alias$ $Operator$ ($Subquery$);
```

**Biến thể:**
```sql
-- Below Average
WHERE $Alias$ < (SELECT AVG($Alias$) FROM $CTEName$)

-- Top 1 per group
WHERE $Alias$ = (SELECT MAX($Alias$) FROM $CTEName$ c2 WHERE c2.$Group$ = $CTEName$.$Group$)

-- Percentage change (2 CTEs)
WITH CTE1 AS (...), CTE2 AS (...)
SELECT ... FROM CTE1 JOIN CTE2 ...
```

**Dùng cho:**
- "below average of all"
- "highest within each category"
- "percentage growth"
- Query phức tạp cần nhiều bước

---

### 🔟 delins - DELETE/INSERT Skeleton

**Shortcut:** `delins` + Tab

**Skeleton DELETE:**
```sql
DELETE FROM $Table$
WHERE $FK$ IN (
    SELECT $PK$
    FROM $RefTable$
    WHERE $Condition$
);
```

**Skeleton INSERT:**
```sql
INSERT INTO $Table$ ($Col1$, $Col2$)
SELECT $Val1$, MIN($Col2$)
FROM $SourceTable$
WHERE $Condition$;

-- Hoặc INSERT VALUES
INSERT INTO $Table$ ($Col1$, $Col2$, $Col3$)
VALUES ($Val1$, $Val2$, $Val3$);
```

**Skeleton UPDATE:**
```sql
UPDATE $Table$
SET $ColToUpdate$ = $NewValue$
WHERE $Condition$;
```

**Dùng cho:**
- "delete rows belonging to"
- "create a new reservation... assign to"
- "withdraw money" (UPDATE balance)

---

## 🎯 MAPPING: TỪ ĐỀ BÀI ĐẾN SNIPPET

| Câu hỏi thường thấy | Dùng snippet | Lưu ý |
|---------------------|--------------|-------|
| "Create table..." | `ctfk`, `ctpk` | Xem ERD để xác định FK |
| "Display/Show/Retrieve..." | `sel` | Xem cần WHERE không |
| "...in 2025", "between...and" | `sel` + thêm WHERE date | YEAR(), BETWEEN |
| "starts with...", "contains..." | `sel` + thêm LIKE | LIKE 'abc%', LIKE '%abc%' |
| "Count... greater than..." | `grp` | HAVING COUNT(*) >= n |
| "Most/Highest/Maximum..." | `top1` hoặc `cte` | TOP 1...ORDER DESC |
| "Even if no... include..." | `lj` | LEFT JOIN + ISNULL |
| "Within each category..." | `cte` + subquery | MAX trong group |
| "Below average of all..." | `cte` + AVG | CTE + subquery |
| "Percentage growth/change..." | `cte` × 2 | JOIN 2 CTEs |
| "Create stored procedure..." | `proc` | Có OUTPUT hoặc không |
| "Trigger... after insert/update" | `trig` | Xem inserted/deleted |
| "Delete rows..." | `delins` DELETE | DELETE với IN subquery |
| "Create new... assign to..." | `delins` INSERT | INSERT với SELECT |

---

## 📌 CÁC BIẾN THỂ THAY THẾ PHỔ BIẾN

### Aggregate Functions
```sql
$AggFunc$ → COUNT(*), SUM($Col$), AVG($Col$), MAX($Col$), MIN($Col$)
```

### Operators
```sql
$Operator$ → >=, <=, >, <, =, <>
```

### JOIN Types
```sql
JOIN → INNER JOIN (chỉ rows khớp)
LEFT JOIN → Tất cả rows bảng trái + NULL
```

### Data Types
```sql
$Type$ → INT, VARCHAR(n), NVARCHAR(n), DATE, DATETIME, DECIMAL(m,n), MONEY, BIT
```

---

## 💡 MẸO NHỚ

1. **Đọc đề kỹ** → Chọn snippet phù hợp
2. **Thay placeholder** → Điền tên bảng/cột thật
3. **Kiểm tra cú pháp** → F5 để chạy thử
4. **So sánh output** → Với yêu cầu đề bài
5. **Clean code** → Xóa phần không dùng trước nộp

---

**Good luck! 🍀**
