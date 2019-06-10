#FROM debian:stretch-slim
#FROM debian:stretch AS runner
FROM bitnami/minideb:stretch
#FROM bitnami/minideb-extras-base:stretch

ENV NC_VER 16
ENV NC_URL https://download.nextcloud.com/server/releases
ENV NC_BASE_DIR /opt

# --- Install nginx
RUN apt update \
 && apt -y install apt-transport-https curl gnupg2 ca-certificates lsb-release \
 && echo "deb http://nginx.org/packages/mainline/debian $(lsb_release -cs) nginx" | tee /etc/apt/sources.list.d/nginx.list \
 && curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add - \
 && apt update \
 && apt -y install nginx

COPY files/nginx.conf /etc/nginx/
COPY files/ssl.conf /etc/nginx/
COPY files/proxy.conf /etc/nginx/
COPY files/header.conf /etc/nginx/
COPY files/optimization.conf /etc/nginx/
COPY files/php_optimization.conf /etc/nginx/

# --- Install php7.3
RUN echo "------- Installing php7.3 -------" \ 
 && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php7.3.list \
 && curl -fsSL -o /etc/apt/trusted.gpg.d/php7.3.gpg https://packages.sury.org/php/apt.gpg \
 && apt-key add /etc/apt/trusted.gpg.d/php7.3.gpg \ 
 && apt update \
 && apt -y install php7.3 php7.3-fpm php7.3-gd php7.3-mysql php7.3-curl php7.3-xml php7.3-zip \
                   php7.3-intl php7.3-mbstring php7.3-json php7.3-bz2 php7.3-ldap \
                   php-apcu imagemagick php-imagick

# Using own nextcloud.conf, customize yourself
COPY files/nextcloud.conf /etc/nginx/conf.d/
# Using letsencrypt, customization is postponed.
COPY files/letsencrypt.conf /etc/nginx/conf.d/
# Equip with enhanced dhparams and selfsigned cert
COPY files/dhparam.pem /etc/ssl/certs/
COPY files/nc.crt /etc/ssl/certs/
COPY files/nc.key /etc/ssl/private/

# --- Install Acmetools latest Version
RUN echo "------- Installing acmetools -------" \
 && echo "deb http://ppa.launchpad.net/hlandau/rhea/ubuntu xenial main" | tee /etc/apt/sources.list.d/rhea.list \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 9862409EF124EC763B84972FF5AC9651EDB58DFA \
 && apt update \
 && apt -y install acmetool

# --- Install Nextcloud latest Version of 16 + preparation for letsencrypt-acme
RUN echo "------- Installing Nextcloud V16.0.x -------" \
# && curl -L -k -o $NC_BASE_DIR/latest-$NC_VER.tar.bz2 $NC_URL/latest-$NC_VER.tar.bz2 \
# && tar -xjf $NC_BASE_DIR/latest-$NC_VER.tar.bz2 -C /opt \
# && rm latest-$NC_VER.tar.bz2
 && curl -L -k $NC_URL/latest-$NC_VER.tar.bz2 | tar -xjf - -C $NC_BASE_DIR \
 && mkdir $NC_BASE_DIR/.well-known \
 && chown -R www-data:www-data $NC_BASE_DIR \
 && mkdir /var/letsencrypt \
 && chown -R www-data:www-data /var/letsencrypt \
 && ln -s /var/letsencrypt $NC_BASE_DIR/.well-known/acme-challenge 
  

# just for debugging purposes

COPY files/bash_aliases.sh /etc/profile.d/
#  Some additional debug tools are added
RUN echo "starting to install some useful monitoring tools" \
 && apt update \
 && apt -y install procps net-tools socat less \
 && apt -y install vim dnsutils iputils-ping iproute2 php7.3-cli \
 && ln /etc/profile.d/bash_aliases.sh /usr/local/bin/aliases \
 && chmod 0755 /usr/local/bin/aliases \
 && echo "Finished extra install"


