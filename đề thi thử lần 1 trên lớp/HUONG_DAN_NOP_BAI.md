# Hướng dẫn nộp bài - DBI202 Paper No: 1

## Cấu trúc thư mục

Tạo một folder với định dạng tên: `RollNo_Name_DBI202_PaperNo`

**Ví dụ:** `se01245_LongNT_DBI202_01`

> ⚠️ **Lưu ý:** KHÔNG tạo bất kỳ subfolder nào trong folder này. Tất cả file đặt trực tiếp ở thư mục gốc.

## Các file cần nộp

Folder của bạn chỉ chứa 10 file SQL sau:

| File name | Nội dung |
|-----------|----------|
| Q1.sql | Câu lệnh tạo các bảng (CREATE TABLE) |
| Q2.sql | Câu query hiển thị tất cả ranking criteria |
| Q3.sql | Câu query lọc ranking system 1,2 |
| Q4.sql | Câu query universities % international students > 30% |
| Q5.sql | Câu query ranking system với số lượng criteria |
| Q6.sql | Câu query universities có student_staff_ratio thấp nhất |
| Q7.sql | Câu query universities cùng Teaching score |
| Q8.sql | Stored procedure proc_university_year |
| Q9.sql | Trigger tr_insert_university_ranking |
| Q10.sql | INSERT ranking system và criteria mới |

## Quy tắc quan trọng

1. **KHÔNG sử dụng** các lệnh chứa tên database:
   - `CREATE DATABASE`
   - `ALTER DATABASE`
   - `USE [database_name]`
   - `GO`

2. Chỉ chứa các lệnh cần thiết để trả lời câu hỏi
   - KHÔNG chứa lệnh test trigger/procedure
   - KHÔNG chứa lệnh SELECT để kiểm tra kết quả

3. Giữ nguyên tên bảng, relationship, attributes và data types như ERD

## Nén và nộp bài

1. Sử dụng **WinRAR** hoặc **WinZip** để nén folder
2. Đặt tên file nén trùng với tên folder: `RollNo_Name_DBI202_PaperNo.rar`
3. Nộp lên LMS

## Các công cụ được phép sử dụng

- SQL Server
- SQL Server Management Studio (SSMS)
- Windows Explorer
- WinRAR / WinZip

> ⚠️ **Cảnh báo:** Nếu bất kỳ yêu cầu nào không được tuân thủ, điểm số sẽ là **0**.

---

**Chúc bạn làm bài tốt!**
