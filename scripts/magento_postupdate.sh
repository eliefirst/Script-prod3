#!/bin/bash

LOG="/var/log/magento-postupdate.log"
DATE=$(date)

echo "MAGENTO POST-INSTALL REPORT" > "$LOG"
echo "DATE : $DATE" >> "$LOG"
echo "----------------------------------------" >> "$LOG"

# OS & Kernel
echo "[OS & Kernel]" >> "$LOG"
lsb_release -a 2>/dev/null | grep Description >> "$LOG"
uname -r >> "$LOG"
echo "" >> "$LOG"

# Versions des composants Magento
echo "[Versions logicielles]" >> "$LOG"
for cmd in php apache2 mariadb mysql composer redis-server varnishd rabbitmqctl elasticsearch opensearch; do
  if command -v $cmd > /dev/null; then
    echo "$cmd : $( $cmd -v 2>&1 | head -n1 )" >> "$LOG"
  else
    echo "$cmd : Non installe" >> "$LOG"
  fi
done
echo "" >> "$LOG"

# PHP-FPM vs mod_php
echo "[PHP-FPM vs Apache]" >> "$LOG"
if systemctl is-active --quiet php8.3-fpm; then
  echo "PHP 8.3-FPM actif" >> "$LOG"
else
  echo "PHP-FPM inactif ou absent" >> "$LOG"
fi

if apache2ctl -M 2>/dev/null | grep -q php_module; then
  echo "Attention : mod_php est active dans Apache (non compatible FPM)" >> "$LOG"
else
  echo "Aucun mod_php detecte dans Apache" >> "$LOG"
fi
echo "" >> "$LOG"

# Ports actifs
echo "[Ports ecoutes]" >> "$LOG"
ss -tulpn | grep LISTEN | awk '{print $5}' | sort | uniq >> "$LOG"
echo "" >> "$LOG"

# Statut des services critiques
echo "[Statut des services]" >> "$LOG"
for svc in apache2 php8.3-fpm mysql mariadb redis rabbitmq varnish elasticsearch opensearch; do
  if systemctl list-unit-files | grep -q "$svc"; then
    if systemctl is-active --quiet "$svc"; then
      echo "$svc : Actif" >> "$LOG"
    else
      echo "$svc : Inactif" >> "$LOG"
    fi
  else
    echo "$svc : Non installe" >> "$LOG"
  fi
done

# Infos de fin
echo "" >> "$LOG"
echo "REPORT ID: $(uuidgen)" >> "$LOG"
echo "Fin du rapport Magento - $(date)" >> "$LOG"
echo "Rapport genere dans $LOG" | tee -a "$LOG"

# Envoi du mail (ASCII only)
SUBJECT="Rapport Magento post-install - $(hostname)"
(
  echo "From: Elie <elie@redline.paris>"
  echo "To: Elie <elie@redline.paris>"
  echo "Subject: $SUBJECT"
  echo "MIME-Version: 1.0"
  echo "Content-Type: text/plain; charset=us-ascii"
  echo ""
  cat "$LOG"
) | /usr/sbin/sendmail -t

echo "Mail envoye (us-ascii)" | tee -a "$LOG"
