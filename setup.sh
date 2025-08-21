#!/bin/bash

# Kiểm tra shell hiện tại
CURRENT_SHELL=$(basename "$SHELL")
PROFILE_FILE=""

case "$CURRENT_SHELL" in
bash)
  PROFILE_FILE="$HOME/.bashrc"
  ;;
zsh)
  PROFILE_FILE="$HOME/.zshrc"
  ;;
fish)
  PROFILE_FILE="$HOME/.config/fish/config.fish"
  ;;
*)
  echo "Shell $CURRENT_SHELL chưa được hỗ trợ. Bạn có thể thêm thủ công."
  ;;
esac

# Kiểm tra nếu chưa có file command-not-found
if [[ ! -f "$HOME/.local/bin/command-not-found" ]]; then
  echo "Đang cài đặt command-not-found..."
  sudo apt update
  sudo apt install -y nala command-not-found wget

  # Tạo thư mục nếu chưa có
  mkdir -p "$HOME/.local/bin"

  # Tải script từ GitHub
  wget https://raw.githubusercontent.com/oreactko/cdfh/refs/heads/main/command-not-found \
    -O "$HOME/.local/bin/command-not-found"

  # Cấp quyền thực thi
  chmod +x "$HOME/.local/bin/command-not-found"
fi

# Thiết lập handler cho shell tương ứng
if [[ -n "$PROFILE_FILE" ]]; then
  case "$CURRENT_SHELL" in
  bash | zsh)
    echo 'command-not-found-handler() { ~/.local/bin/command-not-found -- "$1"; }' >>"$PROFILE_FILE"
    ;;
  fish)
    echo 'function commhand-not-found-handler; ~/.local/bin/command-not-found -- $argv[1]; end' >>"$PROFILE_FILE"
    ;;
  esac
  echo "Đã thiết lập command-not-found cho shell $CURRENT_SHELL."
  echo "Vui lòng khởi động lại shell hoặc chạy 'source $PROFILE_FILE' để áp dụng thay đổi."
fi
