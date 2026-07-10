#!/usr/bin/env bash
set -euo pipefail

# This script schedules the contribution script to run 3-7 times/day
# using a combination of systemd timer or crontab fallback.

SCRIPT_DIR="/home/victor-pym/文档/Project/GitCG"
CONTRIBUTE_SCRIPT="$SCRIPT_DIR/contribute.sh"

chmod +x "$CONTRIBUTE_SCRIPT"

# Create the systemd user service and timer
mkdir -p ~/.config/systemd/user

cat > ~/.config/systemd/user/github-contribute.service << 'EOF'
[Unit]
Description=GitHub Contribution Wall Auto Commit

[Service]
Type=oneshot
ExecStart=/home/victor-pym/文档/Project/GitCG/contribute.sh
WorkingDirectory=/home/victor-pym/文档/Project/GitCG
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

echo "Systemd timer enabled. It will fire during 08:00-22:00 with randomized delays."
echo "Timer will trigger roughly 14 times, each with randomized delay (0-30min),"
echo "and the script itself picks random delays between commits."
echo ""
echo "Status: systemctl --user status github-contribute.timer"
echo "Logs:   journalctl --user -u github-contribute"
echo "Manual: $CONTRIBUTE_SCRIPT"
