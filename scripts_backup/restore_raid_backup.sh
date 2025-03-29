#!/bin/bash

echo "🧩 Restauration d'une image RAID sauvegardée (.img.gz) sur un volume RAID (/dev/mdX)"

BACKUP_PATH="/mnt/backup"
read -p "📦 Nom du fichier de sauvegarde (.img.gz) à restaurer (ex: md1_backup_2025-03-29.img.gz) : " BACKUP_FILE

if [ ! -f "$BACKUP_PATH/$BACKUP_FILE" ]; then
  echo "❌ Fichier introuvable : $BACKUP_PATH/$BACKUP_FILE"
  exit 1
fi

read -p "📍 Volume RAID cible pour restauration (ex: /dev/md1) : " TARGET_DEV

if [ ! -b "$TARGET_DEV" ]; then
  echo "❌ Volume cible invalide ou introuvable : $TARGET_DEV"
  exit 1
fi

echo "⚠️ ATTENTION : Cette opération écrasera totalement $TARGET_DEV"
read -p "❓ Confirmer la restauration ? (y/N): " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "❌ Restauration annulée."
  exit 0
fi

echo "🔁 Restauration en cours de $BACKUP_FILE → $TARGET_DEV ..."
gunzip -c "$BACKUP_PATH/$BACKUP_FILE" | sudo dd of="$TARGET_DEV" bs=1M status=progress conv=sync,noerror

echo "✅ Restauration terminée sur $TARGET_DEV"
