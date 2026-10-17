# TINA Pet Spa – App Android

App quản lý khách hàng, lịch hẹn, thu chi cho TINA Pet Care & Grooming.
GitHub sẽ tự build ra file **APK** mỗi khi bạn đẩy code lên.

## Cấu trúc

| Thư mục / file | Dùng để |
|---|---|
| `www/index.html` | Toàn bộ app (giao diện + chức năng). Muốn sửa app thì sửa file này |
| `resources/android/` | Icon app và màn hình chờ (tạo từ logo) |
| `keystore/tina.keystore` | Khóa ký APK – **giữ nguyên, đừng xóa** |
| `scripts/customize-android.sh` | Áp icon, màu, số phiên bản khi build |
| `.github/workflows/build-apk.yml` | Lệnh build APK tự động trên GitHub |

## Các bước build APK

1. Vào https://github.com/new, tạo repo mới, ví dụ `tina-pet-spa`. **Nên chọn Private.**
2. Trong repo vừa tạo, bấm **uploading an existing file**. Kéo **toàn bộ nội dung** bên trong thư mục này vào (cả thư mục ẩn `.github`), rồi bấm **Commit changes**.
   - Nếu trình duyệt không kéo được thư mục `.github`: bấm **Add file → Create new file**, gõ tên `.github/workflows/build-apk.yml`, dán nội dung file đó vào rồi commit.
3. Vào tab **Actions**. Workflow **Build APK** sẽ tự chạy (khoảng 5–8 phút). Nếu không thấy chạy, bấm **Build APK → Run workflow**.
4. Khi có dấu ✅ xanh, bấm vào lần chạy đó, kéo xuống mục **Artifacts**, tải **TINA-Pet-Spa-APK** (file .zip, giải nén ra file .apk).
5. Chép file .apk vào điện thoại và mở để cài. Android sẽ hỏi cho phép **cài ứng dụng không rõ nguồn gốc** → cho phép.

## Cập nhật app

- Sửa `www/index.html`, đẩy lên GitHub là có APK mới. Số phiên bản tự tăng.
- Cài APK mới **đè lên** app cũ, **dữ liệu vẫn giữ nguyên** (vì luôn ký bằng cùng một khóa).
- ⚠️ Nếu gỡ app thì dữ liệu trong app sẽ mất. Trước khi gỡ hoặc đổi máy, vào **Cài đặt → Xuất dữ liệu** để sao lưu.

## Về khóa ký (keystore)

Khóa đang nằm sẵn trong `keystore/tina.keystore` (mật khẩu `tina123456`), nên repo **nên để Private**.
Nếu muốn để repo Public, chuyển khóa vào Secrets:

1. Trên máy tính chạy: `base64 -w0 keystore/tina.keystore` (Windows PowerShell: `[Convert]::ToBase64String([IO.File]::ReadAllBytes("keystore\tina.keystore"))`)
2. Repo → **Settings → Secrets and variables → Actions → New repository secret**, tạo 3 secret:
   - `KEYSTORE_BASE64` = chuỗi vừa tạo
   - `KEYSTORE_PASSWORD` = `tina123456`
   - `KEY_ALIAS` = `tina`
3. Xóa file `keystore/tina.keystore` khỏi repo (giữ lại 1 bản trên máy của bạn).

## Thông tin kỹ thuật

- Capacitor 7, Android 6.0 trở lên (minSdk 23), targetSdk 35.
- Dữ liệu lưu bằng IndexedDB trong bộ nhớ riêng của app. Ảnh được nén (cạnh dài tối đa 800px) và lưu thẳng trong dữ liệu app, không phải đường dẫn tới thư viện ảnh.
- Xuất dữ liệu trong APK mở bảng **Chia sẻ** của Android → lưu vào Drive, gửi qua Zalo, hoặc lưu vào Tệp.
- Nút Back của Android: đóng hộp thoại/form → về tab Khách hàng → thoát app.
