# 🧾 TODO réalisé – Configuration actuelle du serveur `production3`

## 🛠️ Système Ubuntu

- [x] Installation Ubuntu 24.04.2 LTS
- [x] Configuration du RAID :
  - RAID1 pour `/` et `/var/www`
  - RAID0 pour `/home`
  - Partitions séparées : `/boot`, `/boot/efi`, `/home`, `/var/www`
- [x] Ajout des options `noatime` sur `/var/www` et `/home`
- [x] Configuration du swap sur partition dédiée
- [x] Vérification `rsyslog` et activation de `/var/log/mail.log`
- [x] Nettoyage des scripts pour compatibilité ASCII (sans SMTPUTF8)

## 📩 Mails système (lié à `production3` uniquement)

- [x] Postfix installé et fonctionnel
- [x] Envoi de mails locaux via `sendmail`
- [x] Script `magento_postupdate.sh` fonctionnel (version ASCII compatible)
- [x] Script `magento_postupdate_html.sh` fonctionnel avec logo distant (HTML + ASCII)

## 🧰 Scripts et maintenance

- [x] Génération du fichier TODO principal (`TODO_production3.md`)
- [x] Nettoyage et préparation pour cron, backups et supervision
 
## 🔐 Sécurité : Fail2Ban

- [x] Fail2Ban installé et activé
- [x] Jails configurées :
  - [x] SSH
  - [x] Apache Auth
  - [x] Magento (bruteforce /admin)
  - [x] phpMyAdmin (tentatives non autorisées)
  - [x] Scan massif / 404 (badbots génériques)
- [x] IP 88.175.7.181 ajoutée dans `ignoreip` (whitelist)
- [x] Configuration des emails d'alerte (via `action_mwl`, en attente finalisation serveur mail)
- [x] Crontab root : redémarrage automatique de Fail2Ban si inactif (`systemctl is-active || restart`)
- [x] Script de restauration rapide `restore_fail2ban_backup.sh` généré et déployé

## 👤 Gestion des utilisateurs SSH (version finale)

- [x] Script `add_ssh_user_interactive.sh` :
  - [x] Saisie interactive : nom, clé publique, email (optionnel)
  - [x] Création du home utilisateur
  - [x] Ajout automatique dans le groupe `sshusers` (créé si absent)
  - [x] Ajout optionnel dans le groupe `sudo`
  - [x] Ajout automatique dans `AllowUsers`
  - [x] Ajout interactif d'une règle UFW (IP → port 22)
  - [x] Redémarrage de SSH
  - [x] Log de l'email dans `/etc/ssh/user_emails.txt`

- [x] Script `remove_ssh_user_interactive.sh` :
  - [x] Saisie interactive du nom d'utilisateur
  - [x] Confirmation avant exécution
  - [x] Suppression du compte et de son home
  - [x] Suppression dans `AllowUsers`
  - [x] Nettoyage de l'email dans `user_emails.txt`
  - [x] Suppression optionnelle de la règle UFW liée à l'IP
  - [x] Redémarrage de SSH
