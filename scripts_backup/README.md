Production3 - Sauvegarde et Restauration

Ce projet contient des scripts pour la gestion et l'automatisation des sauvegardes et des restaurations sur le serveur production3.
📦 Sauvegarde des fichiers
1. Sauvegarde du noyau et du système

Les sauvegardes complètes du noyau et du système sont créées uniquement si le noyau a été modifié. Cela évite de faire des sauvegardes inutiles chaque jour. La sauvegarde est ensuite envoyée vers un serveur de backup distant.
Fichiers nécessaires :

    check_kernel_and_backup.sh : Ce script vérifie si le noyau a été modifié par rapport à la version précédente. Si une modification est détectée, il lance la sauvegarde.

    send_backup_to_remote.sh : Ce script effectue la sauvegarde en envoyant les fichiers .img.gz du noyau et du système vers un serveur de backup distant via rsync.

    last_kernel_version : Fichier temporaire où la version du noyau précédent est stockée. Ce fichier est mis à jour après chaque sauvegarde réussie.

Procédure de sauvegarde :

    Vérifier la version du noyau : Le script check_kernel_and_backup.sh compare la version actuelle du noyau à celle précédemment enregistrée.

    Sauvegarde uniquement si le noyau a changé : Si le noyau a changé, le script send_backup_to_remote.sh est exécuté pour réaliser la sauvegarde et l'envoyer vers le serveur distant.

    Nettoyage automatique : Seules les 5 dernières sauvegardes sont conservées. Les sauvegardes plus anciennes sont automatiquement supprimées.

Exécution automatique :

Le script check_kernel_and_backup.sh est configuré pour s'exécuter tous les jours à 2h du matin via une tâche cron, ce qui garantit que les sauvegardes ne sont créées que si le noyau est modifié.

0 2 * * * /home/elie/production3/scripts_backup/check_kernel_and_backup.sh

🔄 Restauration des sauvegardes
1. Restauration à partir d'une sauvegarde précédente

Si tu as besoin de restaurer une sauvegarde précédente, tu peux utiliser les fichiers .img.gz stockés sur le serveur de backup distant.
Fichiers nécessaires :

    Fichiers de sauvegarde .img.gz : Par exemple, md0_backup_2025-03-29.img.gz, md1_backup_2025-03-29.img.gz, etc.

    restore_raid_backup.sh : Ce script permet de restaurer les fichiers de sauvegarde du serveur de backup vers les partitions du serveur local.

Procédure de restauration :

    Se connecter au serveur de backup : Assure-toi que tu peux te connecter à ton serveur de backup via SSH avec ta clé SSH.

    Télécharger la sauvegarde à restaurer : Utilise rsync ou scp pour télécharger la sauvegarde à restaurer.

    Exemple avec rsync :

rsync -avz elie@62.210.**.**:/home/elie/Backup/production3-backup-ubuntu24.04/2025-03-29/md0_backup_2025-03-29.img.gz /path/to/local/backup/

Restaurer la sauvegarde sur le serveur : Une fois la sauvegarde téléchargée, utilise dd pour restaurer l'image du disque sur la partition appropriée :

    sudo dd if=/path/to/local/backup/md0_backup_2025-03-29.img.gz of=/dev/sda bs=4M status=progress

    Remplace /dev/sda par la partition que tu souhaites restaurer.

    Redémarrer le système : Une fois la restauration terminée, redémarre le serveur pour appliquer les modifications du noyau et du système restauré.

sudo reboot

🚀 Automatisation avec Cron

Les tâches cron sont configurées pour exécuter automatiquement le script de sauvegarde check_kernel_and_backup.sh tous les jours à 2h du matin.

Si tu souhaites modifier l'heure d'exécution ou la fréquence, édite la crontab avec la commande suivante :

crontab -e

Et ajoute la ligne suivante pour exécuter le script tous les jours à 2h :

0 2 * * * /path/to/check_kernel_and_backup.sh

📚 Notes importantes

    Sauvegardes incrémentielles : Si tu souhaites implémenter une solution de sauvegarde incrémentielle, tu peux ajuster le script de sauvegarde en fonction de tes besoins.

    Espace disque : Assure-toi que ton serveur de backup dispose de suffisamment d'espace pour accueillir plusieurs versions des sauvegardes.

    Test de restauration : Il est conseillé de tester régulièrement la procédure de restauration pour s'assurer qu'elle fonctionne correctement en cas d'incident.

Résumé des fichiers nécessaires dans l’ordre chronologique :

    check_kernel_and_backup.sh : Vérifie si le noyau a changé et déclenche la sauvegarde.

    send_backup_to_remote.sh : Transfert les fichiers de sauvegarde sur le serveur distant.

    last_kernel_version : Fichier temporaire contenant la version du noyau précédent.

    Fichiers de sauvegarde : Fichiers .img.gz qui contiennent les sauvegardes des partitions ou du système.

    restore_raid_backup.sh : Script pour restaurer les sauvegardes à partir du serveur de backup.

Conclusion

Ce README.md décrit maintenant les étapes pour la gestion des sauvegardes et des restaurations de ton système avec les fichiers nécessaires et leur ordre d'exécution.
