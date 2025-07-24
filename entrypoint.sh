apt update
apt install zsh -y
useradd -m -s /usr/bin/zsh sites
sudo usermod -aG sudo sites
# pip install requests beautifulsoup4 --break-system-packages
chmod -R 777 /app/
rm -rf /app/database/database.sqlite
touch /app/database/database.sqlite && \
chmod -R 777 /app/database/database.sqlite
cd /app/ && composer install && \
cp .env.example .env && \
php artisan key:generate && \
# php artisan migrate:fresh --seed && \
# npm install && \
# npm run build &&
chmod -R 777 /app
sudo a2enmod rewrite
service apache2 start
service ssh start
