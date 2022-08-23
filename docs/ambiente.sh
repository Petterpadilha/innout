sudo apt update && sudo apt install -y curl git apache2 libapache2-mod-php php php-xml php-pgsql php-curl php-fpm php-common php-odbc php-mbstring php-mbstring php-gd postgresql postgresql-contrib default-jdk

# APACHE
sudo a2enmod rewrite
sudo rm -rf /etc/apache2/sites-available /etc/apache2/sites-enabled /etc/apache2/ports.conf
sudo mkdir /etc/apache2/vhosts
sudo sed -i '/^Include ports.conf/s/^/# /' /etc/apache2/apache2.conf
sudo sed -i 's/^IncludeOptional sites-enabled/IncludeOptional vhosts/' /etc/apache2/apache2.conf
echo -e "Listen 9003
<VirtualHost *:9003>
    DocumentRoot /home/petter-padilha/Projects/innout/public/
    <Directory /home/petter-padilha/Projects/innout/public/ >
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>" | sudo tee /etc/apache2/vhosts/inout.conf >/dev/null
sudo service apache2 restart


# PHP
PHP_DIR=$(php -v | awk NR==1'{print $2}' | cut -d '.' -f 1,2)
echo -e "error_reporting = E_ALL\ndisplay_errors = On" | sudo tee /etc/php/${PHP_DIR}/apache2/conf.d/error-conf.ini /etc/php/${PHP_DIR}/cli/conf.d/error-conf.ini >/dev/null

# COMPOSER
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer

# POSTGRES
PSQL_DIR=$(psql -V | awk NR==1'{print $3}' | cut -d '.' -f 1)
echo "host    all             all             0.0.0.0/0               md5" | sudo tee -a /etc/postgresql/${PSQL_DIR}/main/pg_hba.conf >/dev/null
sudo sed -i "s/^#listen_addresses = 'localhost'/listen_addresses = '*'/" /etc/postgresql/${PSQL_DIR}/main/postgresql.conf >/dev/null
sudo bash -c 'echo "postgres:eitapega"|chpasswd'
su - postgres -c $'psql -c "ALTER USER postgres WITH PASSWORD \'eitapega\';"'
sudo useradd -p $(openssl passwd -1 eitapega) plantae_dbadm
su - postgres -c $'psql -c "CREATE ROLE plantae_dbadm WITH SUPERUSER CREATEDB CREATEROLE LOGIN ENCRYPTED PASSWORD \'eitapega\';"'
sudo service postgresql restart


# POWER ARCHITECT
mkdir ~/.power-architect
curl -o ~/.power-architect/architect.tar.gz -OL http://download.sqlpower.ca/architect/1.0.8/community/SQL-Power-Architect-generic-jdbc-1.0.8.tar.gz
tar -vzxf ~/.power-architect/architect.tar.gz -C ~/.power-architect
mv ~/.power-architect/architect-* ~/.power-architect/architect
curl -o ~/.power-architect/architect/architect.png -OL https://github.com/SQLPower/power-architect/raw/master/src/main/resources/icons/architect128.png
echo -e "[Desktop Entry]\n
Version=1.0\n
Name=SQL Power Architect Community Edition\n
Exec=java -jar /home/${USER}/.power-architect/architect/architect.jar\n
Icon=/home/${USER}/.power-architect/architect/architect.png\n
Type=Application\n
Comment=Software for database modeling\n
Path=/home/${USER}/.power-architect/architect\n
Terminal=false\n
StartupNotify=true\n
Categories=Development;" | tee ~/.local/share/applications/sql-power-architect.desktop >/dev/null
cp ~/.local/share/applications/sql-power-architect.desktop ~/Desktop