#!/bin/bash

echo "🛡️ Sauvegarde allégée des volumes RAID système (md0 + md1 uniquement) vers /mnt/backup"

BACKUP_PATH="/mnt/backup"
DATE=$(date +%F)

RAID_DEVICES=(/dev/md0 /dev/md1)

# Vérification du dossier
if [ ! -d "$BACKUP_PATH" ]; then
  echo "📁 Création du dossier de sauvegarde : $BACKUP_PATH"
  sudo mkdir -p "$BACKUP_PATH"
fi

for RAID in "${RAID_DEVICES[@]}"; do
  NAME=$(basename $RAID)
  OUTFILE="$BACKUP_PATH/${NAME}_backup_${DATE}.img.gz"
  echo "💽 Sauvegarde de $RAID → $OUTFILE"
  sudo dd if=$RAID bs=1M status=progress conv=sync,noerror | gzip -c > "$OUTFILE"
  echo "✅ Terminé : $OUTFILE"
done

echo "📦 Sauvegarde RAID système terminée (md0 + md1 uniquement)."
