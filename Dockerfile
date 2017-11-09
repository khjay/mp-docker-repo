FROM ubuntu:xenial
MAINTAINER SinJie <sjzeng@gmail.com>

ENV OS_LOCALE="en_US.UTF-8"
RUN apt-get update && apt-get install -y locales tzdata && locale-gen ${OS_LOCALE}
ENV LANG=${OS_LOCALE} \
    LANGUAGE=en_US:en \
    LC_ALL=${OS_LOCALE}

RUN apt-get install -y software-properties-common python-software-properties \
        && add-apt-repository -y ppa:ondrej/php \
        && apt-get update \
        && apt-get install -y curl apache2 supervisor wget git \
        && apt-get install -y php7.1 php7.1-mysql php7.1-cli php7.1-common php7.1-curl php7.1-gd php7.1-intl php7.1-json php7.1-mbstring php7.1-mcrypt php7.1-pgsql php7.1-xml php7.1-zip libapache2-mod-php7.1 php7.1-curl php7.1-readline \
        && a2enmod rewrite php7.1 \
        && phpenmod mcrypt \
        && service apache2 restart \
        && curl -sS https://getcomposer.org/installer | php --  --install-dir=/usr/local/bin --filename=composer

RUN apt-get purge -y --auto-remove software-properties-common python-software-properties \
        && apt-get autoremove -y \
        && rm -rf /var/lib/apt/lists/* \
        && echo "<?php echo phpinfo();" > /var/www/html/index.php

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
EXPOSE 80 443
