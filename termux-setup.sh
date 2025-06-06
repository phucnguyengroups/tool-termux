#!/data/data/com.termux/files/usr/bin/bash

echo "📦 Đang cập nhật Termux..."
pkg update -y && pkg upgrade -y

echo "📦 Cài zsh, git, curl..."
pkg install zsh git curl -y

echo "🔧 Cài đặt Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "🎨 Cài đặt Powerlevel10k theme..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  $HOME/.oh-my-zsh/custom/themes/powerlevel10k

echo "⚙️ Cấu hình Powerlevel10k trong .zshrc..."
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' $HOME/.zshrc

if ! grep -q "source ~/.p10k.zsh" ~/.zshrc; then
  echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> ~/.zshrc
fi

echo "🛠️ Bật Zsh khi mở Termux..."
echo "zsh" >> ~/.bashrc

echo "✅ Hoàn tất cài Powerlevel10k!"
echo "👉 Gợi ý: Cài font 'MesloLGS NF' bằng Termux:Styling để hiển thị đẹp."
echo "👉 Gõ 'p10k configure' để cấu hình giao diện."

exec zsh
