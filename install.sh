#!/usr/bin/env bash
set -euo pipefail
APP_NAME="NOVA"; APP_VER="v1.0.0"; APP_DIR="$HOME/nova-bot"

clear || true
echo -e "\033[36mThe standalone server for \033[32m$APP_NAME\033[0m \033[36m$APP_VER\033[0m"
echo -e "\033[2mStay alert for potential bugs. Use it wisely.\033[0m"
echo -e "Created with ❤ by Rafflix/Mamon\n"

echo "[1/4] Updating & installing Python…"
pkg update -y >/dev/null 2>&1 || true
pkg upgrade -y >/dev/null 2>&1 || true
pkg install -y python >/dev/null 2>&1

echo "[2/4] Creating project & writing UI…"
mkdir -p "$APP_DIR" && cd "$APP_DIR"
cat > index.html <<'HTML'
<!DOCTYPE html><meta charset="utf-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>NOVA</title><style>
:root{--bg:#0f1220;--panel:#171a2b;--text:#e8e8f0;--muted:#a6a7b0}
body{margin:0;background:var(--bg);color:var(--text);font:14px system-ui}
.wrap{max-width:800px;margin:40px auto;padding:0 16px}
.card{background:var(--panel);border:1px solid #262a43;border-radius:16px;padding:18px}
.muted{color:var(--muted)}
.ok{color:#90ee90}
</style><div class="wrap"><div class="card">
<h2>🎉 Congratulations!</h2>
<p class="muted">Your NOVA app is set up locally.</p>
<p>Status: <b class="ok">Ready</b></p>
<p>Keep this tab open. Access will be granted in Termux via Discord ID.</p>
</div></div>
HTML

echo "[3/4] Starting local server…"
( nohup python -m http.server 8000 >/dev/null 2>&1 & echo $! > .nova_server.pid )
sleep 2
URL="http://127.0.0.1:8000"
echo "[4/4] Opening $URL in your browser…"
if command -v termux-open-url >/dev/null 2>&1; then termux-open-url "$URL" || true
else am start -a android.intent.action.VIEW -d "$URL" >/dev/null 2>&1 || true
fi

echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " NOVA Access Control (Discord ID Gate)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
read -r -p "Type or paste your Discord User ID: " DID
# alisin ang spaces/newlines just in case
DID="$(printf '%s' "$DID" | tr -d '[:space:]')"

# basic validation: 17–20 numeric digits lang
if ! [[ "$DID" =~ ^[0-9]{17,20}$ ]]; then
  echo "❌ Invalid Discord ID."
  # kung may sinimulang local server, patayin nang tahimik
  pkill -f 'http.server 8000' >/dev/null 2>&1 || true
  exit 1
fi

# === Whitelist of Discord User IDs ===
WHITELIST=(
  693492070655983656
  332738729250914305
  1215179269215363072
)

# check membership
allowed=0
for ID in "${WHITELIST[@]}"; do
  if [[ "$DID" == "$ID" ]]; then
    allowed=1
    break
  fi
done

if (( allowed )); then
  echo "✅ Authorized. Access granted."
  # optional: mark as authorized para next run hindi na magtanong
  printf "%s\n" "$DID" > "$APP_DIR/.authorized" 2>/dev/null || true
else
  echo "⛔ Not authorized. Closing app..."
  pkill -f 'http.server 8000' >/dev/null 2>&1 || true
  exit 1
fi
