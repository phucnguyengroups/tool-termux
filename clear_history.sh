#!/data/data/com.termux/files/usr/bin/bash

# Xoá file lịch sử mặc định
echo "[*] Đang xoá lịch sử terminal..."
rm -f ~/.bash_history
rm -f ~/.zsh_history

# Tạo file trống để tránh lỗi khi shell ghi log
touch ~/.bash_history
touch ~/.zsh_history

# Đặt quyền chỉ đọc để tránh ghi thêm vào file
chmod 400 ~/.bash_history
chmod 400 ~/.zsh_history

# Xoá lịch sử hiện tại khỏi bộ nhớ shell
history -c

echo "[✓] Đã xoá lịch sử terminal Termux!"
