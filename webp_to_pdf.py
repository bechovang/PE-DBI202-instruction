from PIL import Image
import os

# Danh sách file từ 1 đến 20
file_names = [f"{i}.webp" for i in range(1, 30)]
images = []

for name in file_names:
    if os.path.exists(name):
        try:
            img = Image.open(name)
            # Chuyển sang RGB vì PDF không hỗ trợ chế độ màu RGBA của WebP (nếu có)
            if img.mode in ("RGBA", "P"):
                img = img.convert("RGB")
            images.append(img)
            print(f"Da load: {name}")
        except Exception as e:
            print(f"Loi file {name}: {e}")

if images:
    # Lưu file đầu tiên và "append" các file còn lại vào
    images[0].save(
        "debai.pdf", 
        save_all=True, 
        append_images=images[1:]
    )
    print("--- THANH CONG! File PDF da san sang ---")
else:
    print("Khong tim thay anh nao de gop.")