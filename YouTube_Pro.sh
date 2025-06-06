#!/data/data/com.termux/files/usr/bin/bash

# ------------------- MÀU SẮC -------------------
GREEN='\033[1;32m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
NC='\033[0m' # reset

# ------------------- CẤU HÌNH ĐƯỜNG DẪN -------------------
DOWNLOAD_BASE="/storage/emulated/0/Download/YT-Downloads"

# ------------------- CHUẨN BỊ -------------------
echo -e "${CYAN}🔧 Đang kiểm tra cài đặt...${NC}"

# Kiểm tra yt-dlp
if ! command -v yt-dlp &> /dev/null
then
    echo -e "${YELLOW}📦 Cài đặt yt-dlp và phụ thuộc...${NC}"
    pkg update -y && pkg install python ffmpeg -y
    pip install --upgrade yt-dlp
else
    echo -e "${GREEN}✔ yt-dlp đã được cài đặt.${NC}"
fi

# Kiểm tra quyền truy cập bộ nhớ
if [ ! -d "/storage/emulated/0/Download" ]; then
    echo -e "${YELLOW}⚠ Chưa truy cập được bộ nhớ. Đang chạy: termux-setup-storage${NC}"
    termux-setup-storage
    sleep 2
    echo -e "${YELLOW}🔁 Vui lòng chạy lại script sau khi cấp quyền.${NC}"
    exit 1
fi

# Tạo thư mục lưu nếu chưa có
mkdir -p "$DOWNLOAD_BASE"

# ------------------- MENU CHÍNH -------------------
while true; do
    echo -e "\n${CYAN}====== 🎬 YouTube Pro Downloader ======${NC}"
    echo -e "${YELLOW}Thư mục lưu: $DOWNLOAD_BASE${NC}"
    echo -e "${GREEN}1) Tải video"
    echo "2) Tải MP3"
    echo "3) Tuỳ chọn nâng cao"
    echo "0) Thoát${NC}"
    echo -n "👉 Chọn: "
    read option

    case $option in
        1)
            read -p "🔗 Link video: " url
            yt-dlp -o "$DOWNLOAD_BASE/%(title)s.%(ext)s" "$url"
            echo -e "${GREEN}✅ Đã lưu video vào $DOWNLOAD_BASE${NC}"
            ;;
        2)
            read -p "🔗 Link video: " url
            yt-dlp -x --audio-format mp3 -o "$DOWNLOAD_BASE/%(title)s.%(ext)s" "$url"
            echo -e "${GREEN}✅ Đã lưu MP3 vào $DOWNLOAD_BASE${NC}"
            ;;
        3)
            echo -e "${CYAN}--- Tuỳ chọn nâng cao ---${NC}"
            read -p "🔗 Link video/playlist: " url
            echo "1) Chọn chất lượng video"
            echo "2) Tải toàn bộ playlist"
            echo "3) Tải phụ đề"
            echo -n "👉 Tuỳ chọn: "
            read adv
            case $adv in
                1)
                    echo "🎯 Ví dụ: best, 720p, worst"
                    read -p "📺 Nhập chất lượng: " quality
                    yt-dlp -f "$quality" -o "$DOWNLOAD_BASE/%(title)s.%(ext)s" "$url"
                    echo -e "${GREEN}🎬 Video đã được tải.${NC}"
                    ;;
                2)
                    yt-dlp --yes-playlist -o "$DOWNLOAD_BASE/%(playlist_title)s/%(title)s.%(ext)s" "$url"
                    echo -e "${GREEN}📃 Playlist đã lưu theo thư mục.${NC}"
                    ;;
                3)
                    yt-dlp --write-auto-sub --sub-lang "vi,en" --convert-subs srt \
                        -o "$DOWNLOAD_BASE/%(title)s.%(ext)s" "$url"
                    echo -e "${GREEN}💬 Phụ đề đã được tải cùng video.${NC}"
                    ;;
                *)
                    echo -e "${RED}❌ Tuỳ chọn không hợp lệ.${NC}"
                    ;;
            esac
            ;;
        0)
            echo -e "${GREEN}👋 Tạm biệt. Chúc bạn một ngày vui vẻ!${NC}"
            break
            ;;
        *)
            echo -e "${RED}❌ Lựa chọn không hợp lệ.${NC}"
            ;;
    esac
done
