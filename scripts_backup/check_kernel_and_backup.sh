#!/bin/bash

# Dossier de sauvegarde et fichier de version du noyau
BACKUP_DIR="/mnt/backup"
LAST_KERNEL_FILE="/tmp/last_kernel_version"
MAX_BACKUPS=5

# Obtenir la version actuelle du noyau
CURRENT_KERNEL=$(uname -r)

# Vérifier si le fichier de la dernière version du noyau existe
if [ -f "$LAST_KERNEL_FILE" ]; then
    LAST_KERNEL=$(cat "$LAST_KERNEL_FILE")
else
    LAST_KERNEL="none"
fi

# Comparer les versions du noyau
if [ "$CURRENT_KERNEL" != "$LAST_KERNEL" ]; then
    echo "Le noyau a changé ! Version actuelle : $CURRENT_KERNEL, ancienne version : $LAST_KERNEL."

    # Mettre à jour le fichier de la dernière version du noyau
    echo "$CURRENT_KERNEL" > "$LAST_KERNEL_FILE"

    # Appeler le script de sauvegarde
    /path/to/scripts/send_backup_to_remote.sh

    echo "✅ Sauvegarde effectuée pour la version du noyau : $CURRENT_KERNEL"

    # Supprimer les anciennes sauvegardes si plus de 5 sont présentes
    BACKUP_COUNT=$(ls $BACKUP_DIR/*.img.gz | wc -l)

    if [ "$BACKUP_COUNT" -gt "$MAX_BACKUPS" ]; then
        # Supprimer les fichiers les plus anciens
        echo "🔴 Plus de $MAX_BACKUPS sauvegardes. Suppression des anciennes..."

        # Liste des fichiers par ordre de date (du plus ancien au plus récent)
        OLD_BACKUPS=$(ls -t $BACKUP_DIR/*.img.gz | tail -n +$((MAX_BACKUPS + 1)))

        # Supprimer les fichiers les plus anciens
        for BACKUP in $OLD_BACKUPS; do
            rm "$BACKUP"
            echo "❌ Supprimée : $BACKUP"
        done
    fi
else
    echo "Le noyau n'a pas changé. Pas de sauvegarde nécessaire."
fi
