#!/bin/bash

echo "🗑️ Suppression interactive d'un utilisateur SSH"

read -p "👤 Nom de l'utilisateur à supprimer : " USER
if [[ -z "$USER" ]]; then
  echo "❌ Le nom d'utilisateur est requis."
  exit 1
fi

echo "⚠️ Attention : l'utilisateur $USER sera supprimé avec son dossier personnel, sa clé, et sa référence dans sshd_config."

read -p "❓ Confirmer la suppression ? [y/N] : " CONFIRM
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
  echo "❌ Annulation de la suppression."
  exit 0
fi

echo "🗑️ Suppression de l'utilisateur $USER..."

# Supprimer l'utilisateur et son home
sudo deluser --remove-home "$USER"

# Nettoyage de sshd_config
echo "✂️ Nettoyage de sshd_config (AllowUsers)..."
if grep -q "^AllowUsers" /etc/ssh/sshd_config; then
  sudo sed -i "/^AllowUsers/ s/\\b$USER\\b//g" /etc/ssh/sshd_config
  sudo sed -i "/^AllowUsers/ s/  / /g" /etc/ssh/sshd_config
  sudo sed -i "/^AllowUsers/ s/AllowUsers *$//d" /etc/ssh/sshd_config
fi

# Nettoyage du fichier email
echo "🧹 Suppression de l'email dans /etc/ssh/user_emails.txt (si présent)..."
sudo sed -i "/^$USER: /d" /etc/ssh/user_emails.txt 2>/dev/null || true

# Supprimer une règle UFW liée à l'IP SSH si souhaité
read -p "🌍 Souhaitez-vous supprimer une règle UFW pour une IP liée à ce compte ? [y/N] : " REMOVE_UFW
if [[ "$REMOVE_UFW" =~ ^[Yy]$ ]]; then
  read -p "📝 IP à supprimer de UFW (ex: 1.2.3.4) : " UFW_IP
  if [[ -n "$UFW_IP" ]]; then
    echo "🔓 Suppression de la règle : allow from $UFW_IP to any port 22 proto tcp"
    sudo ufw delete allow from "$UFW_IP" to any port 22 proto tcp
  else
    echo "❌ Aucune IP fournie. Règle UFW non supprimée."
  fi
fi

# Redémarrer SSH
echo "🔄 Redémarrage du service SSH..."
sudo systemctl restart ssh

echo "✅ Utilisateur $USER supprimé proprement."
