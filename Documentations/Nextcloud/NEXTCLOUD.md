---
sort: 1
---

# NEXTCLOUD GUIDE






Installation based on LEMP Linux Nginx MariaDB PHP

Optimized and hardened with Redis Server, Let's Encrypt, Fail2ban & uncomplicated firewall (ufw)

> This guide describes Nextcloud installation configuration and basic hardening on Ubuntu or Debian. We will be using a combination of *Linux, Nginx, MySQL* and *PHP (LEMP Stack)* as the basic components for deploying our web service. 
>
> It is also implementing other components such as :
>
> - **Let's Encrypt - SSL**
> - **Redis Server - Cached Memory**
> - **Fail2ban**
> - **ufw Firewall System**
>
> By following this guide, you will have to edit the values in the code blocks to make sure it is set accordingly to your setup - e.g. : ***your.domain.ca*** or ***192.168.1.x***, should be change.
>
> [Nextcloud Requiremenents and configuration guide can be found here](https://docs.nextcloud.com/server/latest/admin_manual/installation/system_requirements.html#server)




## Preparation and installation of Nginx web Server



We start by updating our system and doing our required upgrades

```shell
sudo apt update -y && sudo apt upgrade -y
```

We need to install the following packages for the web server

```shell
sudo apt install curl git gnupg2 lsb-release ssl-cert ca-certificates apt-transport-https tree locate software-properties-common dirmngr screen htop net-tools zip unzip bzip2 ffmpeg ghostscript libfile-fcntllock-perl libfontconfig1 libfuse2 socat -y
```



Associate your server name in the hosts file and the hostname file. You can start by editing the hosts file

```shell
sudo nano /etc/hosts
```

Edit the following based on your environment
(Optional) Depending on your network setup, sometime it can be necessary to point out the host for nginx here.

```shell
127.0.0.1 localhost
127.0.1.1 nextcloud.exemple.ca
192.168.1.25 nextcloud.exemple.ca

#The The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
<externe IP> nextcloud.exemple.ca
```

Edit your hostname file

```shell
sudo nano /etc/hostname
```

Change the following with your server name - *should be FQDN*

```shell
nextcloud.exemple.com
```

> It should be note that the static configuration of domain name server is not necessary in most cases. If you have some type of domain name server, administrated by you or via proxy - *like cloudflare* - than you don't need to modifiy those files.

We can now reboot the system so the new server name can be accessible

```shell
sudo reboot now
```





After the system restart, we need to correct the sources list. This way, we’ll make sure our server is getting the current releases of the respective packages from repositories. 
Go to the folling directory :

```shell
cd /etc/apt/sources.list.d
```

If necessary, correct the DNS resolution first

```shell
sudo rm -f /etc/resolv.conf
sudo ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf
sudo systemctl restart systemd-resolved.service
```



To make editing our sources list files, we can switch to root user. (Proceed with caution if you switch to root)
To change to root user

```shell
sudo -s
```



Enter the software sources for nginx, PHP and MariaDB :

```shell
echo "deb http://nginx.org/packages/mainline/ubuntu $(lsb_release -cs) nginx" | tee nginx.list
```

```shell
echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu $(lsb_release -cs) main" | tee php.list
```

```shell
echo "deb https://mirror.its.dal.ca/mariadb/repo/10.6/ubuntu $(lsb_release -cs) main" | tee mariadb.list
```

In order to be able to trust these sources, we use the corresponding keys :

**PHP-Key :**

```shell
apt-key adv --recv-keys --keyserver hkps://keyserver.ubuntu.com:443 4F4EA0AAE5267A6C
```

**NGINX-Key :**

```shell
curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -
```

**MariaDB-Key :**

```shell
apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
```

Update your system

```shell
apt update -y
```

Logout of root

```shell
exit
```

And make your temporary self-signed certificates

```shell
sudo make-ssl-cert generate-default-snakeoil -y
```

To ensure that no relics from previous installations disrupt the operation of the web server, we remove them

```shell
sudo apt remove nginx nginx-extras nginx-common nginx-full -y --allow-change-held-packages
```

Make sure to disable and shutdown Apache2. Avoiding this step can really messed up your server.

```shell
sudo systemctl stop apache2.service && sudo systemctl disable apache2.service
```

You can now install Nginx package

```shell
sudo apt install -y nginx
```

After that, we enable nginx to start automatically after a restart of shutdown

```shell
sudo systemctl enable nginx.service
```

With our future configuration already written down, we will simply back up our default configuration files and paste the new one from here with nano text editor

```shell
sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak && sudo touch /etc/nginx/nginx.conf
```

```shell
sudo nano /etc/nginx/nginx.conf
```



Copy and paste the following configurations. Make sure to edit the values so it'll fit your environments

> In this configuration, you probably just need to change the `set_real_ip_from xxx.xxx.yyy.yyy/zz` lines

```shell
user www-data;
worker_processes auto;
pid /var/run/nginx.pid;
events {
worker_connections 1024;
multi_accept on; use epoll;
}
http {
server_names_hash_bucket_size 64;
access_log /var/log/nginx/access.log;
error_log /var/log/nginx/error.log warn;
set_real_ip_from 127.0.0.1;
# Optional if you need to specify subnets access
# set_real_ip_from 192.168.2.0/24;
real_ip_header X-Forwarded-For;
real_ip_recursive on;
include /etc/nginx/mime.types;
default_type application/octet-stream;
sendfile on;
send_timeout 3600;
tcp_nopush on;
tcp_nodelay on;
open_file_cache max=500 inactive=10m;
open_file_cache_errors on;
keepalive_timeout 65;
reset_timedout_connection on;
server_tokens off;
resolver 127.0.0.53 valid=30s;
resolver_timeout 5s;
include /etc/nginx/conf.d/*.conf;
include /etc/nginx/sites-enabled/*.conf;
}
```

Finally, we should restart Nginx service for the new configurations to be effective immediatly

```shell
sudo service nginx restart 
```



Now, we need to create the following directories. The first one is gonna be our filesystem where our users will store their files. The rest of them are used for SSL managments by *Let's Encrypt*.

```shell
sudo mkdir -p /var/nc-data /var/www/letsencrypt/.well-known/acme-challenge /etc/letsencrypt/rsa-certs /etc/letsencrypt/ecc-certs
```

Change ownership of the following folders to let them be used and manage by `www-data`

```shell
sudo chown -R www-data:www-data /var/nc-data /var/www
```











## Installation and configuration of PHP 8.0 (fpm)





Install PHP different modules

```shell
sudo apt update && sudo apt install php8.0-fpm php8.0-gd php8.0-mysql php8.0-curl php8.0-xml php8.0-zip php8.0-intl php8.0-mbstring php8.0-bz2 php8.0-ldap php8.0-apcu php8.0-bcmath php8.0-gmp php8.0-imagick php8.0-igbinary php8.0-redis php8.0-smbclient php8.0-cli php8.0-common php8.0-opcache php8.0-readline imagemagick -y
```

These are (**optionals**) and used for Samba CIFS and LDAP shares

```shell
sudo apt install ldap-utils nfs-common cifs-utils
```



Make your timezone correct. Funny enough, this can cause a lot of problems when hardening our server

```shell
sudo timedatectl set-timezone America/Montreal
```





> *Brief remark about the following lines - Instead of using sudo every time you call the same basic operation, we can switch to root user using **sudo -i**. If you don't simply add sudo infront of all the following commands.*

```shell
sudo -i
```

As we did with Nginx, we will backup all the configuration files before messing with those

```shell
cp /etc/php/8.0/fpm/pool.d/www.conf /etc/php/8.0/fpm/pool.d/www.conf.back
```

```shell
cp /etc/php/8.0/fpm/php-fpm.conf /etc/php/8.0/fpm/php-fpm.conf.back
```

```shell
cp /etc/php/8.0/fpm/php-fpm.conf /etc/php/8.0/fpm/php-fpm.conf.back
```

```shell
cp /etc/php/8.0/cli/php.ini /etc/php/8.0/cli/php.ini.back
```

```shell
cp /etc/php/8.0/fpm/php.ini /etc/php/8.0/fpm/php.ini.back
```

```shell
cp /etc/php/8.0/fpm/php-fpm.conf /etc/php/8.0/fpm/php-fpm.conf.back
```

```shell
cp /etc/php/8.0/mods-available/apcu.ini /etc/php/8.0/mods-available/apcu.ini.back
```

```shell
cp /etc/ImageMagick-6/policy.xml /etc/ImageMagick-6/policy.xml.back
```



> Use the following code for PHP to be adapted to your environment. It is not necessary but using it for calculating memory parameters is simple and will benefits overall operations time.
>

```shell
AvailableRAM=$(awk '/MemAvailable/ {printf "%d", $2/1024}' /proc/meminfo)
AverageFPM=$(ps --no-headers -o 'rss,cmd' -C php-fpm8.0 | awk '{ sum+=$1 } END { printf ("%d\n", sum/NR/1024,"M") }')
FPMS=$((AvailableRAM/AverageFPM))
PMaxSS=$((FPMS*2/3))
PMinSS=$((PMaxSS/2))
PStartS=$(((PMaxSS+PMinSS)/2))
```



> For PHP-fpm environment variables and basic settings

```shell
sed -i "s/;env[HOSTNAME] = /env[HOSTNAME] = /" /etc/php/8.0/fpm/pool.d/www.conf
```

```shell
sed -i "s/;env[TMP] = /env[TMP] = /" /etc/php/8.0/fpm/pool.d/www.conf
```

```shell
sed -i "s/;env[TEMP] = /env[TEMP] = /" /etc/php/8.0/fpm/pool.d/www.conf
```

```shell
sed -i "s/;env[TMPDIR] = /env[TMPDIR] = /" /etc/php/8.0/fpm/pool.d/www.conf
```

```shell
sed -i "s/;env[PATH] = /env[PATH] = /" /etc/php/8.0/fpm/pool.d/www.conf
```

```shell
sed -i 's/pm.max_children =.*/pm.max_children = '$FPMS'/' /etc/php/8.0/fpm/pool.d/www.conf
```

```shell
sed -i 's/pm.start_servers =.*/pm.start_servers = '$PStartS'/' /etc/php/8.0/fpm/pool.d/www.conf
```

```shell
sed -i 's/pm.min_spare_servers =.*/pm.min_spare_servers = '$PMinSS'/' /etc/php/8.0/fpm/pool.d/www.conf
```

```shell
sed -i 's/pm.max_spare_servers =.*/pm.max_spare_servers = '$PMaxSS'/' /etc/php/8.0/fpm/pool.d/www.conf
```

```shell
sed -i "s/;pm.max_requests =.*/pm.max_requests = 1000/" /etc/php/8.0/fpm/pool.d/www.conf
```

```shell
sed -i "s/allow_url_fopen =.*/allow_url_fopen = 1/" /etc/php/8.0/fpm/php.ini
```





> For PHP-cli basing settings

```shell
sed -i "s/output_buffering =.*/output_buffering = 'Off'/" /etc/php/8.0/cli/php.ini
```

```shell
sed -i "s/max_execution_time =.*/max_execution_time = 3600/" /etc/php/8.0/cli/php.ini
```

```shell
sed -i "s/max_input_time =.*/max_input_time = 3600/" /etc/php/8.0/cli/php.ini
```

```shell
sed -i "s/post_max_size =.*/post_max_size = 10240M/" /etc/php/8.0/cli/php.ini
```

```shell
sed -i "s/upload_max_filesize =.*/upload_max_filesize = 10240M/" /etc/php/8.0/cli/php.ini
```

```shell
sed -i "s/;date.timezone.*/date.timezone = America\/\Montreal/" /etc/php/8.0/cli/php.ini
```





> Those are for memory, cache and operation policies

```shell
sed -i "s/memory_limit = 128M/memory_limit = 1024M/" /etc/php/8.0/fpm/php.ini
```

```shell
sed -i "s/output_buffering =.*/output_buffering = 'Off'/" /etc/php/8.0/fpm/php.ini
```

```shell
sed -i "s/max_execution_time =.*/max_execution_time = 3600/" /etc/php/8.0/fpm/php.ini
```

```shell
sed -i "s/max_input_time =.*/max_input_time = 3600/" /etc/php/8.0/fpm/php.ini
```

```shell
sed -i "s/post_max_size =.*/post_max_size = 10240M/" /etc/php/8.0/fpm/php.ini
```

```shell
sed -i "s/upload_max_filesize =.*/upload_max_filesize = 10240M/" /etc/php/8.0/fpm/php.ini
```

```shell
sed -i "s/;date.timezone.*/date.timezone = America\/\Montreal/" /etc/php/8.0/fpm/php.ini
```

```shell
sed -i "s/;session.cookie_secure.*/session.cookie_secure = True/" /etc/php/8.0/fpm/php.ini
```

```shell
sed -i "s/;opcache.enable=.*/opcache.enable=1/" /etc/php/8.0/fpm/php.ini
```

```shell
sed -i "s/;opcache.enable_cli=.*/opcache.enable_cli=1/" /etc/php/8.0/fpm/php.ini
```

```shell
sed -i "s/;opcache.memory_consumption=.*/opcache.memory_consumption=128/" /etc/php/8.0/fpm/php.ini
```

```shell
sed -i "s/;opcache.interned_strings_buffer=.*/opcache.interned_strings_buffer=8/" /etc/php/8.0/fpm/php.ini
```

```shell
sed -i "s/;opcache.max_accelerated_files=.*/opcache.max_accelerated_files=10000/" /etc/php/8.0/fpm/php.ini
```

```shell
sed -i "s/;opcache.revalidate_freq=.*/opcache.revalidate_freq=1/" /etc/php/8.0/fpm/php.ini
```

```shell
sed -i "s/;opcache.save_comments=.*/opcache.save_comments=1/" /etc/php/8.0/fpm/php.ini
```





> Emergency settings

```shell
sed -i "s|;emergency_restart_threshold.*|emergency_restart_threshold = 10|g" /etc/php/8.0/fpm/php-fpm.conf
```

```shell
sed -i "s|;emergency_restart_interval.*|emergency_restart_interval = 1m|g" /etc/php/8.0/fpm/php-fpm.conf
```

```shell
sed -i "s|;process_control_timeout.*|process_control_timeout = 10|g" /etc/php/8.0/fpm/php-fpm.conf
```



> Activate apcu module

```shell
sed -i '$aapc.enable_cli=1' /etc/php/8.0/mods-available/apcu.ini
```





> ImageMagick policy settings for different document formats

```shell
sed -i "s/rights=\"none\" pattern=\"PS\"/rights=\"read|write\" pattern=\"PS\"/" /etc/ImageMagick-6/policy.xml
```

```shell
sed -i "s/rights=\"none\" pattern=\"EPS\"/rights=\"read|write\" pattern=\"EPS\"/" /etc/ImageMagick-6/policy.xml
```

```shell
sed -i "s/rights=\"none\" pattern=\"PDF\"/rights=\"read|write\" pattern=\"PDF\"/" /etc/ImageMagick-6/policy.xml
```

```shell
sed -i "s/rights=\"none\" pattern=\"XPS\"/rights=\"read|write\" pattern=\"XPS\"/" /etc/ImageMagick-6/policy.xml
```



Finally, we can restart php8.0 service and nginx service. Also we should enable php to startup on his own like we did with nginx

```shell
systemctl enable php8.0-fpm
```

```shell
systemctl restart php8.0-fpm
```

```shell
systemctl restart nginx
```









## Installation and configuration of MariaDB



> *This part is written as if you were no longer logged in as root. So we will be using **sudo.** Please make sure that you are not using **sudo** elevated commands while being still connected as **root**. You can logout of root simply by carrying out the command **logout** or **exit**.*

```shell
exit
```







We will now update and install our database server - MariaDB

```shell
sudo apt update && sudo apt install mariadb-server -y
```

Let us harden the database server using the supplied tool `mysql_secure_installation`. When installing for the first time, there is no root password, so you can confirm the query by pressing `ENTER`. It is recommended to set a password directly, the corresponding dialog appears automatically 

```mariadb
mysql_secure_installation
```

The following set of questions will appear and needs to be filled out.

```
Enter current password for root (enter for none): <ENTER> or type the <password> 

Switch to unix_socket authentication [Y/n] Y

Set root password? [Y/n] Y
Remove anonymous users? [Y/n] Y
Disallow root login remotely? [Y/n] Y
Remove test database and access to it? [Y/n] Y
Reload privilege tables now? [Y/n] Y
```





Now stop the database server and then save the standard configuration so that you can make adjustments immediately afterwards

```shell
sudo systemctl stop mariadb
```



```shell
sudo mv /etc/mysql/my.cnf /etc/mysql/my.cnf.back 
```

```shell
sudo nano /etc/mysql/my.cnf
```





You can now copy the following configuration into the now new empty `my.cnf` file

```mariadb
[client]
default-character-set = utf8mb4
port = 3306
socket = /var/run/mysqld/mysqld.sock

[mysqld_safe]
log_error=/var/log/mysql/mysql_error.log
nice = 0
socket = /var/run/mysqld/mysqld.sock

[mysqld]
basedir = /usr
bind-address = 127.0.0.1
binlog_format = ROW
bulk_insert_buffer_size = 16M
character-set-server = utf8mb4
collation-server = utf8mb4_general_ci
concurrent_insert = 2
connect_timeout = 5
datadir = /var/lib/mysql
default_storage_engine = InnoDB
expire_logs_days = 2
general_log_file = /var/log/mysql/mysql.log
general_log = 0
innodb_buffer_pool_size = 1024M
innodb_buffer_pool_instances = 1
innodb_flush_log_at_trx_commit = 2
innodb_log_buffer_size = 32M
innodb_max_dirty_pages_pct = 90
innodb_file_per_table = 1
innodb_open_files = 400
innodb_io_capacity = 4000
innodb_flush_method = O_DIRECT
innodb_read_only_compressed=0
key_buffer_size = 128M
lc_messages_dir = /usr/share/mysql
lc_messages = en_US
log_bin = /var/log/mysql/mariadb-bin
log_bin_index = /var/log/mysql/mariadb-bin.index
log_error = /var/log/mysql/mysql_error.log
log_slow_verbosity = query_plan
log_warnings = 2
long_query_time = 1
max_allowed_packet = 16M
max_binlog_size = 100M
max_connections = 200
max_heap_table_size = 64M
myisam_recover_options = BACKUP
myisam_sort_buffer_size = 512M
port = 3306
pid-file = /var/run/mysqld/mysqld.pid
query_cache_limit = 2M
query_cache_size = 64M
query_cache_type = 1
query_cache_min_res_unit = 2k
read_buffer_size = 2M
read_rnd_buffer_size = 1M
skip-external-locking
skip-name-resolve
slow_query_log_file = /var/log/mysql/mariadb-slow.log
slow-query-log = 1
socket = /var/run/mysqld/mysqld.sock
sort_buffer_size = 4M
table_open_cache = 400
thread_cache_size = 128
tmp_table_size = 64M
tmpdir = /tmp
transaction_isolation = READ-COMMITTED
#unix_socket=OFF
user = mysql
wait_timeout = 600

[mysqldump]
max_allowed_packet = 16M
quick
quote-names

[isamchk]
key_buffer = 16M
```

We can now restart the service for the new configuration to take effect

```shell
sudo systemctl restart mariadb
```



Log in to *MariaDB* with the previously created account and password 

```shell
sudo mysql -uroot -p
```

> The following lines should be insert and modify accordingly to the information you will be using. You should change specifically these entries :

**newdatabasename :** Type a name for identification of the new database
**useraccount :** This create an account to administrate the previous database when we grant privileges
**mysecretpassword :** Type a password for the previous *useraccount* authentication

**DON’T FORGET TO OMMIT TO WRITE THE “< / >” BELLOW**

```markdown
CREATE DATABASE <newdatabasename> CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE USER <useraccount>@localhost identified by '<mysecretpassword>';
GRANT ALL PRIVILEGES on <newdatabasename>.* to <useraccount>@localhost;
FLUSH privileges;
quit;
```



We can enable **MariaDB** service at startup. Also, it's probably a good idea to make sure we did not make any mistake by issuing a  `systemctl` command. 

```shell
sudo systemctl enable mariadb
```



```shell
sudo systemctl status mariadb
```



## Installation and configuration of Redis-Server



> Redis is used as a cache-memory server and, therefore, increase our web server overall performance by reducing the load on our database previously created. 





To install redis, simply issue the following. You should backup the default file.conf as we did before

```shell
sudo apt update && sudo apt install redis-server -y
```

```shell
sudo cp /etc/redis/redis.conf /etc/redis/redis.conf.back
```



Modify the configuration file of redis using **`sed`** command

```shell
sudo sed -i "s/port 6379/port 0/" /etc/redis/redis.conf
```

```shell
sudo sed -i s/\#\ unixsocket/\unixsocket/g /etc/redis/redis.conf
```



```shell
sudo sed -i "s/unixsocketperm 700/unixsocketperm 770/" /etc/redis/redis.conf
```

```shell
sudo sed -i "s/# maxclients 10000/maxclients 512/" /etc/redis/redis.conf
```



Add `www-data` user to `redis` group

```shell
sudo usermod -aG redis www-data
```

We backup `sysctl.conf` file and we a simple line using `sed`

```shell
sudo cp /etc/sysctl.conf /etc/sysctl.conf.back
```



```shell
sudo sed -i '$avm.overcommit_memory = 1' /etc/sysctl.conf 
```



Enable Redis server at boot

```shell
sudo systemctl enable redis-server
```

It could be a good time for rebooting our system so all the configuration is read again.

```shell
sudo reboot now
```

> We basically are done with the LEMP stack installation. We can now start Nextcloud actual configuration and installation.









## Installation and optimization of Nextcloud with SSL





We will now set up our virtual hosts inside server configuration files. Save the standard vhost file named `default.conf` and create empty vHost files for configuration.

```shell
sudo [ -f /etc/nginx/conf.d/default.conf ] && sudo mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.back
```



```shell
sudo touch /etc/nginx/conf.d/default.conf
```

```shell
sudo touch /etc/nginx/conf.d/http.conf
```

```shell
sudo touch /etc/nginx/sites-available/nextcloud.conf
```

> *We have created here three files :*
>
> *A blank default.conf file to ensure stability of Nextcloud operation. While default.conf is supposed to be inside <conf**.d**/> directory, we want to avoid our system reading our configuration as misconfigured.*
>
> *A file named http.conf is created for the integration of a virtualhost that redirect standard hypertext transfer protocol **HTTP** communication to the secured protocol **HTTPS**. We will be using this file redirection with Let's Encrypt **SSL** certificates.*
>
> *The last one, nextcloud.conf, is our vhost file for nextcloud server.*



We edit `http.conf` file. Copy and paste this configuration and change it to reflect your server.

> You should edit the `server_name nextcloud.exemple.ca` line by change it with your own domain name

```shell
sudo nano /etc/nginx/conf.d/http.conf
```

```nginx
upstream php-handler {
server unix:/run/php/php8.0-fpm.sock;
}

server {
  listen 80 default_server;
  listen [::]:80 default_server;
  server_name nextcloud.exemple.ca;
  root /var/www;
  location ^~ /.well-known/acme-challenge {
  default_type text/plain;
  root /var/www/letsencrypt;
  }
  location / {
  return 301 https://$host$request_uri;
  }
}
```





We then edit our nextcloud configuration. Copy and paste the editing and change the information with your actual variables.

```shell
sudo nano /etc/nginx/sites-available/nextcloud.conf
```

```nginx
server {
listen 443 ssl http2;
listen [::]:443 ssl http2;
server_name nextcloud.exemple.ca;
ssl_certificate /etc/ssl/certs/ssl-cert-snakeoil.pem;
ssl_certificate_key /etc/ssl/private/ssl-cert-snakeoil.key;
ssl_trusted_certificate /etc/ssl/certs/ssl-cert-snakeoil.pem;
#ssl_certificate /etc/letsencrypt/rsa-certs/fullchain.pem;
#ssl_certificate_key /etc/letsencrypt/rsa-certs/privkey.pem;
#ssl_certificate /etc/letsencrypt/ecc-certs/fullchain.pem;
#ssl_certificate_key /etc/letsencrypt/ecc-certs/privkey.pem;
#ssl_trusted_certificate /etc/letsencrypt/ecc-certs/chain.pem;
ssl_dhparam /etc/ssl/certs/dhparam.pem;
ssl_session_timeout 1d;
ssl_session_cache shared:SSL:50m;
ssl_session_tickets off;
ssl_protocols TLSv1.3 TLSv1.2;
ssl_ciphers 'TLS-CHACHA20-POLY1305-SHA256:TLS-AES-256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384';
ssl_ecdh_curve X448:secp521r1:secp384r1;
ssl_prefer_server_ciphers on;
ssl_stapling on;
ssl_stapling_verify on;
client_max_body_size 10G;
fastcgi_buffers 64 4K;
gzip on;
gzip_vary on;
gzip_comp_level 4;
gzip_min_length 256;
gzip_proxied expired no-cache no-store private no_last_modified no_etag auth;
gzip_types application/atom+xml application/javascript application/json application/ld+json application/manifest+json application/rss+xml application/vnd.geo+json application/vnd.ms-fontobject application/x-font-ttf application/x-web-app-manifest+json application/xhtml+xml application/xml font/opentype image/bmp image/svg+xml image/x-icon text/cache-manifest text/css text/plain text/vcard text/vnd.rim.location.xloc text/vtt text/x-component text/x-cross-domain-policy;
add_header Strict-Transport-Security            "max-age=15768000; includeSubDomains; preload;" always;
add_header Permissions-Policy                   "interest-cohort=()";
add_header Referrer-Policy                      "no-referrer"   always;
add_header X-Content-Type-Options               "nosniff"       always;
add_header X-Download-Options                   "noopen"        always;
add_header X-Frame-Options                      "SAMEORIGIN"    always;
add_header X-Permitted-Cross-Domain-Policies    "none"          always;
add_header X-Robots-Tag                         "none"          always;
add_header X-XSS-Protection                     "1; mode=block" always;
fastcgi_hide_header X-Powered-By;
root /var/www/nextcloud;
index index.php index.html /index.php$request_uri;
location = / {
if ( $http_user_agent ~ ^DavClnt ) {
return 302 /remote.php/webdav/$is_args$args;
}
}
location = /robots.txt {
allow all;
log_not_found off;
access_log off;
}
location ^~ /apps/rainloop/app/data {
deny all;
}
location ^~ /.well-known {
location = /.well-known/carddav { return 301 /remote.php/dav/; }
location = /.well-known/caldav  { return 301 /remote.php/dav/; }
location /.well-known/acme-challenge { try_files $uri $uri/ =404; }
location /.well-known/pki-validation { try_files $uri $uri/ =404; }
return 301 /index.php$request_uri;
}
location ~ ^/(?:build|tests|config|lib|3rdparty|templates|data)(?:$|/)  { return 404; }
location ~ ^/(?:\.|autotest|occ|issue|indie|db_|console)                { return 404; }
location ~ \.php(?:$|/) {
rewrite ^/(?!index|remote|public|cron|core\/ajax\/update|status|ocs\/v[12]|updater\/.+|oc[ms]-provider\/.+|.+\/richdocumentscode\/proxy) /index.php$request_uri;
fastcgi_split_path_info ^(.+?\.php)(/.*)$;
set $path_info $fastcgi_path_info;
try_files $fastcgi_script_name =404;
include fastcgi_params;
fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
fastcgi_param PATH_INFO $path_info;
fastcgi_param HTTPS on;
fastcgi_param modHeadersAvailable true;
fastcgi_param front_controller_active true;
fastcgi_pass php-handler;
fastcgi_intercept_errors on;
fastcgi_request_buffering off;
fastcgi_read_timeout 3600;
fastcgi_send_timeout 3600;
fastcgi_connect_timeout 3600;
}
location ~ \.(?:css|js|svg|gif|png|jpg|ico)$ {
try_files $uri /index.php$request_uri;
expires 6M;
access_log off;
}
location ~ \.woff2?$ {
try_files $uri /index.php$request_uri;
expires 7d;
access_log off;
}
location /remote {
return 301 /remote.php$request_uri;
}
location / {
try_files $uri $uri/ /index.php$request_uri;
}
} 
```

> At this point, you should make sure that Nginx configuration is good. Use the nginx command with < -t > parameter as it will read the configuration files from /etc/nginx and tell you if the syntaxes looks good.

``` shell
sudo nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

If you received a confirmation that everything looks fine so far, you can link `.sites-available/nextcloud.conf` with `.sites-enabled/` 

```shell
sudo ln -s /etc/nginx/sites-available/nextcloud.exemple.ca /etc/nginx/sites-enabled/
```







After creating the link between the enabled file and real one, execute the following command to generate a new *Diffie-Hellman key*.

```shell
sudo openssl dhparam -dsaparam -out /etc/ssl/certs/dhparam.pem 4096
```

> This is creating a secure key using an exchange *Diffie-Hellman key* called **dhparam.pem**. It should be note that this key, like many others, should have a minimum length of **2048** and ideally a minimum length of **4096**. Also, it should be noted that depending on your system capacity, this could take a long time. Just be patient and enjoy something else while waiting.
> 

When it's done, restart nginx service

```shell
sudo service nginx restart
```







We can now actually install the actual Nextcloud software by downloading the last release and the md5 corresponding file for verification purpose.

```shell
cd /usr/local/src
```

```shell
wget https://download.nextcloud.com/server/releases/latest.tar.bz2
```

```shell
wget https://download.nextcloud.com/server/releases/latest.tar.bz2.md5
```

Verify the files

```
md5sum -c latest.tar.bz2.md5 < latest.tar.bz2
```

If everything is good, then you can extract the archive into /var/www directory. Next, we need to pass the correct permissions to www-data user. Then, remove the archive.

```shell
tar -xjf latest.tar.bz2 -C /var/www && sudo chown -R www-data:www-data /var/www/ && rm -f latest.tar.bz2
```

> *Before configuring and enabling secure communications with Let's Encrypt, make sure that you can actually be reached from outside your server with port 80/tcp and 443/tcp. This is overall specific to your dns-server setup, but in all cases,  you should be accessible from internet to get your certificates.*



We create a dedicated user name acmeuser who will handle our certificates. Also, add it to the `www-data` group.

```shell
sudo adduser --disabled-login acmeuser
```

```shell
sudo usermod -aG www-data acmeuser
```







We give this technical user the necessary authorizations to initiate the necessary web server start when a certificate is renewed.

```shell
sudo visudo
```

In the middle of the file ..:

```
[..]
User privilege specification
root ALL=(ALL:ALL) ALL
[...]
```

Enter the following

```
acmeuser ALL=NOPASSWD: /bin/systemctl reload nginx.service 
```







 We now switch to this user shell and we install the certificates authority server. Then, exit

```shell
su - acmeuser
curl https://get.acme.sh | sh
exit
```

Adjust the required permissions on the following directories. Those are basically restrictions for everyone except the web server user account  `www-data`

```shell
sudo chmod -R 775 /var/www/letsencrypt && sudo chmod -R 770 /etc/letsencrypt && sudo chown -R www-data:www-data /var/www/ /etc/letsencrypt
```

Set Let's Encrypt as the default CA for your server 

```shell
su - acmeuser -c ".acme.sh/acme.sh --set-default-ca --server letsencrypt" 
```

And then switch to the new user's shell again

```shell
su - acmeuser
```





> About acme.sh, you should go on and read more on how you should specifically use it depending on where is your domain register with nameservers. It can widely be a different command depending on your provider and is beyond the scope of the present guide. More information can be found on the [official acme.sh GitHub repo](https://github.com/acmesh-official/acme.sh). In my case, I am using [Cloudflare](https://www.cloudflare.com/en-ca/) as it provides a free way to optimize and secure my websites. Cloudflare’s free services act as a reverse proxy for your website providing some kind of hosting for your domain name. If you do not use Cloudflare, the following API part should be skip and the `dns_cf` should be omit from the general `acme.sh` commands below. 

For [Cloudflare API Token](https://github.com/acmesh-official/acme.sh/wiki/dnsapi), login to your account and go to your [profile](https://dash.cloudflare.com/profile). You should then copy your API Key from the API keys section so you can export it with the following commands format :

```
export CF_Key="mysecretapikeyfromcloudflare"
```

```
export CF_Email="username@email.com"
```





Now request the SSL certificates from Let's Encrypt and replace **nextcloud.exemple.ca** with your own domain. Exit after you received confirmation from CA.

```shell
acme.sh --issue --dns_cf -d nextcloud.exemple.ca --server letsencrypt --keylength 4096 -w /var/www/letsencrypt --key-file /etc/letsencrypt/rsa-certs/privkey.pem --ca-file /etc/letsencrypt/rsa-certs/chain.pem --cert-file /etc/letsencrypt/rsa-certs/cert.pem --fullchain-file /etc/letsencrypt/rsa-certs/fullchain.pem --reloadcmd "sudo /bin/systemctl reload nginx.service"
```

```shell
acme.sh --issue  --dns_cf -d nextcloud.exemple.ca --server letsencrypt --keylength ec-384 -w /var/www/letsencrypt --key-file /etc/letsencrypt/ecc-certs/privkey.pem --ca-file /etc/letsencrypt/ecc-certs/chain.pem --cert-file /etc/letsencrypt/ecc-certs/cert.pem --fullchain-file /etc/letsencrypt/ecc-certs/fullchain.pem --reloadcmd "sudo /bin/systemctl reload nginx.service"
```

```shell
exit
```





We will now create a script with the purpose of setting the right permissions to different files and directories. If you ever have difficulties with permissions after messing your configuration, you can run this script again to set permissions back to the right ones. Also, you should save create this script and run it as root so it is held only by the root and cannot be execute from another user.

```shell
sudo -i
```

```shell
cd
```

```shell
nano /root/permissions.sh 
```

```shell
#!/bin/bash
find /var/www/ -type f -print0 | xargs -0 chmod 0640
find /var/www/ -type d -print0 | xargs -0 chmod 0750
chmod -R 775 /var/www/letsencrypt
chmod -R 770 /etc/letsencrypt
chown -R www-data:www-data /var/www /etc/letsencrypt
chown -R www-data:www-data /var/nc-data
chmod 0644 /var/www/nextcloud/.htaccess
chmod 0644 /var/www/nextcloud/.user.ini
exit 0
```

Make this script as executable

```shell
chmod +x /root/permissions.sh
```

To run this script

```shell
./root/permissions.sh
```

Remove your previously used self-signed certificates from nginx and activate the new, full-fledged and already valid SSL certificates from Let's Encrypt

```shell
sed -i '/ssl-cert-snakeoil/d' /etc/nginx/sites-available/nextcloud.conf
sed -i s/#\ssl/\ssl/g /etc/nginx/sites-available/nextcloud.conf
```

Logout of root

```shell
exit
```

Verify your nginx configuration and link your modifications with the sites-enabled directory

```shell
sudo nginx -t
```

```shell
sudo ln -s /etc/nginx/sites-available/nextcloud.conf /etc/nginx/sites-enabled/
```



Restart nginx

```shell
sudo service nginx restart
```



In order to automatically renew the SSL certificates as well as to initiate the necessary web server restart, a cron job was automatically created.  

```shell
crontab -l -u acmeuser
```

> *We can now proceed with setting up the Nextcloud. To do this, use the following "silent" installation command. Make sur to change this command with the right parameters for your configuration where
>
> **databasename** was named during mariadb setup
> **useraccount** was named during mariadb setup
> **mysecretpassword** was named during mariadb setup
> **adminuser** is up to you - will be use as admin account on Nextcloud
> **adminpass** is up to you - for authentication of this new admin user

```shell
sudo -u www-data php /var/www/nextcloud/occ maintenance:install --database "mysql" --database-name "<databasename>" --database-user "<useraccount>" --database-pass "<mysecretpassword>" --admin-user "<adminuser>" --admin-pass "<adminpass>" --data-dir "/www/nc-data"
```





Add your domain as a trusted domain in nextcloud configuration. For this, change the following commands, supplementing **nextcloud.exemple.ca** with your dedicated domain. 

```shell
sudo -u www-data php /var/www/nextcloud/occ config:system:set trusted_domains 0 --value=nextcloud.exemple.ca
```

```shell
sudo -u www-data php /var/www/nextcloud/occ config:system:set overwrite.cli.url --value=https://nextcloud.exemple.ca
```





Now we finally expand the Nextcloud configuration. First save the existing config.php and then execute the following lines in a block

```shell
sudo -u www-data cp /var/www/nextcloud/config/config.php /var/www/nextcloud/config/config.php.back 
```

```shell
sudo -u www-data sed -i 's/^[ ]*//' /var/www/nextcloud/config/config.php
```

```shell
sudo -u www-data sed -i '/);/d' /var/www/nextcloud/config/config.php
```

```shell
sudo -u www-data cat <<EOF >>/var/www/nextcloud/config/config.php
```

```shell
'activity_expire_days' => 14,
'auth.bruteforce.protection.enabled' => true,
'blacklisted_files' =>
array (
0 => '.htaccess',
1 => 'Thumbs.db',
2 => 'thumbs.db',
),
'cron_log' => true,
'default_phone_region' => 'EN',
'enable_previews' => true,
'enabledPreviewProviders' =>
array (
0 => 'OC\Preview\PNG',
1 => 'OC\Preview\JPEG',
2 => 'OC\Preview\GIF',
3 => 'OC\Preview\BMP',
4 => 'OC\Preview\XBitmap',
5 => 'OC\Preview\Movie',
6 => 'OC\Preview\PDF',
7 => 'OC\Preview\MP3',
8 => 'OC\Preview\TXT',
9 => 'OC\Preview\MarkDown',
),
'filesystem_check_changes' => 0,
'filelocking.enabled' => 'true',
'htaccess.RewriteBase' => '/',
'integrity.check.disabled' => false,
'knowledgebaseenabled' => false,
'logfile' => '/var/nc-data/nextcloud.log',
'loglevel' => 2,
'logtimezone' => 'America/Montreal',
'log_rotate_size' => 104857600,
'maintenance' => false,
'memcache.local' => '\OC\Memcache\APCu',
'memcache.locking' => '\OC\Memcache\Redis',
'overwriteprotocol' => 'https',
'preview_max_x' => 1024,
'preview_max_y' => 768,
'preview_max_scale_factor' => 1,
'redis' =>
array (
'host' => '/var/run/redis/redis-server.sock',
'port' => 0,
'timeout' => 0.0,
),
'quota_include_external_storage' => false,
'share_folder' => '',
'skeletondirectory' => '',
'theme' => '',
'trashbin_retention_obligation' => 'auto, 7',
'updater.release.channel' => 'stable',
);
EOF
```





Modify the ".user.ini" 

```shell
sudo -u www-data sed -i "s/output_buffering=.*/output_buffering=0/" /var/www/nextcloud/.user.ini
```



You can also disable the basic app survey-client and firstrunwizard. Also enable the *admin_audit* and *pdf viewer* if needed

```shell
sudo -u www-data php /var/www/nextcloud/occ app:disable survey_client
```

```shell
sudo -u www-data php /var/www/nextcloud/occ app:disable firstrunwizard
```

```shell
sudo -u www-data php /var/www/nextcloud/occ app:enable admin_audit
```

```shell
sudo -u www-data php /var/www/nextcloud/occ app:enable files_pdfviewer
```



Nextcloud is now fully operational, optimized and secured. Restart all relevant services before you actually start using it.

```shell
sudo service nginx stop
```

```shell
sudo systemctl stop php8.0-fpm
```

```shell
sudo systemctl restart mariadb 
```

```shell
sudo systemctl restart php8.0-fpm
```

```shell
sudo systemctl restart redis-server
```

```shell
sudo service nginx restart
```



We will add a new cronjob for Nextcloud web server user `www-data`, by entering the following at the end of the file

```shell
sudo crontab -u www-data -e
```

```shell
[...]
*/5 * * * * php -f /var/www/nextcloud/cron.php > /dev/null 2>&1
```

Enable Nextcloud to use cron for background checking

```shell
sudo -u www-data php /var/www/nextcloud/occ background:cron
```



## Hardening (fail2ban and ufw)



First we install `fail2ban` to protect the server against brute force attacks and incorrect login attempts

```shell
sudo apt update && sudo apt install fail2ban -y
```

> Fail2ban is a security utility programs that act as a firewall when users attend to login. We can specified fail2ban parameters with filtrers and decided of the consequences with a jail file. This way, we can block multiple unatended attempts to our server and prevent bruteforce attacks & some DDoS attacks.



```shell
sudo touch /etc/fail2ban/filtrer.d/nextcloud.conf
```



Copy everything from `cat` till the end. Paste it in your terminal and run it

```
{% raw %}
cat <<EOF >/etc/fail2ban/filter.d/nextcloud.conf
[Definition]
_groupsre = (?:(?:,?\s*"\w+":(?:"[^"]+"|\w+))*)
failregex = ^\{%(_groupsre)s,?\s*"remoteAddr":"<HOST>"%(_groupsre)s,?\s*"message":"Login failed:
            ^\{%(_groupsre)s,?\s*"remoteAddr":"<HOST>"%(_groupsre)s,?\s*"message":"Trusted domain error.
datepattern = ,?\s*"time"\s*:\s*"%%Y-%%m-%%d[T ]%%H:%%M:%%S(%%z)?"
EOF
{% endraw %}
```



We can now create the jail file for Nextcloud and copy-paste the following. You can change the last line ***logpath*** if you want to change where the logs are saved.

```shell
sudo nano /etc/fail2ban/jail.d/nextcloud.local
```

```shell
[nextcloud]
backend = auto
enabled = true
port = 80,443
protocol = tcp
filter = nextcloud
maxretry = 5
bantime = 3600
findtime = 36000
logpath =  /var/nc-data /nextcloud.log
```

> *With the parameters shown above, we are setting the results, as a jail, for the filtrer we created. It can be read as followed :*\
> *after 5 incorrect login attempts ( **maxretry** )\
> within the last 36000 seconds ( **above findtime** )\
> the IP of the potential attacker ( **filtrered subject** )\
> is blocked for 3600 seconds ( **bantime** )*



Restart fail2ban, check fail2ban status and then enable it

```shell
sudo service fail2ban restart 
```

```shell
sudo fail2ban-client status nextcloud 
```

```shell
sudo service fail2ban enable
```



Finally, we will installed the uncomplicated firewall `ufw` and set the connection firewall accordingly to our needs. If you use a different port than 22 for SSH remote connection to your server make sure to change the ufw rule above to fit the right one

```shell
sudo apt install ufw -y
```

```shell
sudo ufw allow 80/tcp
```

```shell
sudo ufw allow 443/tcp
```

```shell
sudo ufw allow 22/tcp
```

> **Optional** - You can use the following command to make *ssh* connection only available from inside your network. This should be considered and enabled. Having your server accessible with *ssh* from outside your network can lead in various security threats. 



If you decide to make it only accessible within your network, use the following where `192.168.1.0/24` is changed with the actual `LAN` ip address of your network.

```shell
sudo ufw allow proto tcp from 192.168.1.0/24 to any port 22
```

Set the firewall logging level and prevent undefined incoming connections

```shell
sudo ufw logging medium
```

```shell
sudo ufw default deny incoming 
```

To activate and restart the firewall, issue the following

```shell
sudo ufw enable
```

```shell
sudo ufw restart
```

