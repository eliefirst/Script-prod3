#!/bin/bash

echo "🧪 Vérification des backups RAID système (.img.gz) dans /mnt/backup"

RAID_LIST=(md0 md1)
BACKUP_PATH="/mnt/backup"
DATE=$(date +%F)

MISSING=0

for RAID in "${RAID_LIST[@]}"; do
  FILE="$BACKUP_PATH/${RAID}_backup_${DATE}.img.gz"
  if [ ! -f "$FILE" ]; then
    echo "❌ Fichier manquant : $FILE"
    MISSING=1
  else
    SIZE=$(du -h "$FILE" | cut -f1)
    echo "✅ $RAID : $SIZE – $(stat -c %y "$FILE")"
  fi
done

if [ "$MISSING" -eq 1 ]; then
  echo "⚠️ Des fichiers de sauvegarde sont manquants."
  exit 1
else
  echo "✅ Tous les backups RAID système sont présents pour aujourd’hui."
fi
