# 🧠 TODO_kernel_system.md – Production3

## 🔐 Sauvegarde & Restauration RAID

- [x] Script `make_raid_backup.sh` pour sauvegarde de md0 + md1
- [x] Script `restore_raid_backup.sh` pour restauration d'une partition RAID
- [x] Script `verify_raid_backups.sh` pour contrôle journalier
- [x] Documentation complète `README_RAID_BACKUP.md`
- [x] Script `send_backup_to_remote.sh` avec support --dry-run
- [x] Test complet en dry-run effectué
- [x] Intégration dans une archive `raid_backup_kit.tar.gz`

## 📚 Documentation & Vérification

- [x] Ajout du fichier `README_RAID_BACKUP.md` pour doc complète des scripts
- [x] Script `verify_raid_backups.sh` mis à jour avec md0 + md1 uniquement

## ⚙️ Configuration système

- [ ] Nettoyer les modules inutiles (`apt autoremove`, purge anciennes libs)
- [ ] Optimiser GRUB : supprimer anciennes entrées et noyaux inutiles
- [ ] Installer `unattended-upgrades` pour patchs automatiques
- [ ] Créer une image système tar.gz (`/boot` + `/` uniquement)
- [ ] Créer un script de restauration complète `restore_full_system.sh`
- [ ] Ajouter une rotation automatique ou purge des vieux `.img.gz`
- [ ] Créer un cron mensuel pour `make_raid_backup.sh` + `send_backup_to_remote.sh`

