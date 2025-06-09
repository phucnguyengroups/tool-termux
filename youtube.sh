#!/data/data/com.termux/files/usr/bin/bash

# Màu sắc (tuỳ chọn để dễ nhìn)
GREEN='\033[1;32m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # reset

DOWNLOAD_PATH="/storage/emulated/0/Download"

echo -e "${GREEN}🔍 Kiểm tra và cài đặt các gói cần thiết...${NC}"

# Kiểm tra yt-dlp
if ! command -v yt-dlp &> /dev/null
then
    echo -e "${YELLOW}Cài đặt yt-dlp...${NC}"
    pkg update -y && pkg install python ffmpeg -y
    pip install --upgrade yt-dlp
else
    echo -e "${GREEN}✔ yt-dlp đã được cài.${NC}"
fi

# Kiểm tra quyền lưu trữ
if [ ! -d "$DOWNLOAD_PATH" ]; then
    echo -e "${YELLOW}⚠ Chưa truy cập được thư mục Download."
    echo "👉 Đang chạy lệnh cấp quyền: termux-setup-storage${NC}"
    termux-setup-storage
    sleep 2
    echo -e "${YELLOW}🔁 Vui lòng chạy lại script sau khi cấp quyền.${NC}"
    exit 1
fi

# Menu chính
while true; do
    echo -e "\n${YELLOW}=== YouTube Downloader Menu ===${NC}"
    echo "1) Tải video"
    echo "2) Tải MP3"
    echo "3) Tuỳ chọn nâng cao"
    echo "0) Thoát"
    read -p "👉 Chọn: " option

    case $option in
        1)
            read -p "🔗 Dán link video YouTube: " url
            yt-dlp -o "$DOWNLOAD_PATH/%(title)s.%(ext)s" "$url"
            ;;
        2)
            read -p "🔗 Dán link video YouTube: " url
            yt-dlp -x --audio-format mp3 -o "$DOWNLOAD_PATH/%(title)s.%(ext)s" "$url"
            ;;
        3)
            echo -e "${YELLOW}--- Tuỳ chọn nâng cao ---${NC}"
            read -p "🔗 Dán link video YouTube: " url
            echo "1) Chọn chất lượng video"
            echo "2) Tải toàn bộ playlist"
            echo "3) Tải phụ đề (subtitles)"
            read -p "👉 Chọn tuỳ chọn nâng cao: " adv

            case $adv in
                1)
                    echo "Ví dụ: best, 720p, 480p, worst"
                    read -p "📺 Nhập chất lượng: " quality
                    yt-dlp -f "$quality" -o "$DOWNLOAD_PATH/%(title)s.%(ext)s" "$url"
                    ;;
                2)
                    yt-dlp -i --yes-playlist -o "$DOWNLOAD_PATH/%(title)s.%(ext)s" "$url"
                    ;;
                3)
                    yt-dlp --write-subs --sub-lang "vi,en" --convert-subs srt -o "$DOWNLOAD_PATH/%(title)s.%(ext)s" "$url"
                    ;;
                *)
                    echo -e "${RED}Tuỳ chọn không hợp lệ.${NC}"
                    ;;
            esac
            ;;
        0)
            echo -e "${GREEN}👋 Tạm biệt!${NC}"
            break
            ;;
        *)
            echo -e "${RED}❌ Tuỳ chọn không hợp lệ.${NC}"
            ;;
    esac
done
