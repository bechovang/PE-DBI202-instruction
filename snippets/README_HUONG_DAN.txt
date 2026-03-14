# DBI202 - SQL SNIPPETS FOR SSMS
## Cách cài đặt và sử dụng trong SQL Server Management Studio

---

## 📂 DANH SÁC SNIPPETS (25 files)

| STT | File Snippet | Shortcut | Mô tả |
|-----|--------------|----------|-------|
| 1 | 01_create_table.snippet | ct | Tạo bảng không có FK |
| 2 | 02_create_table_fk.snippet | ctfk | Tạo bảng có Foreign Key |
| 3 | 03_create_table_composite.snippet | ctpk | Tạo bảng với Composite PK |
| 4 | 04_select_where.snippet | sel | SELECT WHERE cơ bản |
| 5 | 05_select_join.snippet | selj | SELECT INNER JOIN |
| 6 | 06_select_left_join.snippet | sellj | SELECT LEFT JOIN (bao gồm NULL) |
| 7 | 07_group_by_having.snippet | grp | GROUP BY HAVING |
| 8 | 08_top1_order.snippet | top1 | TOP 1 ORDER BY DESC |
| 9 | 09_stored_procedure.snippet | proc | CREATE PROCEDURE cơ bản |
| 10 | 10_procedure_output.snippet | proc_out | PROCEDURE với OUTPUT parameter |
| 11 | 11_trigger_insert.snippet | trig_ins | Trigger INSERT |
| 12 | 12_trigger_update.snippet | trig_upd | Trigger UPDATE |
| 13 | 13_trigger_all.snippet | trig_all | Trigger INSERT UPDATE DELETE |
| 14 | 14_function_table.snippet | func_tbl | Table-Valued Function |
| 15 | 15_cte.snippet | cte | CTE (Common Table Expression) |
| 16 | 16_left_join_isnull.snippet | lj_isnull | LEFT JOIN + ISNULL aggregate |
| 17 | 17_like_patterns.snippet | like | LIKE patterns |
| 18 | 18_date_filter.snippet | date | Filter ngày tháng |
| 19 | 19_percentage_change.snippet | perc | % tăng trưởng |
| 20 | 20_max_in_group.snippet | max_grp | MAX trong mỗi nhóm |
| 21 | 21_delete_subquery.snippet | delsub | DELETE với subquery |
| 22 | 22_insert_subquery.snippet | ins_sub | INSERT với subquery |
| 23 | 23_distinct_join.snippet | sel_dist | SELECT DISTINCT JOIN |
| 24 | 24_below_average.snippet | below_avg | Tìm giá trị dưới TB |
| 25 | 25_months_report.snippet | months | Procedure báo cáo 12 tháng |

---

## 🔧 CÁCH CÀI ĐẶT SNIPPET VÀO SSMS

### Phương pháp 1: Copy vào thư mục Code Snippets (Khuyên nghị)

1. **Mở Run Dialog:** Nhấn `Win + R`

2. **Gõ đường dẫn:**
   ```
   %ProgramFiles(x86)%\Microsoft SQL Server Management Studio 19\Code Snippets\SQL
   ```
   *(Thay 19 bằng phiên bản SSMS của bạn: 18, 19, 20...)*

3. **Copy tất cả file .snippet** vào thư mục này

4. **Khởi động lại SSMS**

---

### Phương pháp 2: Import thủ công trong SSMS

1. **Mở SSMS** → Tools → Code Snippets Manager...

2. **Chọn Language:** SQL

3. **Click Add...** → Chọn thư mục `snippets` chứa các file .snippet

4. **Click OK**

---

## 💻 CÁCH SỬ DỤNG SNIPPET

### Cách 1: Gõ Shortcut (Nhanh nhất)

1. Trong Query Editor, gõ **shortcut** (ví dụ: `ct`, `sel`, `proc`...)

2. Nhấn phím **Tab** (hoặc Tab + Tab)

3. Code snippet sẽ tự động xuất hiện!

**Ví dụ:**
```
ct + Tab  → Tạo khung CREATE TABLE
proc + Tab → Tạo khung CREATE PROCEDURE
```

---

### Cách 2: Sử dụng Code Snippets Manager

1. Chuột phải vào Query Editor → **Insert Snippet...** (hoặc Ctrl+K, Ctrl+X)

