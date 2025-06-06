#!/data/data/com.termux/files/usr/bin/bash

# Thay SOURCE_PATH bằng nơi bạn lưu .pack và .idx
SOURCE_PATH="/sdcard/git-backup"
RESTORE_DIR="/sdcard/restored"

mkdir -p "$RESTORE_DIR"
cd "$RESTORE_DIR" || exit 1

git init
mkdir -p .git/objects/pack

cp "$SOURCE_PATH"/*.pack .git/objects/pack/
cp "$SOURCE_PATH"/*.idx .git/objects/pack/

git fsck --full

COMMIT=$(git fsck --unreachable --no-reflogs | grep commit | head -n1 | awk '{print $3}')

if [ -n "$COMMIT" ]; then
    git checkout -f "$COMMIT"
    echo "✔️ Khôi phục thành công mã nguồn tại $RESTORE_DIR"
else
    echo "❌ Không tìm thấy commit để checkout."
fi
