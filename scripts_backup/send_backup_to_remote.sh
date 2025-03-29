#!/bin/bash

# === Paramètres ===
REMOTE_USER="elie"
REMOTE_HOST="62.210.124.12"
REMOTE_BASE_DIR="/home/elie/Backup/production3-backup-ubuntu24.04"
LOCAL_BACKUP_DIR="/mnt/backup"
TODAY=$(date +%F)

# === Lecture argument dry-run ===
DRYRUN=""
if [[ "$1" == "--dry-run" ]]; then
  DRYRUN="--dry-run"
  echo "🔍 Mode simulation activé (dry-run)"
fi

# === Vérification des fichiers à envoyer ===
FILES=$(find "$LOCAL_BACKUP_DIR" -name "*.img.gz")
if [[ -z "$FILES" ]]; then
  echo "❌ Aucun fichier .img.gz trouvé dans $LOCAL_BACKUP_DIR"
  exit 1
fi

# === Création du dossier distant daté ===
REMOTE_TARGET="$REMOTE_BASE_DIR/$TODAY"

echo "📡 Envoi des sauvegardes vers : $REMOTE_USER@$REMOTE_HOST:$REMOTE_TARGET"

# Crée le dossier distant si nécessaire
ssh "$REMOTE_USER@$REMOTE_HOST" "mkdir -p '$REMOTE_TARGET'"

# Envoi des fichiers avec rsync
for FILE in $FILES; do
  echo "🚀 Envoi de $(basename "$FILE")..."
  rsync -avz $DRYRUN -e ssh "$FILE" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_TARGET/"
done

echo "✅ Transfert terminé $([[ -n "$DRYRUN" ]] && echo '(dry-run)' || echo '')"
