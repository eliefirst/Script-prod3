#!/bin/bash

LOG="/var/log/magento-optimize.log"
SYSCTL_CONF="/etc/sysctl.d/99-magento.conf"
FSTAB="/etc/fstab"

echo "🚀 Démarrage de l'optimisation serveur Magento" | tee -a "$LOG"
date | tee -a "$LOG"
echo "----------------------------------------" | tee -a "$LOG"

# Sauvegardes
cp "$FSTAB" "$FSTAB.bak.$(date +%s)"
cp /etc/sysctl.conf "/etc/sysctl.conf.bak.$(date +%s)"
echo "✅ Sauvegardes créées" | tee -a "$LOG"

# TMPFS pour /tmp
if ! grep -q "/tmp tmpfs" "$FSTAB"; then
  echo "tmpfs /tmp tmpfs defaults,noatime,nosuid,size=1G 0 0" >> "$FSTAB"
  echo "✅ Ajout de /tmp en RAM (tmpfs 1G)" | tee -a "$LOG"
else
  echo "ℹ️ /tmp est déjà monté avec tmpfs" | tee -a "$LOG"
fi

# Paramètres sysctl pour Magento
echo "🔧 Configuration sysctl" | tee -a "$LOG"
cat <<EOF > "$SYSCTL_CONF"
vm.swappiness=10
fs.inotify.max_user_watches=524288
EOF
sysctl --system > /dev/null
echo "✅ Paramètres sysctl appliqués" | tee -a "$LOG"

# Modules Apache recommandés
echo "🔧 Activation des modules Apache" | tee -a "$LOG"
a2enmod deflate expires headers http2 > /dev/null
echo "✅ Modules Apache activés : deflate, expires, headers, http2" | tee -a "$LOG"

# Configuration Redis si présent
if [ -f /etc/redis/redis.conf ]; then
  echo "🔧 Configuration Redis détectée" | tee -a "$LOG"
  sed -i 's/^# *maxmemory .*/maxmemory 512mb/' /etc/redis/redis.conf
  sed -i 's/^# *maxmemory-policy .*/maxmemory-policy allkeys-lru/' /etc/redis/redis.conf
  echo "✅ Redis configuré (maxmemory 512mb, policy allkeys-lru)" | tee -a "$LOG"
  systemctl restart redis && echo "🔄 Redis redémarré" | tee -a "$LOG"
else
  echo "⚠️ Redis non installé, configuration ignorée" | tee -a "$LOG"
fi

echo "----------------------------------------" | tee -a "$LOG"
echo "✅ Optimisation système terminée" | tee -a "$LOG"
echo "📎 Reboot conseillé pour appliquer tmpfs (/tmp)" | tee -a "$LOG"
