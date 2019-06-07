#FROM debian:stretch-slim
FROM debian:stretch

RUN apt install curl gnupg2 ca-certificates lsb-release \
 && echo "deb http://nginx.org/packages/mainline/debian $(lsb_release -cs) nginx" | tee /etc/apt/sources.list.d/nginx.list \
 && curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add - \
 && apt update \
 && apt install nginx


