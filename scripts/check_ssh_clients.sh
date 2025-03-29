#!/bin/bash

echo "🔍 Vérification compatibilité clés SSH avec clients courants"
echo "-------------------------------------------------------------"

# Clé active
echo "🗝️  Clé SSH publique autorisée dans ~/.ssh/authorized_keys :"
grep -E '^(ssh-rsa|ssh-ed25519|ecdsa-sha2)' ~/.ssh/authorized_keys | awk '{print $1}' | uniq
echo ""

# Version de SSH serveur
echo "🛠️  Version OpenSSH serveur :"
sshd -V 2>&1 | head -n1
echo ""

# Clients connus
echo "📦 Clients compatibles avec les types de clés :"
echo ""
printf "%-15s %-12s %-12s %-12s\n" "Client" "ssh-rsa" "ecdsa" "ed25519"
echo "-------------------------------------------------------------"
printf "%-15s %-12s %-12s %-12s\n" "PuTTY >= 0.75" "✅" "✅" "✅"
printf "%-15s %-12s %-12s %-12s\n" "PuTTY <= 0.74" "✅" "✅" "❌"
printf "%-15s %-12s %-12s %-12s\n" "FlashFXP 5.4" "✅" "❓" "❌"
printf "%-15s %-12s %-12s %-12s\n" "FileZilla"     "✅" "✅" "✅"
printf "%-15s %-12s %-12s %-12s\n" "WinSCP"        "✅" "✅" "✅"
printf "%-15s %-12s %-12s %-12s\n" "Linux (ssh)"   "✅" "✅" "✅"

echo ""
echo "🧠 Remarque : FlashFXP 5.4 ne gère pas ed25519, privilégier ssh-rsa ou ecdsa."
