#!/data/data/com.termux/files/usr/bin/bash

# --- Thư mục ---
ZIP_SRC=~/storage/shared/ToZip
ZIP_DST=~/storage/shared/Zipped
UNZIP_SRC=~/storage/shared/ToUnzip
UNZIP_DST=~/storage/shared/Unzipped

# --- Cài đặt gói nếu chưa có ---
for pkg in zip unzip; do
    if ! command -v "$pkg" >/dev/null 2>&1; then
        echo "🛠 Đang cài đặt $pkg..."
        pkg install -y "$pkg"
    fi
done

# --- Tạo thư mục nếu chưa có ---
mkdir -p "$ZIP_SRC" "$ZIP_DST" "$UNZIP_SRC" "$UNZIP_DST"

echo "🗂️ Bạn muốn làm gì?"
echo "1) Nén file/thư mục"
echo "2) Giải nén file zip"
read -p "Chọn (1 hoặc 2): " choice

if [ "$choice" == "1" ]; then
    echo "📁 Danh sách file/thư mục để nén:"
    cd "$ZIP_SRC" || exit
    select item in *; do
        [ -z "$item" ] && echo "❌ Không có gì để chọn!" && exit 1
        break
    done
    read -p "📄 Tên file zip đầu ra (không cần .zip): " zipname
    read -p "🔐 Đặt mật khẩu? (y/n): " usepass
    if [[ "$usepass" =~ ^[yY]$ ]]; then
        read -sp "Nhập mật khẩu: " password
        echo
        zip -r -P "$password" "$ZIP_DST/$zipname.zip" "$item"
    else
        zip -r "$ZIP_DST/$zipname.zip" "$item"
    fi
    echo "✅ Đã nén thành công: $ZIP_DST/$zipname.zip"

elif [ "$choice" == "2" ]; then
    echo "📁 Danh sách file zip để giải nén:"
    cd "$UNZIP_SRC" || exit
    select zipfile in *.zip; do
        [ -z "$zipfile" ] && echo "❌ Không có file zip!" && exit 1
        break
    done
    read -p "🔐 File có mật khẩu? (y/n): " haspass
    if [[ "$haspass" =~ ^[yY]$ ]]; then
        read -sp "Nhập mật khẩu: " password
        echo
        unzip -P "$password" "$zipfile" -d "$UNZIP_DST"
    else
        unzip "$zipfile" -d "$UNZIP_DST"
    fi
    echo "✅ Đã giải nén vào: $UNZIP_DST"

else
    echo "❌ Lựa chọn không hợp lệ!"
fi

