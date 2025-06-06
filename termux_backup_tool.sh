#!/data/data/com.termux/files/usr/bin/bash

# === CẤU HÌNH ===
BACKUP_DIR="$HOME/termux_backup"
BACKUP_PREFIX="home_backup_"
DATE_NOW=$(date +%Y-%m-%d_%H-%M-%S)
FZF_CMD=$(command -v fzf)

# === HÀM: Backup ===
function backup_home() {
    mkdir -p "$BACKUP_DIR"
    BACKUP_FILE="$BACKUP_DIR/${BACKUP_PREFIX}${DATE_NOW}.tar.gz"

    echo "📦 Đang backup dữ liệu..."
    tar --exclude="$BACKUP_DIR" -czvf "$BACKUP_FILE" -C "$HOME" .
    echo "✅ Backup hoàn tất!"
    echo "📁 Lưu tại: $BACKUP_FILE"
}

# === HÀM: Restore ===
function restore_home() {
    mkdir -p "$BACKUP_DIR"

    echo "📂 Tìm file backup trong: $BACKUP_DIR"

    if [ -z "$(ls $BACKUP_DIR/*.tar.gz 2>/dev/null)" ]; then
        echo "❌ Không tìm thấy file backup nào!"
        return
    fi

    # Dùng fzf nếu có, ngược lại dùng nhập tay
    if [ -n "$FZF_CMD" ]; then
        echo "📑 Chọn file cần phục hồi (dùng phím ↑ ↓, Enter để chọn):"
        BACKUP_FILE=$(ls -t "$BACKUP_DIR"/*.tar.gz | fzf)
    else
        echo "🔽 Danh sách các file backup:"
        ls -1t "$BACKUP_DIR"/*.tar.gz
        read -p "🔁 Nhập tên file backup cần phục hồi (VD: home_backup_2025-06-06_14-20-00.tar.gz): " FILE_NAME
        BACKUP_FILE="$BACKUP_DIR/$FILE_NAME"
    fi

    # Kiểm tra file tồn tại
    if [ ! -f "$BACKUP_FILE" ]; then
        echo "❌ File không tồn tại: $BACKUP_FILE"
        return
    fi

    # Tạo backup hiện tại trước khi phục hồi
    echo "🛑 Cảnh báo: Phục hồi sẽ ghi đè dữ liệu hiện tại trong \$HOME."
    read -p "⚠️ Bạn có muốn tạo bản backup trước khi phục hồi không? (yes/no): " confirm_backup
    if [ "$confirm_backup" == "yes" ]; then
        backup_home
    fi

    read -p "❓ Bạn có chắc muốn ghi đè dữ liệu bằng file này không? (yes/no): " confirm_restore
    if [ "$confirm_restore" != "yes" ]; then
        echo "❌ Huỷ thao tác phục hồi."
        return
    fi

    echo "🔁 Đang phục hồi từ: $BACKUP_FILE"
    tar -xzvf "$BACKUP_FILE" -C "$HOME"
    echo "✅ Phục hồi hoàn tất!"
}

# === HÀM: Menu ===
function show_menu() {
    echo "============================"
    echo " 🧰 TERMUX BACKUP TOOL"
    echo "============================"
    echo "1. Backup dữ liệu HOME"
    echo "2. Restore từ file backup"
    echo "3. Thoát"
    echo "============================"
    read -p "👉 Chọn thao tác (1/2/3): " choice

    case $choice in
        1) backup_home ;;
        2) restore_home ;;
        3) echo "👋 Thoát"; exit 0 ;;
        *) echo "❌ Lựa chọn không hợp lệ";;
    esac
}

# === CHẠY MENU ===
while true; do
    show_menu
done
