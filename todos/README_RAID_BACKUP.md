# 🔐 Sauvegarde & Restauration RAID – production3

Ce serveur utilise un système RAID logiciel (mdadm) avec les volumes suivants :

- `/dev/md0` → /boot
- `/dev/md1` → /
- `/dev/md2` → /var/www (exclu des sauvegardes RAID système)
- `/dev/md3` → /home (exclu des sauvegardes RAID système)

---

## ✅ Sauvegarde : `make_raid_backup.sh`

### 📦 Ce script :
- Sauvegarde uniquement les volumes critiques du système :
  - `/dev/md0` (boot)
  - `/dev/md1` (root)
- Format : `mdX_backup_YYYY-MM-DD.img.gz`
- Destination : `/mnt/backup`

### ▶️ Exécution :
```bash
sudo ./make_raid_backup.sh
```

---

## 🔁 Restauration : `restore_raid_backup.sh`

### 🧩 Ce script :
- Demande le nom d’un fichier `.img.gz` à restaurer
- Demande le volume RAID cible (`/dev/mdX`)
- Décompresse et écrit les données via `dd`

### ▶️ Exécution :
```bash
sudo ./restore_raid_backup.sh
```

⚠️ Cette opération écrase entièrement le volume cible.

---

## 🧪 Vérification : `verify_raid_backups.sh`

- Vérifie que les fichiers `.img.gz` pour `/dev/md0` et `/dev/md1` existent
- Affiche la taille et la date de chaque archive
- Alerte si une archive est manquante

### ▶️ Exécution :
```bash
./verify_raid_backups.sh
```

---

## 📌 Notes

- Cette procédure ne sauvegarde **ni `/var/www` ni `/home`**, car elles sont gérées par des backups distincts (MySQL, fichiers, etc.)
- Sauvegardes testées avec `gzip + dd` et restaurables via mode rescue Dedibox
