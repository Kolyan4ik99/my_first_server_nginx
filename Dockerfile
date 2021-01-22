FROM debian:buster

RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y wget nginx php7.3 \
php-mysql php-fpm php-mbstring mariadb-server

WORKDIR /var/www/html/
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-english.tar.gz
RUN tar -xvzf phpMyAdmin-5.0.1-english.tar.gz && rm -rf phpMyAdmin-5.0.1-english.tar.gz
RUN mv phpMyAdmin-5.0.1-english phpmyadmin

RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xvzf latest.tar.gz && rm -rf latest.tar.gz

RUN openssl req -x509 -nodes -days 365 \
    -subj "/C=RU/ST=Tatarstan/L=Kazan/O=21school/OU=21kazan/CN=cclock" \
    -newkey rsa:2048 -keyout /etc/ssl/nginx-selfsigned.key -out /etc/ssl/nginx-selfsigned.crt;

RUN chown -R www-data:www-data *
RUN chmod -R 755 /var/www/*

COPY ./srcs/nginx.conf /etc/nginx/sites-available/localhost
RUN ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/
RUN rm -f /etc/nginx/sites-enabled/default

COPY ./srcs/config.inc.php phpmyadmin
COPY ./srcs/wp-config.php /var/www/html
COPY ./srcs/init.sh ./

CMD ./init.sh bash