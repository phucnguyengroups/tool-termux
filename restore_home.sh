#!/data/data/com.termux/files/usr/bin/bash

# Thư mục chứa file backup
BACKUP_DIR="$HOME/termux_backup"

# Kiểm tra có file backup không
echo "📦 Danh sách các file backup trong: $BACKUP_DIR"
ls -1 "$BACKUP_DIR"/*.tar.gz 2>/dev/null || { echo "❌ Không tìm thấy file backup nào."; exit 1; }

# Nhập tên file cần phục hồi
read -p "🔁 Nhập tên file backup cần phục hồi (ví dụ: home_backup_2025-06-06_14-20-00.tar.gz): " BACKUP_FILE_NAME

FULL_BACKUP_PATH="$BACKUP_DIR/$BACKUP_FILE_NAME"

# Kiểm tra file có tồn tại không
if [ ! -f "$FULL_BACKUP_PATH" ]; then
    echo "❌ File backup không tồn tại: $FULL_BACKUP_PATH"
    exit 1
fi

# Cảnh báo
echo "⚠️ KHÔI PHỤC sẽ GHI ĐÈ dữ liệu hiện tại trong \$HOME."
read -p "❓ Bạn có chắc muốn tiếp tục? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    echo "❌ Huỷ thao tác phục hồi."
    exit 0
fi

# Giải nén vào HOME
echo "🔄 Đang phục hồi dữ liệu..."
tar -xzvf "$FULL_BACKUP_PATH" -C "$HOME"

echo "✅ Phục hồi hoàn tất!"
