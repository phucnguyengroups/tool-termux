#!/data/data/com.termux/files/usr/bin/bash

# Đường dẫn backup (có thể thay đổi)
BACKUP_DIR="$HOME/termux_backup"
BACKUP_FILE="$BACKUP_DIR/home_backup_$(date +%Y-%m-%d_%H-%M-%S).tar.gz"

# Tạo thư mục backup nếu chưa có
mkdir -p "$BACKUP_DIR"

echo "[✔] Đang backup toàn bộ dữ liệu trong \$HOME..."

# Nén toàn bộ dữ liệu trong HOME (kể cả file ẩn), bỏ qua thư mục backup nếu nó nằm trong $HOME
tar --exclude="$BACKUP_DIR" -czvf "$BACKUP_FILE" -C "$HOME" .

echo "[✔] Backup hoàn tất!"
echo "📦 File backup: $BACKUP_FILE"
