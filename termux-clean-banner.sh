#!/data/data/com.termux/files/usr/bin/bash

# Xoá các dòng giới thiệu trong ~/.bashrc nếu có
if [ -f ~/.bashrc ]; then
  sed -i '/echo "Welcome to Termux"/d' ~/.bashrc
  sed -i '/echo "Use pkg to install packages."/d' ~/.bashrc
fi

# Xoá tương tự trong ~/.zshrc nếu bạn dùng zsh
if [ -f ~/.zshrc ]; then
  sed -i '/echo "Welcome to Termux"/d' ~/.zshrc
  sed -i '/echo "Use pkg to install packages."/d' ~/.zshrc
  sed -i '/neofetch/d' ~/.zshrc
fi

# Hoặc xóa hoàn toàn banner mặc định Termux bằng cách xóa file motd
rm -f /data/data/com.termux/files/usr/etc/motd

# Tắt banner hệ thống khi mở shell
touch ~/.hushlogin

echo "✅ Đã xoá các dòng giới thiệu khởi động của Termux."
