#!/data/data/com.termux/files/usr/bin/bash

# Kiểm tra SSH
if ! command -v ssh >/dev/null 2>&1; then
    echo "🔧 Đang cài đặt openssh..."
    pkg install openssh -y
fi

# Kiểm tra SSH key
SSH_KEY="$HOME/.ssh/id_rsa"
if [ ! -f "$SSH_KEY" ]; then
    echo "🔐 Không tìm thấy SSH key tại $SSH_KEY"
    echo "👉 Vui lòng chạy script tạo SSH key trước khi tiếp tục."
    exit 1
fi

# Nhập SSH repo URL (VD: git@github.com:username/repo.git)
read -p "🔗 SSH Repo URL (git@github.com:username/repo.git): " repo_url

# Clone repo vào thư mục tạm
tmp_dir=$(mktemp -d)
cd "$tmp_dir" || exit 1

echo "📥 Cloning repo qua SSH..."
git clone "$repo_url" repo || { echo "❌ Clone thất bại"; exit 1; }

cd repo || exit 1

# Lưu tên nhánh hiện tại
branch=$(git rev-parse --abbrev-ref HEAD)

echo "🚧 Tạo nhánh mới không có lịch sử (orphan)..."
git checkout --orphan temp-branch || { echo "❌ Orphan branch thất bại"; exit 1; }

# Thêm toàn bộ file lại và commit mới
git add . 
git commit -m "first commit" || { echo "❌ Commit thất bại"; exit 1; }

echo "🔁 Ghi đè nhánh $branch với commit mới..."
git branch -D "$branch"
git branch -m "$branch"

echo "🚀 Push force lên remote qua SSH..."
git push origin "$branch" --force || { echo "❌ Push thất bại"; exit 1; }

echo "✅ Đã xoá toàn bộ lịch sử và giữ commit mới nhất duy nhất."
