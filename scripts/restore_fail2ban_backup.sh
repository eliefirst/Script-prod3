#!/bin/bash

BACKUP=$(ls -dt /etc/fail2ban.backup.* 2>/dev/null | head -n1)

if [[ -z "$BACKUP" ]]; then
  echo "❌ Aucun backup trouvé."
  exit 1
fi

echo "♻️ Restauration depuis : $BACKUP"

cp -r "$BACKUP"/* /etc/fail2ban/
systemctl restart fail2ban
echo "✅ Configuration restaurée depuis $BACKUP"