2. Chọn snippet từ danh sách

---

## 📌 VÍ DỤ SỬ DỤNG

### Ví dụ 1: Tạo bảng nhanh

**Gõ:** `ct + Tab`

**Kết quả:**
```sql
CREATE TABLE [TableName] (
    [PK_Column] INT PRIMARY KEY,
    [Column1] NVARCHAR(100),
    [Column2] INT
);
```

**Chỉ cần thay:**
- TableName → Customers
- PK_Column → CustomerID
- Column1 → FullName
- ...

---

### Ví dụ 2: LEFT JOIN với ISNULL

**Gõ:** `lj_isnull + Tab`

**Kết quả:**
```sql
SELECT t1.[Col1], t1.[Col2],
       ISNULL(COUNT(t2.[ID]), 0) AS [CountAlias],
       ISNULL(SUM(t2.[SumCol]), 0) AS [SumAlias]
FROM [Table1] t1
LEFT JOIN [Table2] t2 ON t1.[JoinCol1] = t2.[JoinCol2]
    AND t2.[FilterCondition]
WHERE t1.[Condition]
GROUP BY t1.[Col1], t1.[Col2];
```

---

### Ví dụ 3: Procedure với OUTPUT

**Gõ:** `proc_out + Tab`

**Kết quả:**
```sql
CREATE PROCEDURE [ProcName]
    @InputParam [InputType],
    @OutputParam [OutputType] OUTPUT
AS
BEGIN
    SELECT @OutputParam = COUNT(DISTINCT [Col])
    FROM [TableName]
    WHERE [Condition] = @InputParam;
END;
```

---

### Ví dụ 4: Tính % tăng trưởng

**Gõ:** `perc + Tab`

**Kết quả:**
```sql
WITH [Year1]Data AS (
    SELECT [ID], AVG([Col]) AS [Val1]
    FROM [TableName]
    WHERE YEAR([DateCol]) = [Year1] AND [Status] = 'Completed'
    GROUP BY [ID]
),
[Year2]Data AS (
    SELECT [ID], AVG([Col]) AS [Val2]
    FROM [TableName]
    WHERE YEAR([DateCol]) = [Year2] AND [Status] = 'Completed'
    GROUP BY [ID]
)
SELECT a.[ID], a.[Val1], b.[Val2],
       CAST(ROUND(((b.[Val2] - a.[Val1]) / a.[Val1] * 100), 2) AS NVARCHAR(20)) + '%' AS [PercentageChange]
FROM [Year1]Data a
JOIN [Year2]Data b ON a.[ID] = b.[ID];
```

---

## 🔍 DANH SÁC SHORTCUT NHỚ GỌN

| Shortcut | Công dụng |
|----------|-----------|
| ct | Create Table |
| ctfk | Create Table + FK |
| ctpk | Composite PK |
| sel | SELECT WHERE |
| selj | SELECT JOIN |
| sellj | LEFT JOIN |
| grp | GROUP BY HAVING |
| top1 | TOP 1 DESC |
| proc | Procedure |
| proc_out | Procedure OUTPUT |
| trig_ins | Trigger INSERT |
| trig_upd | Trigger UPDATE |
| trig_all | Trigger ALL |
| func_tbl | Function |
| cte | CTE |
| lj_isnull | LEFT JOIN + ISNULL |
| like | LIKE patterns |
| date | Date filter |
| perc | Percentage |
| max_grp | MAX trong group |
| delsub | DELETE subquery |
| ins_sub | INSERT subquery |
| sel_dist | DISTINCT |
| below_avg | Dưới TB |
| months | 12 tháng |

---

## ⚠️ LƯU Ý QUAN TRỌNG

1. **Dấu ngoặc vuông [ ]**: Tên bảng/cột trong ngoặc vuông là **placeholder**, cần thay thế bằng tên thật
2. **$end$**: Con trỏ sẽ dừng ở vị trí này sau khi insert snippet
3. **Tab để jump**: Nhấn Tab để di chuyển giữa các placeholder
4. **Kiểm tra syntax**: Luôn check lại syntax sau khi dùng snippet

---

## 📚 THAM KHẢO

- SQL Server Documentation: https://docs.microsoft.com/en-us/sql/
- DBI202 Coding Guides

---

Made with ❤️ for DBI202 Students
Created: 2025
