# ✅ TODO – Optimisation & supervision du serveur `production3`

## 🛠️ Magento / Ubuntu - Post-install

- [ ] Créer un script `postinstall_magento.sh` pour automatiser tous les réglages faits manuellement
- [ ] Générer un `logcheck_magento.sh` pour résumer : services, erreurs, ports, stockage
- [ ] Générer un script `magento_cron_health.sh` pour surveiller les jobs cron Magento
- [ ] Créer une tâche cron quotidienne pour `magento_postupdate.sh`
- [ ] Générer un rapport email lisible par Roundcube (sans logo bloquant)
- [ ] Ajouter une ligne fixe [ADMIN] dans le sujet pour repérage des mails auto
- [ ] Option future : tester envoi via SMTPUTF8 quand serveur mail prêt

## 🧠 Système - Performance & maintenance

- [ ] Monter `/tmp` en `tmpfs` (RAM) si performances nécessaires
- [x] Personnaliser `/etc/sysctl.conf` :
  - [x] `vm.swappiness = 10`
  - [ ] `fs.inotify.max_user_watches = 524288`
  - [ ] Réglages réseaux (latence, reuse, buffers)
- [ ] Créer un script `raid_check.sh` pour surveiller RAID (et envoyer alerte mail)
- [ ] Créer un script `fstab_checker.sh` pour vérifier `noatime` et options RAID
- [ ] Créer un script `disk_alert.sh` pour alerter si `/` ou `/var/www` approchent 90% d'utilisation
- [ ] Créer un `check_ssh_clients.sh` pour tester compatibilité des clés SSH (FlashFXP, Putty, FileZilla...)

## 🌐 Réseau et services de base

- [ ] Installation et configuration d’Apache 2.4
- [ ] Fail2Ban à configurer
- [ ] Activer et configurer UFW (pare-feu)
- [ ] Préparer les VirtualHosts pour Magento multiboutique :
  - B2C : `www.elielweb.com`, `en.`, `jp.`, `ru.`, `es.`, `cn.`
  - B2B : `pro.elielweb.com`, `pro.en.elielweb.com`
  - Production : `redline-boutique.com` + `pro.redline-boutique.com`
- [ ] Certbot avec options : `--apache --agree-tos --redirect --uir --hsts --staple-ocsp --must-staple`
- [ ] Créer script de sauvegarde auto de `sshd_config` avant désactivation des mots de passe
- [ ] Gérer une alerte si `authorized_keys` n’est pas présent
 
## 📜 Scripts à intégrer à la doc ou au provisionnement

- [ ] Intégrer `add_ssh_user_interactive.sh` dans la section sécurisation SSH
- [ ] Intégrer `remove_ssh_user_interactive.sh` dans la gestion des comptes
- [ ] Ajouter ces scripts dans la doc technique interne / README serveur
