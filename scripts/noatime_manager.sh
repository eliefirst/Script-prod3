#!/bin/bash

FSTAB="/etc/fstab"
BACKUP="/etc/fstab.bak.$(date +%s)"
TEMP_FSTAB="/tmp/fstab.new"

# Sauvegarde de sécurité
cp "$FSTAB" "$BACKUP"
echo "🛡️ Sauvegarde créée : $BACKUP"

# Fonction de patch compatible
function patch_mount_option() {
    local mountpoint="$1"
    local found=0

    echo "🔧 Modification de $mountpoint..."

    > "$TEMP_FSTAB"

    while read -r line; do
        if echo "$line" | grep -q "$mountpoint"; then
            found=1
            device=$(echo "$line" | awk '{print $1}')
            fstype=$(echo "$line" | awk '{print $3}')
            echo "$device $mountpoint $fstype defaults,noatime 0 1" >> "$TEMP_FSTAB"
        else
            echo "$line" >> "$TEMP_FSTAB"
        fi
    done < "$FSTAB"

    if [ "$found" -eq 1 ]; then
        mv "$TEMP_FSTAB" "$FSTAB"
        mount -o remount "$mountpoint"
        echo "✅ $mountpoint patché avec 'noatime' et remonté"
    else
        echo "❌ $mountpoint introuvable dans fstab"
        rm "$TEMP_FSTAB"
    fi
}

# Menu utilisateur
clear
echo "🚀 Gestionnaire de 'noatime' - version compatible Sed"
echo "-------------------------------------------------------"
echo "1. Activer noatime sur /var/www"
echo "2. Activer noatime sur /home"
echo "3. Activer noatime sur les deux"
echo "4. Rollback (restaurer une sauvegarde précédente)"
echo "5. Quitter"
echo "-------------------------------------------------------"
read -p "👉 Que veux-tu faire ? [1-5] : " choix

case $choix in
    1)
        patch_mount_option "/var/www"
        ;;
    2)
        patch_mount_option "/home"
        ;;
    3)
        patch_mount_option "/var/www"
        patch_mount_option "/home"
        ;;
    4)
        read -p "🗂️ Entrez le nom exact de la sauvegarde à restaurer (ex: /etc/fstab.bak.XXXX) : " bak
        cp "$bak" "$FSTAB" && mount -a
        echo "✅ Rollback effectué."
        ;;
    5)
        echo "👋 À bientôt Elie !"
        exit 0
        ;;
    *)
        echo "❌ Choix invalide."
        ;;
esac

echo "✅ Terminé."
