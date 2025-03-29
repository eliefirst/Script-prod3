#!/bin/bash

LOGFILE="/var/log/mail.log"
RSYSLOG_CONF="/etc/rsyslog.d/99-mail-log.conf"

echo "🔧 Création ou vérification du fichier log..."
sudo touch "$LOGFILE"
sudo chown syslog:adm "$LOGFILE"
sudo chmod 640 "$LOGFILE"
echo "✅ $LOGFILE prêt."

echo "🔧 Configuration rsyslog pour forcer l’écriture mail.*"
cat <<EOF | sudo tee "$RSYSLOG_CONF" > /dev/null
$template mailFormat,"/var/log/mail.log"
if \$syslogfacility-text == 'mail' then {
  action(type="omfile" file="/var/log/mail.log")
  stop
}
EOF

echo "🔄 Redémarrage de rsyslog..."
sudo systemctl restart rsyslog

echo "📤 Envoi d’un mail de test pour alimenter le log..."
echo "mail log test" | mail -s "test mail log auto" elie@redline.paris

sleep 2
echo "📄 Contenu de fin de log :"
sudo tail -n 10 "$LOGFILE"
