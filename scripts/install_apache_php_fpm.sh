#!/bin/bash

# Vérification si le script est exécuté en tant que root
if [ "$EUID" -ne 0 ]; then
  echo "Veuillez exécuter ce script en tant que root."
  exit 1
fi

# Mettre à jour le système
echo "Mise à jour des paquets du système..."
apt update && apt upgrade -y

# Installation d'Apache
echo "Installation d'Apache2..."
apt install apache2 -y

# Activation des modules nécessaires pour Apache
echo "Activation des modules Apache nécessaires..."
a2enmod proxy_fcgi setenvif
a2enmod rewrite

# Installation de PHP 8.3 et de PHP-FPM
echo "Installation de PHP 8.3 et PHP-FPM..."

sudo apt install -y php8.3-cli php8.3-curl php8.3-mbstring php8.3-xml php8.3-bz2 php8.3-zip php8.3-mysql php8.3-mbstring
# Redémarrer Apache pour appliquer les changements
echo "Redémarrage d'Apache2..."
systemctl restart apache2

# Configuration de PHP-FPM
echo "Configuration de PHP-FPM pour Apache..."
echo "Enregistrement de la configuration de PHP-FPM dans Apache"
cat > /etc/apache2/sites-available/000-default.conf <<EOF
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html

    <Directory /var/www/html>
        Options FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    # Configurer PHP-FPM
    <FilesMatch \.php$>
        SetHandler "proxy:unix:/var/run/php/php8.3-fpm.sock|fcgi://localhost"
    </FilesMatch>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

# Activer la configuration PHP-FPM pour Apache
echo "Activation de la configuration PHP-FPM pour Apache..."
systemctl restart apache2

# Vérification de l'installation d'Apache et PHP
echo "Vérification de l'installation..."
apache2 -v
php -v

echo "Installation et configuration terminées avec succès!"
echo "Apache et PHP-FPM sont maintenant installés et configurés."

# Recharger Apache pour appliquer la configuration
systemctl reload apache2
