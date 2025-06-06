#!/data/data/com.termux/files/usr/bin/bash

# Màu sắc
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
RESET="\e[0m"

echo -e "${GREEN}[✔] Bắt đầu setup GitHub trên Termux...${RESET}"

# 1. Cấp quyền bộ nhớ (chạy lần đầu)
termux-setup-storage

# 2. Kiểm tra git
if ! command -v git >/dev/null 2>&1; then
    echo -e "${YELLOW}[~] Cài đặt git...${RESET}"
    pkg install git -y
else
    echo -e "${GREEN}[✔] Git đã được cài đặt.${RESET}"
fi

# 3. Kiểm tra openssh
if ! command -v ssh >/dev/null 2>&1; then
    echo -e "${YELLOW}[~] Cài đặt openssh...${RESET}"
    pkg install openssh -y
else
    echo -e "${GREEN}[✔] OpenSSH đã được cài đặt.${RESET}"
fi

# 4. Cấu hình Git (nếu chưa có)
GIT_NAME=$(git config --global user.name)
GIT_EMAIL=$(git config --global user.email)

if [ -z "$GIT_NAME" ] || [ -z "$GIT_EMAIL" ]; then
    read -p "Nhập tên GitHub của bạn: " GIT_NAME
    read -p "Nhập email GitHub: " GIT_EMAIL

    git config --global user.name "$GIT_NAME"
    git config --global user.email "$GIT_EMAIL"
    echo -e "${GREEN}[✔] Đã cấu hình Git.${RESET}"
else
    echo -e "${GREEN}[✔] Git đã được cấu hình: $GIT_NAME <$GIT_EMAIL>${RESET}"
fi

# 5. Tạo SSH key nếu chưa có
SSH_DIR="$HOME/.ssh"
SSH_KEY="$SSH_DIR/id_rsa"

mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

if [ ! -f "$SSH_KEY" ]; then
    echo -e "${GREEN}[✔] Tạo SSH key mới...${RESET}"
    ssh-keygen -t rsa -b 4096 -C "$GIT_EMAIL" -f "$SSH_KEY" -N ""
else
    echo -e "${GREEN}[✔] SSH key đã tồn tại, bỏ qua bước tạo.${RESET}"
fi

# 6. Hiển thị public key
if [ -f "${SSH_KEY}.pub" ]; then
    echo -e "${YELLOW}[~] Public SSH key của bạn (thêm vào GitHub > Settings > SSH):${RESET}"
    cat "${SSH_KEY}.pub"
else
    echo -e "${RED}[✘] Lỗi: Không tìm thấy SSH public key.${RESET}"
    exit 1
fi

# 6.1 Tự động upload SSH key lên GitHub qua API
read -p "Bạn có muốn tự động upload SSH key lên GitHub không? (y/n): " UPLOAD_CHOICE

CONFIG_DIR="$HOME/.github"
mkdir -p "$CONFIG_DIR"

if [[ "$UPLOAD_CHOICE" =~ ^[Yy]$ ]]; then
    if [ ! -f "$CONFIG_DIR/username" ]; then
        read -p "Nhập GitHub username: " GH_USERNAME
        echo "$GH_USERNAME" > "$CONFIG_DIR/username"
    else
        GH_USERNAME=$(cat "$CONFIG_DIR/username")
        echo -e "${GREEN}[✔] Username đã được lưu sẵn.${RESET}"
    fi

    if [ ! -f "$CONFIG_DIR/token" ]; then
        read -p "Nhập Personal Access Token (PAT): " GH_TOKEN
        echo "$GH_TOKEN" > "$CONFIG_DIR/token"
        chmod 600 "$CONFIG_DIR/token"
    else
        GH_TOKEN=$(cat "$CONFIG_DIR/token")
        echo -e "${GREEN}[✔] Token đã được lưu sẵn.${RESET}"
    fi

    PUB_KEY_CONTENT=$(cat "${SSH_KEY}.pub")
    TITLE="Termux_$(date +%Y%m%d_%H%M%S)"

    echo -e "${YELLOW}[~] Đang upload SSH key lên GitHub...${RESET}"

    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
      -H "Authorization: token $GH_TOKEN" \
      -H "Content-Type: application/json" \
      -d "{\"title\": \"$TITLE\", \"key\": \"$PUB_KEY_CONTENT\"}" \
      https://api.github.com/user/keys)

    if [ "$RESPONSE" -eq 201 ]; then
        echo -e "${GREEN}[✔] SSH key đã được upload thành công lên GitHub.${RESET}"
    elif [ "$RESPONSE" -eq 422 ]; then
        echo -e "${YELLOW}[~] SSH key đã tồn tại trên GitHub (hoặc bị trùng).${RESET}"
    else
        echo -e "${RED}[✘] Upload SSH key thất bại. Mã lỗi: $RESPONSE${RESET}"
    fi
else
    echo -e "${YELLOW}[~] Bỏ qua bước upload SSH key tự động.${RESET}"
fi

# 8. Kiểm tra kết nối SSH
echo -e "${YELLOW}[~] Kiểm tra kết nối SSH với GitHub...${RESET}"
ssh -T git@github.com

echo -e "${GREEN}[✔] Thiết lập GitHub hoàn tất!${RESET}"
