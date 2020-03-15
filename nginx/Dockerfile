#FROM debian:stretch-slim
#FROM debian:stretch AS runner
#FROM bitnami/minideb:stretch
FROM bitnami/minideb:buster
#FROM bitnami/minideb-extras-base:stretch

ARG NC_REDIS_PASS
ARG NC_MARIADB_PASS
ARG NC_MARIADB_ROOT
ARG NC_UID=1003
ENV NC_REDIS_PASS=${NC_REDIS_PASS:-"SVRMB36F56v3Ahi7la9qZ0xjthuOmOFyTSSUPEdHwU"}
ENV NC_MARIADB_PASS=${NC_MARIADB_PASS}
ENV NC_MARIADB_ROOT=${NC_MARIADB_ROOT}
ENV NC_VER 16
ENV NC_URL https://download.nextcloud.com/server/releases
ENV NC_BASE_DIR /opt
ENV NC_ROOTDIR /opt/nextcloud

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
                   php-apcu imagemagick php-imagick \
# && sed -i "s/NAME=php-fpm7.3/NAME=php7.3-fpm/g" /etc/init.d/php7.3-fpm \
 && echo "------- Installing php7.3 finished -------"

# Using own nextcloud.conf, customize yourself
COPY files/nextcloud.conf /etc/nginx/conf.d/
# Using letsencrypt, customization is postponed.
COPY files/letsencrypt.conf /etc/nginx/conf.d/
# Equip with enhanced dhparams and selfsigned cert
COPY files/dhparam.pem /etc/ssl/certs/
COPY files/nc.crt /etc/ssl/certs/
COPY files/nc.key /etc/ssl/private/
# Copy all shell-scripts for further configuration to /usr/local/bin
#COPY files/*.sh /usr/local/bin/

# ---------- deprecated begin -----------
# --- Install Acmetools latest Version
#RUN echo "------- Installing acmetools -------" \
# && echo "deb http://ppa.launchpad.net/hlandau/rhea/ubuntu xenial main" | tee /etc/apt/sources.list.d/rhea.list \
# && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 9862409EF124EC763B84972FF5AC9651EDB58DFA \
# && apt update \
# && apt -y install acmetool
#COPY files/acme-target /var/lib/acme/conf/target
#COPY files/acme-responses /var/lib/acme/conf/responses
# ---------- deprecated end -------------
# --- Install  kshcherban/acme-nginx latest Version
RUN echo "------- Installing kshcherban/acme-nginx -------" \
 && echo "curl -fsSL -o /usr/local/bin/acme-nginx https://github.com/kshcherban/acme-nginx/releases/download/v0.1.2/acme-nginx" \
 && curl -fsSL -o /usr/local/bin/acme-nginx https://github.com/kshcherban/acme-nginx/releases/download/v0.1.2/acme-nginx \
 && chmod +x /usr/local/bin/acme-nginx

# --- Install Nextcloud latest Version of 16 + preparation for letsencrypt-acme
RUN echo "------- Installing Nextcloud V16.0.x -------" \
# && curl -L -k -o $NC_BASE_DIR/latest-$NC_VER.tar.bz2 $NC_URL/latest-$NC_VER.tar.bz2 \
# && tar -xjf $NC_BASE_DIR/latest-$NC_VER.tar.bz2 -C /opt \
# && rm latest-$NC_VER.tar.bz2
 && curl -L -k $NC_URL/latest-$NC_VER.tar.bz2 | tar -xjf - -C $NC_BASE_DIR \
 && mkdir -p -m 0775 /var/log/nextcloud \
 && chgrp www-data /var/log/nextcloud \
# && mkdir $NC_ROOTDIR/.well-known \
 && chown -R www-data:www-data $NC_BASE_DIR \
 && mkdir -p /var/letsencrypt/.well-known/acme-challenge \
 && chown -R www-data:www-data /var/letsencrypt \
# && ln -s /var/letsencrypt $NC_BASE_DIR/.well-known/acme-challenge \
 && echo "--------- Finished Nextcloud V16.0.x install ----------------"
  

# just for debugging purposes

COPY files/bash_aliases.sh /etc/profile.d/
#  Some additional debug tools are added
RUN echo "starting to install some useful monitoring tools" \
 && apt update \
 && apt -y install procps net-tools socat less atop iftop \
 && apt -y install vim dnsutils iputils-ping iproute2 php7.3-cli \
 && apt -y install anacron \
 && ln /etc/profile.d/bash_aliases.sh /usr/local/bin/aliases \
 && chmod 0755 /usr/local/bin/aliases \
 && usermod -s /bin/bash www-data \
 && usermod -d ${NC_ROOTDIR} www-data \
 && echo "Finished extra install"

# Copy all shell-scripts for further configuration to /usr/local/bin
COPY files/*.sh /usr/local/bin/
COPY files/entrypoint.sh /

# USER does not work here, we need root.
#USER $NC_UID
#ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/bin/bash" ]
#CMD ["/usr/sbin/nginx", "-g", "daemon off;"]

