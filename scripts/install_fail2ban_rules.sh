#!/bin/bash

set -e

echo "📦 Installation des règles Fail2Ban personnalisées..."

# Emplacement de l'archive (à adapter si déplacée)
ARCHIVE="fail2ban_rules.tar.gz"

if [[ ! -f "$ARCHIVE" ]]; then
  echo "❌ Archive $ARCHIVE non trouvée."
  exit 1
fi

# Sauvegarde de l'existant
echo "📁 Sauvegarde de /etc/fail2ban..."
cp -r /etc/fail2ban /etc/fail2ban.backup.$(date +%F_%H-%M)

# Extraction
echo "📂 Extraction dans /etc/fail2ban..."
tar -xzvf "$ARCHIVE" -C /etc/fail2ban --strip-components=1

# Redémarrage
echo "🔄 Redémarrage du service Fail2Ban..."
systemctl restart fail2ban

# Affichage de l'état
echo "✅ État de Fail2Ban :"
fail2ban-client status
