2026-03-14 08:38
Status: 
Tags: #DBI202 #PE #Rules #FPT

Disable spell check :teh

# 🚨 QUY ĐỊNH  - THI PE DBI202

> [!warning] NGUYÊN TẮC TỐI THƯỢNG
> 
> Các quy định có thể thay đổi theo từng kỳ. Khi nhận đề, **HÃY ĐỌC KỸ TRANG ĐẦU TIÊN (FIRST PAGE)**. Bỏ qua bước này, mọi sự oan ức đều bị chấm 0 điểm và không có ngoại lệ.

---

## 1. 🚫 Kỷ luật & Phần mềm phòng thi (CHẾT NGƯỜI)
**LỖI 0 ĐIỂM TỨC KHẮC**
Chỉ được phép mở **ĐÚNG 4 ỨNG DỤNG** sau:
1. SQL Server Management Studio (SSMS)
2. Windows Explorer (Thư mục máy tính)
3. Zip tools (WinRAR, 7-Zip...)
4. PEA (Phần mềm nộp bài thi)

* 💀 **CẤM TUYỆT ĐỐI:** Mở bất kỳ phần mềm nào khác (Trình duyệt Web, Visual Studio Code, Notepad++, Discord...). Cho dù mở vô tình hay mở để đó không dùng, phần mềm thi quét được = 0 ĐIỂM PE ngay lập tức.
* **Làm bài cá nhân:** Tuyệt đối không trao đổi, chia sẻ bài.
* **Tài liệu Offline:** Bạn được mang tài liệu offline (script lưu sẵn), nhưng phải cẩn thận. Chỉ dùng SSMS để mở file code `.sql`. Nếu bạn mở tài liệu bằng Word/PDF Reader/VS Code mà các app đó không nằm trong danh sách cho phép của giám thị hôm đó, bạn vẫn dính án 0 điểm.

---

## 3. 📂 Cấu trúc thư mục & Đặt tên file (RẤT DỄ CHẾT)
**QUY TẮC THƯ MỤC**
* Chỉ nộp **ĐÚNG 1 THƯ MỤC DUY NHẤT**. 
* ❌ **KHÔNG tạo thư mục con** hay để các file không liên quan (kể cả file script tạo DB ban đầu) trong thư mục này.
* **Tên file bài làm:** Tương ứng với 10 câu hỏi trong đề thi, bắt buộc phải đặt tên file lần lượt là: `Q1.sql`, `Q2.sql`, ..., `Q10.sql`. 

---

## 4. 💻 Quy tắc viết Code SQL (Dành cho Auto-Grader)
Bài của bạn được chấm bằng PHẦN MỀM TỰ ĐỘNG trên một Database có tên như đề bài nhưng **DỮ LIỆU SẼ KHÁC** (thêm, bớt dữ liệu) so với lúc bạn làm bài. Do đó, phải tuân thủ tuyệt đối:

### ⛔ NHỮNG ĐIỀU CẤM KỴ (Làm là 0 điểm)
* ❌ **KHÔNG SỬ DỤNG LỆNH `GO`**: Không cần thiết và có thể gây ra lỗi khi chấm điểm bằng phần mềm tự động.
* ❌ **KHÔNG ĐƯỢC HARD CODE**: Vì dữ liệu lúc chấm sẽ khác, bạn phải viết câu lệnh truy vấn đúng logic theo yêu cầu đề bài, tuyệt đối không nhìn kết quả rồi dùng mẹo (`WHERE id = ...`) để chọn ra đúng những dòng như vậy.
* ❌ **KHÔNG chứa lệnh `CREATE DATABASE`** cũng như lệnh `USE TenCSDL`. (Tuyệt đối không có câu lệnh nào sử dụng tên CSDL trong bài làm để tránh lỗi).
* ❌ **KHÔNG để lại code test hay code thừa**: Máy chỉ cần đáp án, ví dụ câu SELECT thì file chỉ có đúng lệnh SELECT. 
* ❌ **KHÔNG nộp kèm lệnh test (`INSERT`, `UPDATE`, `DELETE`, `EXEC`)** vào file bài nộp của câu Trigger/Procedures. Chỉ nộp **duy nhất câu lệnh tạo trigger, procedures tương ứng**.

### ✅ QUY TẮC BẮT BUỘC (Schema & Query)
* **Câu tạo bảng (Schema):**
  * Tạo bảng **ĐÚNG tên bảng, tên thuộc tính, kiểu dữ liệu** như trong đề bài yêu cầu.
  * Tất cả các bảng đều cần có **Khóa chính (Primary Key)**.
  * Nếu có **Khóa ngoại (Foreign Key)**, bắt buộc **đặt tên thuộc tính trong khóa ngoại đúng với tên thuộc tính khóa chính của bảng tham chiếu đến**.
  * Các câu lệnh tạo bảng cần đặt đúng thứ tự để tránh gây ra lỗi khi chạy (bảng cha tạo trước, bảng con tạo sau).
* **Câu truy vấn (SELECT):**
  * Kết quả in ra phải khớp 100% với hình mẫu trong đề bài (Số dòng, số thuộc tính/cột, **TÊN THUỘC TÍNH/CỘT**). Dùng `AS` để đổi tên cột nếu cần. Mới được điểm.
* **Lưu ý cực kỳ quan trọng về Dữ liệu test:**
  * Nếu bạn dùng các câu lệnh `INSERT`, `UPDATE`, `DELETE` để test trigger hoặc để thử thay đổi dữ liệu, bạn **BẮT BUỘC PHẢI CHẠY LẠI script tạo CSDL** trước khi thực hiện các câu truy vấn (SELECT) để đảm bảo kết quả trả về giống hệt trong đề bài.

---

## 5. 📤 Quy tắc Nộp bài (Submit)
**CHÚ Ý CÁCH NỘP BÀI QUA TOOL PEA**
* Khi nộp bài, sinh viên chỉ cần **trỏ đường dẫn (Browse) đến đúng thư mục** chứa các file `Q1.sql` -> `Q10.sql`.
* ❌ **KHÔNG ĐƯỢC NÉN (ZIP/RAR) FILE HAY THƯ MỤC TRƯỚC KHI NỘP.** Đặt nhầm thư mục hoặc nén file là lỗi rất hay xảy ra, hãy kiểm tra thật kỹ!

---
### 📝 Checklist kiểm tra trước khi tắt máy rời phòng:
- [ ] Màn hình chỉ đang mở đúng SSMS, PEA và Windows Explorer chưa? (Tắt ngay các app khác nếu có).
- [ ] Thư mục bài nộp chỉ có duy nhất các file từ `Q1.sql` đến `Q10.sql`? (Không thư mục con, không file rác).
- [ ] Đã xóa sạch các dòng `USE [Database_Name]`, `CREATE DATABASE` và lệnh `GO` trong tất cả các file chưa?
- [ ] Các câu Trigger/Procedure đã xóa sạch lệnh test chưa?
- [ ] Đã trỏ thẳng thư mục vào PEA mà KHÔNG nén thành file Zip chưa?