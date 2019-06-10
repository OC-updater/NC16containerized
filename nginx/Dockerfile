#FROM debian:stretch-slim
#FROM debian:stretch AS runner
FROM bitnami/minideb:stretch
#FROM bitnami/minideb-extras-base:stretch

# --- Install nginx
RUN apt update \
 && apt -y install apt-transport-https curl gnupg2 ca-certificates lsb-release \
 && echo "deb http://nginx.org/packages/mainline/debian $(lsb_release -cs) nginx" | tee /etc/apt/sources.list.d/nginx.list \
 && curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add - \
 && apt update \
 && apt -y install nginx

COPY files/nginx.conf /etc/nginx/
COPY files/ssl.conf /etc/nginx/

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


#  Some additional debug tools are added
RUN echo "starting to install some useful monitoring tools" \
 && apt update \
 && apt -y install procps net-tools socat less \
 && apt -y install php7.3-cli \
 && echo "Finished extra install"
COPY files/bash_aliases.sh /etc/profile.d/


