#!/bin/bash

BACKUP="/etc/ssh/sshd_config.bak.$(date +%s)"
SSH_CONFIG="/etc/ssh/sshd_config"

echo "🔐 Sauvegarde de $SSH_CONFIG -> $BACKUP"
sudo cp "$SSH_CONFIG" "$BACKUP"

echo "🌍 IP publique actuelle (à autoriser dans UFW si besoin) :"
curl -s https://ipinfo.io/ip || echo "⚠️ IP non détectée"

echo ""
echo "✅ Vérification de la clé SSH (connexion à localhost)"
echo "⚠️ Ce test est utile uniquement si ta clé publique est déjà installée sur le serveur"

if ssh -o BatchMode=yes localhost 'echo "✅ Connexion SSH réussie avec ta clé publique"' 2>/dev/null; then
    echo ""
    echo "🔧 Application des restrictions dans sshd_config..."
    sudo sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' "$SSH_CONFIG"
    sudo sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' "$SSH_CONFIG"
    sudo sed -i 's/^#*ChallengeResponseAuthentication.*/ChallengeResponseAuthentication no/' "$SSH_CONFIG"

    echo "✅ Configuration modifiée. Redémarrage de SSH..."
    sudo systemctl restart ssh

    echo "✅ SSH sécurisé. Tu peux te reconnecter uniquement avec ta clé."
else
    echo "❌ Échec de la connexion SSH par clé. Abandon de la modification."
fi
