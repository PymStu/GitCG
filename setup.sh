#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONTRIBUTE_SCRIPT="$SCRIPT_DIR/contribute.sh"

chmod +x "$CONTRIBUTE_SCRIPT"

# Detect branch name
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")
# Update contribute.sh to use correct branch
sed -i "s|git push origin .*|git push origin $BRANCH --quiet|g" "$CONTRIBUTE_SCRIPT"

mkdir -p ~/.config/systemd/user

cat > ~/.config/systemd/user/github-contribute.service << EOF
[Unit]
Description=GitHub Contribution Wall Auto Commit

[Service]
Type=oneshot
ExecStart=$CONTRIBUTE_SCRIPT
WorkingDirectory=$SCRIPT_DIR
EOF

cat > ~/.config/systemd/user/github-contribute.timer << 'EOF'
[Unit]
Description=Random GitHub Contribution Timer (3-7 times/day)

[Timer]
OnCalendar=*-*-* 08,09,10,11,12,13,14,15,16,17,18,19,20,21,22:00
RandomizedDelaySec=1800
Persistent=true

[Install]
WantedBy=timers.target
EOF

systemctl --user daemon-reload
systemctl --user enable --now github-contribute.timer

echo "Done! Timer enabled."
echo "Manual run: $CONTRIBUTE_SCRIPT"
echo "Logs: journalctl --user -u github-contribute"
