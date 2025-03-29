#!/bin/bash

echo "========================="
echo "🧾 État du serveur actuel"
echo "========================="
echo ""

# Services réseau
echo "## 🌐 Réseau et services de base"
for svc in apache2 fail2ban ufw; do
  if systemctl list-unit-files | grep -q "^$svc"; then
    if systemctl is-active --quiet "$svc"; then
      echo "- [x] $svc : actif"
    else
      echo "- [ ] $svc : installé mais inactif"
    fi
  else
    echo "- [ ] $svc : non installé"
  fi
done
echo ""

# Magento
echo "## 🧰 Services liés à Magento"
if command -v php > /dev/null; then
  echo "- [x] PHP installé : $(php -v | head -n1)"
else
  echo "- [ ] PHP non installé"
fi

if command -v composer > /dev/null; then
  echo "- [x] Composer installé : $(composer --version)"
else
  echo "- [ ] Composer non installé"
fi

if systemctl is-active --quiet php8.3-fpm; then
  echo "- [x] PHP-FPM actif"
else
  echo "- [ ] PHP-FPM inactif ou non installé"
fi
echo ""

# RAID
echo "## 💾 RAID"
if cat /proc/mdstat | grep -q md0; then
  echo "- [x] RAID détecté : $(grep ^md /proc/mdstat | wc -l) volume(s)"
else
  echo "- [ ] Aucun volume RAID détecté"
fi
echo ""

# fstab noatime
echo "## 🔍 Options fstab (noatime)"
found=0
grep -E "noatime" /etc/fstab | grep -v "^#" | while read -r line; do
  echo "- [x] $line"
  found=1
done
if [ "$found" == 0 ]; then
  echo "- [ ] Aucun point de montage avec 'noatime' détecté"
fi
echo ""

# Mail
echo "## 📩 Rapport email"
if systemctl is-active --quiet postfix; then
  echo "- [x] Postfix actif"
else
  echo "- [ ] Postfix inactif ou absent"
fi

if [ -f /var/log/mail.log ]; then
  echo "- [x] /var/log/mail.log existe"
  recent_mail=$(grep "to=<elie@redline.paris>" /var/log/mail.log | tail -n 1)
  if [[ "$recent_mail" == *"status=sent"* ]]; then
    echo "- [x] Dernier mail envoyé avec succès :"
    echo "      $recent_mail"
  else
    echo "- [ ] Aucun mail envoyé avec succès récemment (ou pas à elie@redline.paris.com)"
  fi
else
  echo "- [ ] /var/log/mail.log introuvable"
fi
