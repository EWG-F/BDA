#!/usr/bin/env bash
set -euo pipefail

LAB_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"

if ! command -v less >/dev/null 2>&1; then
  echo "The 'less' viewer is not installed. Install it with: sudo apt install less"
  exit 1
fi

for n in {1..9}; do
  file="$LAB_DIR/lab${n}.txt"
  if [[ ! -f "$file" ]]; then
    echo "Missing file: $file" >&2
    exit 1
  fi
  cat > "$BIN_DIR/lab${n}" <<EOF2
#!/usr/bin/env bash
exec less "$file"
EOF2
  chmod +x "$BIN_DIR/lab${n}"
done

PATH_LINE='export PATH="$HOME/.local/bin:$PATH"'
if ! grep -Fqx "$PATH_LINE" "$HOME/.bashrc" 2>/dev/null; then
  printf '\n%s\n' "$PATH_LINE" >> "$HOME/.bashrc"
fi

# Make the commands available immediately in this terminal too.
export PATH="$HOME/.local/bin:$PATH"

echo "Installed commands: lab1 lab2 lab3 lab4 lab5 lab6 lab7 lab8 lab9"
echo "Example: type lab1 to read Lab 1. Press q to close a lab."
echo "Lab files are stored in: $LAB_DIR"
