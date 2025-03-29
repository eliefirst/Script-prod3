#!/bin/bash

echo "🔧 Création d'un nouvel utilisateur SSH"

read -p "👤 Nom de l'utilisateur : " USER
if [[ -z "$USER" ]]; then
  echo "❌ Le nom d'utilisateur est requis."
  exit 1
fi

read -p "🔑 Clé publique SSH (coller la ligne complète) : " PUBKEY
if [[ -z "$PUBKEY" ]]; then
  echo "❌ La clé publique est requise."
  exit 1
fi

read -p "📧 Adresse email de contact (optionnel) : " EMAIL

read -p "🔐 Ajouter cet utilisateur au groupe sudo ? [y/N] : " SUDO

# 🔓 Prompt UFW : autoriser une IP spécifique pour ce compte
read -p "🌍 Autoriser une IP spécifique à se connecter en SSH ? [y/N] : " UFW_ASK
if [[ "$UFW_ASK" =~ ^[Yy]$ ]]; then
  read -p "📝 IP à autoriser (ex: 1.2.3.4) : " UFW_IP
fi

# Créer le groupe sshusers s'il n'existe pas
if ! getent group sshusers > /dev/null; then
  echo "➕ Création du groupe sshusers..."
  sudo groupadd sshusers
fi

echo "📦 Création de l'utilisateur $USER..."
sudo adduser --disabled-password --gecos "" "$USER"
sudo usermod -aG sshusers "$USER"

if [[ "$SUDO" =~ ^[Yy]$ ]]; then
  sudo usermod -aG sudo "$USER"
  echo "✅ Ajouté au groupe sudo"
fi

echo "📂 Configuration de ~/.ssh/authorized_keys..."
sudo mkdir -p /home/$USER/.ssh
echo "$PUBKEY" | sudo tee /home/$USER/.ssh/authorized_keys > /dev/null

sudo chown -R $USER:$USER /home/$USER/.ssh
sudo chmod 700 /home/$USER/.ssh
sudo chmod 600 /home/$USER/.ssh/authorized_keys

if [[ ! -z "$EMAIL" ]]; then
  echo "$USER: $EMAIL" | sudo tee -a /etc/ssh/user_emails.txt > /dev/null
fi

if [[ ! -z "$UFW_IP" ]]; then
  echo "🔓 Ajout de la règle UFW : allow from $UFW_IP to any port 22 proto tcp"
  sudo ufw allow from "$UFW_IP" to any port 22 proto tcp
fi

echo "🔒 Mise à jour de sshd_config (AllowUsers)..."
if grep -q '^AllowUsers' /etc/ssh/sshd_config; then
  sudo sed -i "/^AllowUsers/ s/$/ $USER/" /etc/ssh/sshd_config
else
  echo "AllowUsers $USER" | sudo tee -a /etc/ssh/sshd_config > /dev/null
fi

echo "🔄 Redémarrage du service SSH..."
sudo systemctl restart ssh

echo "✅ Utilisateur $USER ajouté avec succès pour un accès SSH par clé uniquement."
